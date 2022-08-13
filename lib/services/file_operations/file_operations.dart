import 'dart:io';

class FileOperations {
  static Future<void> tmpToFile(File thisFile) async {
    var lastSeparatorIndex = thisFile.path.lastIndexOf(Platform.pathSeparator);
    await thisFile.rename(thisFile.path.substring(0, lastSeparatorIndex + 1) + thisFile.path.substring(lastSeparatorIndex + 1).replaceFirst('.nocabtmp', ''));
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
}
