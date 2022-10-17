import 'package:nocab/models/deviceinfo_model.dart';
import 'package:nocab/models/file_model.dart';

enum DataReportType {
  start,
  info,
  end,
  error,
  fileEnd,
}

class DataReport {
  DataReportType type;

  List<FileInfo>? files;
  List<FileInfo>? filesTransferred;
  FileInfo? currentFile;
  double? speed;
  double? progress;
  DeviceInfo? deviceInfo;
  String? message;

  DataReport(
    this.type, {
    this.speed,
    this.progress,
    this.files,
    this.filesTransferred,
    this.currentFile,
    this.deviceInfo,
    this.message,
  });
}

enum ConnectionActionType {
  start,
  event,
  fileEnd,
  end,
  error,
}

class ConnectionAction {
  ConnectionActionType type;

  FileInfo? currentFile;
  int? totalTransferredBytes;
  String? message;

  ConnectionAction(this.type, {this.currentFile, this.totalTransferredBytes, this.message});
}
