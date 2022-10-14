import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileOperations {
  static Future<void> tmpToFile(File thisFile) async {
    var lastSeparatorIndex = thisFile.path.lastIndexOf(Platform.pathSeparator);
    await thisFile.rename(thisFile.path.substring(0, lastSeparatorIndex + 1) +
        thisFile.path
            .substring(lastSeparatorIndex + 1)
            .replaceFirst('.nocabtmp', ''));
  }

  static String findUnusedFilePath(
      {required String fileName, required String downloadPath}) {
    int fileIndex = 0;
    String path;
    do {
      var indexOfLastDot = fileName.lastIndexOf('.');
      var fileNameWithoutExtension = fileName.substring(0, indexOfLastDot);
      var fileExtension = fileName.substring(indexOfLastDot);
      path = downloadPath +
          Platform.pathSeparator +
          fileNameWithoutExtension +
          (fileIndex == 0 ? '' : ' ($fileIndex)') +
          fileExtension;
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
        if (!await directory.exists())
          directory = await getExternalStorageDirectory();
      }
    } catch (err) {
      print("Cannot get download folder path");
    }
    return directory?.path;
  }
}
