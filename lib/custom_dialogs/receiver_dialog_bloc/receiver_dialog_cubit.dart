import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nocab/custom_dialogs/receiver_dialog_bloc/receiver_dialog_state.dart';
import 'package:nocab/models/database/transfer_db.dart';
import 'package:nocab/models/deviceinfo_model.dart';
import 'package:nocab/models/file_model.dart';
import 'package:nocab/services/database/database.dart';
import 'package:nocab/services/file_operations/file_operations.dart';
import 'package:nocab/services/settings/settings.dart';
import 'package:nocab/services/transfer/receiver.dart';
import 'package:nocab/services/transfer/report_models/data_report.dart';
import 'package:nocab/services/transfer/report_models/end_report.dart';
import 'package:nocab/services/transfer/report_models/error_report.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

class ReceiverDialogCubit extends Cubit<ReceiverDialogState> {
  ReceiverDialogCubit() : super(const ReceiverInit());

  ServerSocket? listenerSocket;
  ServerSocket? serverSocket;

  Future<void> _listenDevices(DeviceInfo deviceInfo) async {
    listenerSocket = await ServerSocket.bind(InternetAddress.anyIPv4, SettingsService().getSettings.finderPort);
    listenerSocket!.listen((socket) {
      socket.write(base64.encode(utf8.encode(json.encode(deviceInfo.toJson()))));
    });
  }

  Future<void> startReceiver() async {
    var clientDeviceInfo = DeviceInfo(
      name: SettingsService().getSettings.deviceName,
      ip: await SettingsService().getCurrentIp,
      port: SettingsService().getSettings.mainPort,
      opsystem: Platform.operatingSystemVersion,
      deviceId: "",
    );

    try {
      await _listenDevices(clientDeviceInfo);

      serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, SettingsService().getSettings.mainPort);

      emit(ConnectionWait(clientDeviceInfo));

      serverSocket?.listen(
        (socket) {
          socket.listen((event) {
            try {
              String socketData = utf8.decode(base64.decode(utf8.decode(event)));
              ShareRequest request = ShareRequest.fromJson(json.decode(socketData));
              //TODO: Database ban check
              //TODO: Fail2Ban
              stopReceiver();

              request.transferUuid = const Uuid().v4();
              Database().pushTransferToDb(TransferDatabase()
                ..senderDevice = request.deviceInfo.toIsarDb()
                ..receiverDevice = clientDeviceInfo.toIsarDb(isCurrentDevice: true)
                ..files = request.files.map((e) => e.toIsarDb()).toList()
                ..transferUuid = request.transferUuid!
                ..requestedAt = DateTime.now()
                ..status = TransferDbStatus.pendingForAcceptance
                ..type = TransferDbType.download
                ..managedBy = TransferDbManagedBy.user);

              emit(RequestConfirmation(request, socket));
            } catch (e) {
              socket.close();
            }
          });
        },
      );
    } on SocketException catch (e) {
      stopReceiver();
      emit(TransferFailed(
        null,
        "Message: ${e.message}\nOs Message: ${e.osError?.message}\nError Code: ${e.osError?.errorCode}\nAdress: ${e.address?.address}:${e.port}",
      ));
    }
  }

  Future<void> stopReceiver() async {
    await listenerSocket?.close();
    await serverSocket?.close();
  }

  Future<void> acceptRequest(ShareRequest request, Socket socket) async {
    emit(Connecting(request.deviceInfo));

    // initialize files for start transfer
    var downloadDirectory = await FileOperations.getDownloadPath();
    if (downloadDirectory == null) {
      return emit(TransferFailed(request.deviceInfo, "Download directory not found"));
    }

    request.files = request.files.map<FileInfo>((e) {
      e.path = FileOperations.findUnusedFilePath(
        fileName: e.name,
        downloadPath: p.joinAll([downloadDirectory, ...p.split(e.subDirectory ?? "")]), // TODO: add custom download path
      );
      return e;
    }).toList();

    ShareResponse shareResponse = ShareResponse(response: true);
    socket.write(base64.encode(utf8.encode(json.encode(shareResponse.toJson()))));
    socket.close();

    Database().updateTransfer(
      request.transferUuid!,
      status: TransferDbStatus.ongoing,
      managedBy: TransferDbManagedBy.user,
    );

    Receiver(
      deviceInfo: request.deviceInfo,
      files: request.files,
      transferPort: request.transferPort,
      uniqueId: request.transferUuid!,
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

  Future<void> rejectRequest(ShareRequest request, Socket socket, {String? message}) async {
    ShareResponse shareResponse = ShareResponse(response: false, info: message ?? "User rejected request");

    socket.write(base64.encode(utf8.encode(json.encode(shareResponse.toJson()))));
    await socket.close();
  }
}
