import 'package:nocab/models/deviceinfo_model.dart';
import 'package:nocab/models/file_model.dart';
import 'package:nocab/services/transfer/report_models/base_report.dart';

class StartReport extends Report {
  DateTime startTime;
  DeviceInfo deviceInfo;
  List<FileInfo> files;

  StartReport({
    required this.startTime,
    required this.deviceInfo,
    required this.files,
  });
}
