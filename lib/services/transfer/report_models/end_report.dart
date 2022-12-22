import 'package:nocab/models/deviceinfo_model.dart';
import 'package:nocab/models/file_model.dart';
import 'package:nocab/services/transfer/report_models/base_report.dart';

class EndReport extends Report {
  DeviceInfo device;
  List<FileInfo> files;
  DateTime endTime;

  EndReport({
    required this.device,
    required this.files,
    required this.endTime,
  });
}
