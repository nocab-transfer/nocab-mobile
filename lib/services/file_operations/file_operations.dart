import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:nocab/models/file_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

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
      path = p.join(downloadPath, p.withoutExtension(fileName) + (fileIndex > 0 ? " ($fileIndex)" : "") + p.extension(fileName));
      fileIndex++;
    } while (File(path).existsSync());
    return path;
  }

  static Future<List<FileInfo>> getFilesUnderDirectory(String path, [String? parentSubDirectory]) async {
    // open new thread to reduce cpu load
    return await compute(_getFilesUnderDirectory, [path, parentSubDirectory]);
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

  static Future<List<FileInfo>> convertPathsToFileInfos(List<String> paths) async {
    // create a list contains all directories
    var directoryList = paths.fold(<Directory>[], (previousValue, path) {
      if (Directory(path).existsSync()) previousValue.add(Directory(path));
      return previousValue;
    });

    // create a list contains all files
    List<FileInfo> files = [];
    for (var filePath in paths.where((path) => File(path).existsSync())) {
      files.add(FileInfo(name: p.basename(filePath), byteSize: await File(filePath).length(), isEncrypted: false, hash: "", path: filePath));
    }

    // add files under directories
    await Future.forEach(directoryList, (dir) async => files.addAll(await FileOperations.getFilesUnderDirectory(dir.path)));
    return files;
  }
}

Future<List<FileInfo>> _getFilesUnderDirectory(List<String?> args) async {
  var filesUnderDirectory = await Directory(args[0]!).list().toList();

  var files = <FileInfo>[];

  await Future.forEach(filesUnderDirectory, (element) async {
    String subDirectory = args[0]!.substring(args[0]!.lastIndexOf(Platform.pathSeparator) + 1);
    if ((await element.stat()).type == FileSystemEntityType.file) {
      var file = File(element.path);
      var fileInfo = FileInfo(
          name: file.path.substring(file.path.lastIndexOf(Platform.pathSeparator) + 1),
          byteSize: await file.length(),
          isEncrypted: false,
          hash: "null",
          path: file.path,
          subDirectory: p.join(args[1] ?? "", subDirectory));
      files.add(fileInfo);
    } else if ((await element.stat()).type == FileSystemEntityType.directory) {
      var subDirectoryFiles = await _getFilesUnderDirectory([element.path, p.join(args[1] ?? "", subDirectory)]);
      files.addAll(subDirectoryFiles);
    }
  });

  return files;
}
