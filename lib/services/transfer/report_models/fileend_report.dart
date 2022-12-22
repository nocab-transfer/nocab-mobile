import 'package:nocab/models/file_model.dart';
import 'package:nocab/services/transfer/report_models/base_report.dart';

class FileEndReport extends Report {
  FileInfo fileInfo;

  FileEndReport({
    required this.fileInfo,
  });
}
