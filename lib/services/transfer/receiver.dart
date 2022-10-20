import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:nocab/models/deviceinfo_model.dart';
import 'package:nocab/models/file_model.dart';
import 'package:nocab/services/file_operations/file_operations.dart';
import 'package:path/path.dart';

import 'isolate_message.dart';

class Receiver {
  final DeviceInfo deviceInfo;
  final List<FileInfo> files;
  final int port;
  final Function(
    List<FileInfo> files,
    List<FileInfo> filesTransferred,
    FileInfo currentFile,
    double speed,
    double progress,
    DeviceInfo deviceInfo,
  )? onDataReport;
  final Function(DeviceInfo serverDeviceInfo)? onStart;
  final Function(DeviceInfo serverDeviceInfo, List<FileInfo> files)? onEnd;
  final Function(FileInfo file)? onFileEnd;
  final Function(DeviceInfo serverDeviceInfo, String message)? onError;

  Receiver({
    required this.files,
    required this.deviceInfo,
    required this.port,
    this.onDataReport,
    this.onStart,
    this.onEnd,
    this.onFileEnd,
    this.onError,
  });
  Future<void> start() async {
    ReceivePort dataToMainPort = ReceivePort();
    await Isolate.spawn(_dataHandler, [
      dataToMainPort.sendPort,
      files,
      deviceInfo,
      port,
    ]);

    SendPort? mainToDataPort; // this will be used for pausing and resuming the transfer
    mainToDataPort;
    dataToMainPort.listen((message) {
      if (message is SendPort) mainToDataPort = message;

      if (message is DataReport) {
        switch (message.type) {
          case DataReportType.start:
            onStart?.call(message.deviceInfo!);
            break;
          case DataReportType.end:
            onEnd?.call(message.deviceInfo!, message.files!);
            break;
          case DataReportType.fileEnd:
            onFileEnd?.call(message.currentFile!);
            break;
          case DataReportType.info:
            onDataReport?.call(
              message.files!,
              message.filesTransferred!,
              message.currentFile!,
              message.speed!,
              message.progress!,
              message.deviceInfo!,
            );
            break;
          case DataReportType.error:
            onError?.call(message.deviceInfo!, message.message ?? 'Unknown Error');
            break;
        }
      }
    });
  }
}

void _dataHandler(List<dynamic> args) async {
  SendPort dataToMainSendPort = args[0];

  ReceivePort mainToDataPort = ReceivePort();
  dataToMainSendPort.send(mainToDataPort.sendPort);

  List<FileInfo> files = args[1];
  List<FileInfo> filesTransferred = [];
  FileInfo currentFile = files.first;

  DeviceInfo deviceInfo = args[2];

  final int port = args[3];

  Isolate? receiverIsolate;

  int totalByteCount = 0;
  int totalByteCountBefore = 0;
  const Duration duration = Duration(milliseconds: 100);

  const int errorHandleTimeoutMilliseconds = 30000;
  int currentErrorTime = 0;

  Timer.periodic(duration, (timer) {
    dataToMainSendPort.send(
      DataReport(
        DataReportType.info,
        files: files,
        filesTransferred: filesTransferred,
        currentFile: currentFile,
        speed: ((totalByteCount - totalByteCountBefore) * 1000 / duration.inMilliseconds) / 1024 / 1024,
        progress: (100 * totalByteCount / currentFile.byteSize) > 100 ? 100 : (100 * totalByteCount / currentFile.byteSize),
        deviceInfo: deviceInfo,
      ),
    );

    // if no data is send for 30 seconds, assume the transfer has crashed
    if (totalByteCountBefore == totalByteCount) {
      currentErrorTime = (currentErrorTime + (1000 / (1000 / duration.inMilliseconds))).toInt();
    } else {
      currentErrorTime = 0;
    }

    if (currentErrorTime > errorHandleTimeoutMilliseconds) {
      timer.cancel();
      dataToMainSendPort.send(DataReport(
        DataReportType.error,
        deviceInfo: deviceInfo,
        message: 'Transfer timed out',
      ));
      receiverIsolate?.kill();
      Isolate.current.kill();
    }

    totalByteCountBefore = totalByteCount;
  });

  // Initialize receiver isolate

  ReceivePort receiverToDataPort = ReceivePort();

  receiverIsolate = await Isolate.spawn(_receiver, [
    receiverToDataPort.sendPort,
    files,
    deviceInfo,
    port,
  ]);

  receiverToDataPort.listen((message) {
    switch ((message).type) {
      case ConnectionActionType.start:
        totalByteCountBefore = 0;
        totalByteCount = 0;
        dataToMainSendPort.send(
          DataReport(
            DataReportType.start,
            files: files,
            filesTransferred: filesTransferred,
            currentFile: currentFile,
            speed: 0,
            progress: 0,
            deviceInfo: deviceInfo,
          ),
        );
        break;
      case ConnectionActionType.event:
        totalByteCount = message.totalTransferredBytes!;
        currentFile = message.currentFile!;
        break;
      case ConnectionActionType.fileEnd:
        filesTransferred.add(currentFile);
        dataToMainSendPort.send(
          DataReport(
            DataReportType.info,
            files: files,
            filesTransferred: filesTransferred,
            currentFile: message.currentFile,
            speed: ((totalByteCount - totalByteCountBefore) * 1000 / duration.inMilliseconds) / 1024 / 1024,
            progress: (100 * totalByteCount / currentFile.byteSize) > 100 ? 100 : (100 * totalByteCount / currentFile.byteSize),
            deviceInfo: deviceInfo,
          ),
        );
        break;
      case ConnectionActionType.end:
        dataToMainSendPort.send(DataReport(DataReportType.end, deviceInfo: deviceInfo, files: files));
        receiverIsolate?.kill();
        Isolate.current.kill();
        break;
      case ConnectionActionType.error:
        dataToMainSendPort.send(DataReport(DataReportType.error, message: message.message, deviceInfo: deviceInfo));
        receiverIsolate?.kill();
        Isolate.current.kill();
        break;
    }
  });
}

void _receiver(List<dynamic> args) async {
  SendPort sendport = args[0];
  List<FileInfo> files = args[1];
  DeviceInfo senderDeviceInfo = args[2];
  int port = args[3];
  Directory tempFolder = await Directory.systemTemp.createTemp();

  Future<void> receiveFile() async {
    RawSocket? socket;
    while (socket == null) {
      try {
        socket = await RawSocket.connect(senderDeviceInfo.ip, port);
      } catch (e) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }

    int totalRead = 0;

    FileInfo currentFile = files.first;
    File tempFile = File(join(tempFolder.path, currentFile.name, ".nocabtmp"));

    try {
      await tempFile.create(recursive: true);
    } catch (e) {
      sendport.send(ConnectionAction(ConnectionActionType.error, message: 'Failed to create temp file'));
    }

    IOSink currentSink = tempFile.openWrite(mode: FileMode.append);

    socket.write(utf8.encode(currentFile.name));

    sendport.send(ConnectionAction(ConnectionActionType.start, currentFile: currentFile));

    Uint8List? buffer;
    socket.listen((event) {
      switch (event) {
        case RawSocketEvent.read:
          buffer = socket?.read();
          if (buffer != null) {
            currentSink.add(buffer!);
            totalRead += buffer!.length;
            sendport.send(ConnectionAction(
              ConnectionActionType.event,
              currentFile: currentFile,
              totalTransferredBytes: totalRead,
            ));
          }

          if (totalRead == currentFile.byteSize) {
            socket?.close();
            sendport.send(ConnectionAction(ConnectionActionType.fileEnd, currentFile: currentFile, totalTransferredBytes: totalRead));
            files.removeAt(0);
            if (files.isNotEmpty) {
              currentSink.close().then((value) async {
                await FileOperations.tmpToFile(tempFile, currentFile);
                receiveFile();
              });
            } else {
              currentSink.close().then((value) async {
                await FileOperations.tmpToFile(tempFile, currentFile);
                await tempFolder.delete(recursive: true);
                sendport.send(ConnectionAction(ConnectionActionType.end));
              });
            }
          }
          break;
        case RawSocketEvent.closed:
        case RawSocketEvent.readClosed:
          // copying file tmp to final destination may take some time, socket can close before that
          // so checking if files transferred already and waiting for copying to finish
          // if socket closed and files not transferred, send error
          if (files.isNotEmpty) sendport.send(ConnectionAction(ConnectionActionType.error, message: 'Connection closed'));
          break;
        default:
          break;
      }
    });
  }

  receiveFile();
}
