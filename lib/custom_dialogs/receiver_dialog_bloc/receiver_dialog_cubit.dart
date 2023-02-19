import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nocab/custom_dialogs/receiver_dialog_bloc/receiver_dialog_state.dart';
import 'package:nocab/services/database/database.dart';
import 'package:nocab_core/nocab_core.dart';
import 'package:path_provider/path_provider.dart';

class ReceiverDialogCubit extends Cubit<ReceiverDialogState> {
  ReceiverDialogCubit() : super(const ReceiverInit());

  StreamSubscription? _requestSubscription;

  Future<void> startReceiver() async {
    await Radar().start();
    await RequestListener().start(onError: (p0) => TransferFailed(null, p0.title));

    emit(ConnectionWait(DeviceManager().currentDeviceInfo));

    _requestSubscription = RequestListener().onRequest.listen((event) {
      stopReceiver();
      Database().registerRequest(
        request: event,
        receiverDeviceInfo: DeviceManager().currentDeviceInfo,
        senderDeviceInfo: event.deviceInfo,
        thisIsSender: false,
      );
      emit(RequestConfirmation(event, event.socket));
    });
  }

  Future<void> stopReceiver() async {
    _requestSubscription?.cancel();
    RequestListener().stop();
    Radar().stop();
  }

  Future<void> acceptRequest(ShareRequest request) async {
    emit(Connecting(request.deviceInfo));

    // initialize files for start transfer
    String? downloadPath = await getDownloadPath();

    if (downloadPath == null) return;

    request.accept(
      downloadDirectory: Directory(downloadPath),
      tempDirectory: await Directory.systemTemp.createTemp(),
      onError: (p0) => TransferFailed(request.deviceInfo, p0.title),
    );

    request.linkedTransfer?.onEvent.listen((event) {
      switch (event.runtimeType) {
        case ProgressReport:
          event as ProgressReport;
          emit(Transferring(
            request.files,
            event.filesTransferred,
            event.currentFile,
            event.speed / 1024 / 1024,
            event.progress * 100,
            request.deviceInfo,
          ));
          break;
        case EndReport:
          event as EndReport;
          emit(TransferSuccess(request.deviceInfo, request.files));
          break;
        case ErrorReport:
          event as ErrorReport;
          emit(TransferFailed(request.deviceInfo, event.error.title));
          break;
        default:
      }
    });
  }

  Future<void> rejectRequest(ShareRequest request, {String? message}) async {
    request.reject(info: message, onError: (p0) => TransferFailed(request.deviceInfo, p0.title));
  }

  Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      }
    } catch (err) {
      emit(TransferFailed(null, "Download directory not found:\n$err"));
    }
    return directory?.path;
  }
}
