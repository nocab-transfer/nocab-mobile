import 'dart:io';

import 'package:nocab/models/file_model.dart';
import 'package:path_provider/path_provider.dart';

class FileOperations {
  static Future<void> tmpToFile(File thisFile, FileInfo toFile) async {
    await Directory(File(toFile.path!).parent.path).create(recursive: true);
    await thisFile.copy(toFile.path!);
    await thisFile.delete();
  }

  static String findUnusedFilePath({required String fileName, required String downloadPath}) {
    int fileIndex = 0;
    String path;
    do {
      var indexOfLastDot = fileName.lastIndexOf('.');
      var fileNameWithoutExtension = fileName.substring(0, indexOfLastDot);
      var fileExtension = fileName.substring(indexOfLastDot);
      path = downloadPath + Platform.pathSeparator + fileNameWithoutExtension + (fileIndex == 0 ? '' : ' ($fileIndex)') + fileExtension;
      fileIndex++;
    } while (File(path).existsSync());
    return path;
  }

  static Future<String?> getDownloadPath() async {
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
      // TODO: handle error
    }
    return directory?.path;
  }
}
