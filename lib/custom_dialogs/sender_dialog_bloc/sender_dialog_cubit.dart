import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nocab/custom_dialogs/sender_dialog_bloc/sender_dialog_state.dart';
import 'package:nocab/services/database/database.dart';
import 'package:nocab/services/network/network.dart';
import 'package:nocab_core/nocab_core.dart';

class SenderDialogCubit extends Cubit<SenderDialogState> {
  SenderDialogCubit() : super(const SenderInit());

  Transfer? _transfer;

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
      return filePickerResult?.files.map((file) => FileInfo.fromFile(File(file.path!))).toList();
    });

    if (files == null) {
      emit(const FileSelectCancel());
    } else {
      emit(FileConfirmation(files));
    }
  }

  Future<void> send({required DeviceInfo serverDeviceInfo, required List<FileInfo> files}) async {
    emit(Connecting(serverDeviceInfo));

    ShareRequest shareRequest =
        RequestMaker.create(files: files, transferPort: await Network.getUnusedPort(), controlPort: await Network.getUnusedPort());

    Database().registerRequest(
      request: shareRequest,
      receiverDeviceInfo: serverDeviceInfo,
      senderDeviceInfo: shareRequest.deviceInfo,
      thisIsSender: true,
    );

    try {
      RequestMaker.requestTo(serverDeviceInfo, request: shareRequest);
      emit(RequestSent(serverDeviceInfo));
    } catch (e) {
      emit(TransferFailed(serverDeviceInfo, e.toString()));
      return;
    }

    var response = await shareRequest.onResponse;

    if (!response.response) {
      emit(RequestRejected(response.info ?? ""));
      return;
    }

    emit(RequestAccepted(serverDeviceInfo));
    _transfer = shareRequest.linkedTransfer!;
    shareRequest.linkedTransfer!.onEvent.listen((event) {
      switch (event.runtimeType) {
        case ProgressReport:
          event as ProgressReport;
          emit(Transferring(
            shareRequest.files,
            event.filesTransferred,
            event.currentFile,
            event.speed / 1000 / 1000,
            event.progress * 100,
            shareRequest.deviceInfo,
          ));
          break;
        case EndReport:
          event as EndReport;
          emit(TransferSuccess(serverDeviceInfo, shareRequest.files));
          break;
        case ErrorReport:
          event as ErrorReport;
          emit(TransferFailed(serverDeviceInfo, event.error.title));
          break;
        case CancelReport:
          event as CancelReport;
          emit(TransferCancelled(serverDeviceInfo));
          break;
        default:
      }
    });
  }

  void cancel() {
    _transfer?.cancel();
  }
}
