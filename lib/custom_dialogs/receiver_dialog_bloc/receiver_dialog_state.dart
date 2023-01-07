import 'dart:io';

import 'package:nocab_core/nocab_core.dart';

abstract class ReceiverDialogState {
  final bool canPop = false;
  const ReceiverDialogState();
}

class ReceiverInit extends ReceiverDialogState {
  const ReceiverInit();
}

class ConnectionWait extends ReceiverDialogState {
  final DeviceInfo deviceInfo;
  const ConnectionWait(this.deviceInfo);
}

class RequestConfirmation extends ReceiverDialogState {
  final ShareRequest shareRequest;
  final Socket socket;
  const RequestConfirmation(this.shareRequest, this.socket);
}

class Connecting extends ReceiverDialogState {
  final DeviceInfo serverDeviceInfo;
  const Connecting(this.serverDeviceInfo);
}

class Transferring extends ReceiverDialogState {
  DeviceInfo serverDeviceInfo;
  List<FileInfo> files;
  List<FileInfo> filesTransferred = [];
  FileInfo currentFile;
  double speed;
  double progress;
  Transferring(
    this.files,
    this.filesTransferred,
    this.currentFile,
    this.speed,
    this.progress,
    this.serverDeviceInfo,
  );
}

class TransferSuccess extends ReceiverDialogState {
  final DeviceInfo serverDeviceInfo;
  final List<FileInfo> files;
  const TransferSuccess(this.serverDeviceInfo, this.files);

  @override
  bool get canPop => true;
}

class TransferFailed extends ReceiverDialogState {
  final DeviceInfo? serverDeviceInfo;
  final String message;
  const TransferFailed(this.serverDeviceInfo, this.message);

  @override
  bool get canPop => true;
}
