import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nocab/custom_dialogs/sender_dialog_bloc/sender_dialog_state.dart';
import 'package:nocab/models/database/transfer_db.dart';
import 'package:nocab/models/deviceinfo_model.dart';
import 'package:nocab/models/file_model.dart';
import 'package:nocab/services/database/database.dart';
import 'package:nocab/services/network/network.dart';
import 'package:nocab/services/settings/settings.dart';
import 'package:nocab/services/transfer/report_models/data_report.dart';
import 'package:nocab/services/transfer/report_models/end_report.dart';
import 'package:nocab/services/transfer/report_models/error_report.dart';
import 'package:nocab/services/transfer/sender.dart';
import 'package:uuid/uuid.dart';

class SenderDialogCubit extends Cubit<SenderDialogState> {
  SenderDialogCubit() : super(const SenderInit());

  Future<void> start(List<FileInfo>? files) async {
    if (files?.isNotEmpty ?? false) return emit(FileConfirmation(files!));

    await _pickFiles();
  }

  Future<void> _pickFiles() async {
    emit(const FileCacheLoading());

    List<FileInfo>? files = await FilePicker.platform
        .pickFiles(
            allowMultiple: true,
            onFileLoading: (p0) {
              // TODO: İmplement which file is loading
              emit(const FileCacheLoading());
            })
        .then((filePickerResult) {
      return filePickerResult?.files
          .map((file) => FileInfo(name: file.name, byteSize: file.size, path: file.path, hash: "unused", isEncrypted: false))
          .toList();
    });

    if (files == null) {
      emit(const FileSelectCancel());
    } else {
      emit(FileConfirmation(files));
    }
  }

  Future<void> send({required DeviceInfo serverDeviceInfo, required List<FileInfo> files}) async {
    emit(Connecting(serverDeviceInfo));

    ShareRequest shareRequest = ShareRequest(
      deviceInfo: DeviceInfo(
        name: SettingsService().getSettings.deviceName,
        ip: await SettingsService().getCurrentIp,
        port: SettingsService().getSettings.mainPort,
        opsystem: Platform.operatingSystem,
        deviceId: "",
      ),
      files: files,
      transferPort: await Network.getUnusedPort(),
    )..transferUuid = const Uuid().v4();

    Database().pushTransferToDb(TransferDatabase()
      ..receiverDevice = serverDeviceInfo.toIsarDb()
      ..senderDevice = shareRequest.deviceInfo.toIsarDb(isCurrentDevice: true)
      ..files = shareRequest.files.map((e) => e.toIsarDb()).toList()
      ..transferUuid = shareRequest.transferUuid!
      ..requestedAt = DateTime.now()
      ..status = TransferDbStatus.pendingForAcceptance
      ..type = TransferDbType.upload
      ..managedBy = TransferDbManagedBy.user);

    Socket socket;

    try {
      socket = await Socket.connect(serverDeviceInfo.ip, serverDeviceInfo.port);
      socket.write(base64.encode(utf8.encode(json.encode(shareRequest.toJson()))));
      emit(RequestSent(serverDeviceInfo));
    } on SocketException catch (e) {
      await Database()
          .updateTransfer(shareRequest.transferUuid!, status: TransferDbStatus.error, managedBy: TransferDbManagedBy.user, message: e.message);
      return emit(TransferFailed(serverDeviceInfo, e.message));
    } catch (e) {
      await Database().updateTransfer(
        shareRequest.transferUuid!,
        status: TransferDbStatus.error,
        managedBy: TransferDbManagedBy.user,
        message: e.toString(),
      );
      return emit(TransferFailed(serverDeviceInfo, e.toString()));
    }

    ShareResponse response;

    try {
      response = ShareResponse.fromJson(json.decode(utf8.decode(base64.decode(utf8.decode(await socket.first)))));
    } on StateError {
      await Database().updateTransfer(
        shareRequest.transferUuid!,
        status: TransferDbStatus.error,
        managedBy: TransferDbManagedBy.user,
        message: "Connection Lost, Cannot read response",
      );
      return emit(TransferFailed(serverDeviceInfo, "Connection Lost, Cannot read response"));
    } catch (e) {
      await Database().updateTransfer(
        shareRequest.transferUuid!,
        status: TransferDbStatus.error,
        managedBy: TransferDbManagedBy.user,
        message: e.toString(),
      );
      return emit(TransferFailed(serverDeviceInfo, e.toString()));
    }

    socket.close();
    if (!response.response) {
      await Database().updateTransfer(shareRequest.transferUuid!, status: TransferDbStatus.declined, message: response.info);
      return emit(RequestRejected(response.info ?? ""));
    }

    emit(RequestAccepted(serverDeviceInfo));

    Sender(
      deviceInfo: serverDeviceInfo,
      files: files,
      transferPort: shareRequest.transferPort,
      uniqueId: shareRequest.transferUuid!,
    )
      ..start()
      ..onEvent.listen((event) {
        Database().updateTransferByReport(event);

        switch (event.runtimeType) {
          case DataReport:
            event as DataReport;
            emit(Transferring(event.files, event.filesTransferred, event.currentFile, event.speed, event.progress, event.deviceInfo));
            break;
          case EndReport:
            event as EndReport;
            emit(TransferSuccess(event.device, event.files));
            break;
          case ErrorReport:
            event as ErrorReport;
            emit(TransferFailed(event.device, event.message));
            break;
          default:
        }
      });
  }
}
