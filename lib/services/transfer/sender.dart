import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:nocab/models/deviceinfo_model.dart';
import 'package:nocab/models/file_model.dart';

import 'isolate_message.dart';

class Sender {
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

  Sender({
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
            onError?.call(message.deviceInfo!, "Crash");
            break;
        }
      }
    });
  }
}

Future<void> _dataHandler(List<dynamic> args) async {
  SendPort dataToMainSendPort = args[0];

  ReceivePort mainToDataPort = ReceivePort();
  dataToMainSendPort.send(mainToDataPort.sendPort);

  List<FileInfo> files = args[1];
  List<FileInfo> filesTransferred = [];
  FileInfo currentFile = files.first;

  DeviceInfo deviceInfo = args[2];

  final int port = args[3];

  int totalByteCount = 0;
  int totalByteCountBefore = 0;
  const Duration duration = Duration(milliseconds: 100);

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
    totalByteCountBefore = totalByteCount;
  });

  // Initialize sender isolate

  ReceivePort senderToDataPort = ReceivePort();

  Isolate senderIsolate = await Isolate.spawn(_sender, [
    senderToDataPort.sendPort,
    files,
    deviceInfo,
    port,
  ]);

  senderToDataPort.listen((message) {
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
        filesTransferred.add(currentFile);
        break;
      case ConnectionActionType.end:
        dataToMainSendPort.send(DataReport(DataReportType.end, deviceInfo: deviceInfo, files: files));
        senderIsolate.kill();
        Isolate.current.kill();
        break;
      case ConnectionActionType.error:
        dataToMainSendPort.send(DataReport(DataReportType.error, deviceInfo: deviceInfo));
        senderIsolate.kill();
        Isolate.current.kill();
        break;
    }
  });
}

void _sender(List<dynamic> args) async {
  print("sender initialized on: ${(args[2] as DeviceInfo).toJson()}");
  SendPort sendport = args[0];
  List<FileInfo> files = args[1];
  DeviceInfo receiverDeviceInfo = args[2];
  int port = args[3];

  RawServerSocket server = await RawServerSocket.bind(InternetAddress.anyIPv4, port);
  print("listening on: $port");

  Future<void> _send(FileInfo fileInfo, RawSocket socket) async {
    try {
      final Uint8List _buffer = Uint8List(1024 * 16);
      RandomAccessFile _file = await File(fileInfo.path!).open();

      int _bytesWritten = 0;
      int totalWrite = 0;
      while (_file.readIntoSync(_buffer) > 0) {
        _bytesWritten = socket.write(_buffer);
        totalWrite += _bytesWritten;
        _file.setPositionSync(totalWrite);

        sendport.send(ConnectionAction(
          ConnectionActionType.event,
          currentFile: fileInfo,
          totalTransferredBytes: totalWrite,
        ));
      }
      sendport.send(ConnectionAction(ConnectionActionType.fileEnd, currentFile: fileInfo, totalTransferredBytes: totalWrite));

      await Future.delayed(const Duration(seconds: 2));
      files.remove(fileInfo);
      socket.close();
      if (files.isEmpty) sendport.send(ConnectionAction(ConnectionActionType.end));
    } catch (e) {
      socket.shutdown(SocketDirection.both);
      print(e);
      sendport.send(ConnectionAction(ConnectionActionType.error));
    }
  }

  server.listen((socket) {
    print(socket.remoteAddress.address != receiverDeviceInfo.ip);

    if (socket.remoteAddress.address != receiverDeviceInfo.ip) socket.close();

    socket.listen((event) {
      switch (event) {
        case RawSocketEvent.read:
          String data = utf8.decode(socket.read() ?? []); //String.fromCharCodes(socket.read() ?? []);
          print(files.map((e) => e.name).toList());
          print(data);

          FileInfo file = files.firstWhere((element) => element.name == data);
          sendport.send(ConnectionAction(ConnectionActionType.start, currentFile: file));
          print("Started sending ${file.name}");
          _send(file, socket);
          break;
        case RawSocketEvent.readClosed:
          print("readClosed");
          break;
        case RawSocketEvent.closed:
          print("closed");
          break;
        default:
      }
    });
  });
}
