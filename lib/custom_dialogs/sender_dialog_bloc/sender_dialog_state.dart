import 'package:nocab/models/deviceinfo_model.dart';
import 'package:nocab/models/file_model.dart';

abstract class SenderDialogState {
  const SenderDialogState();
}

class SenderInit extends SenderDialogState {
  const SenderInit();
}

class FileCacheLoading extends SenderDialogState {
  const FileCacheLoading();
}

class FileSelectCancel extends SenderDialogState {
  const FileSelectCancel();
}

class FileConfirmation extends SenderDialogState {
  final List<FileInfo> files;
  const FileConfirmation(this.files);
}

class Connecting extends SenderDialogState {
  final DeviceInfo serverDeviceInfo;
  const Connecting(this.serverDeviceInfo);
}

class RequestSent extends SenderDialogState {
  final DeviceInfo serverDeviceInfo;
  const RequestSent(this.serverDeviceInfo);
}

class RequestAccepted extends SenderDialogState {
  final DeviceInfo serverDeviceInfo;
  const RequestAccepted(this.serverDeviceInfo);
}

class RequestRejected extends SenderDialogState {
  final String message;
  const RequestRejected(this.message);
}

class Transferring extends SenderDialogState {
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

class TransferSuccess extends SenderDialogState {
  final DeviceInfo serverDeviceInfo;
  final List<FileInfo> files;
  const TransferSuccess(this.serverDeviceInfo, this.files);
}

class TransferFailed extends SenderDialogState {
  final DeviceInfo serverDeviceInfo;
  final String message;
  const TransferFailed(this.serverDeviceInfo, this.message);
}
