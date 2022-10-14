import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nocab/custom_dialogs/receiver_dialog_bloc/receiver_dialog_state.dart';
import 'package:nocab/models/deviceinfo_model.dart';
import 'package:nocab/models/file_model.dart';
import 'package:nocab/services/file_operations/file_operations.dart';
import 'package:nocab/services/network/network.dart';
import 'package:nocab/services/transfer/receiver.dart';
import 'package:path/path.dart' as p;

class ReceiverDialogCubit extends Cubit<ReceiverDialogState> {
  ReceiverDialogCubit() : super(const ReceiverInit());

  ServerSocket? listenerSocket;
  ServerSocket? serverSocket;

  Future<void> listenDevices(DeviceInfo deviceInfo) async {
    listenerSocket = await ServerSocket.bind(InternetAddress.anyIPv4, 62192);
    listenerSocket!.listen((socket) {
      socket
          .write(base64.encode(utf8.encode(json.encode(deviceInfo.toJson()))));
    });
  }

  Future<void> startReceiver() async {
    var baseInfo = await DeviceInfoPlugin().deviceInfo;

    var clientDeviceInfo = DeviceInfo(
      name: (baseInfo) is AndroidDeviceInfo
          ? baseInfo.model
          : baseInfo is IosDeviceInfo
              ? baseInfo.name
              : "Unknown",
      ip: (await Network.getCurrentNetworkInterface()).addresses.first.address,
      port: 5001,
      opsystem: Platform.operatingSystemVersion,
      uuid: "test",
    );

    try {
      await listenDevices(clientDeviceInfo);

      serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, 5001);

      emit(ConnectionWait(clientDeviceInfo));

      serverSocket?.listen(
        (socket) {
          socket.listen((event) {
            try {
              String socketData =
                  utf8.decode(base64.decode(utf8.decode(event)));
              ShareRequest request =
                  ShareRequest.fromJson(json.decode(socketData));
              //TODO: Database ban check
              //TODO: Fail2Ban
              stopReceiver();
              emit(RequestConfirmation(request, socket));
            } catch (_) {}
          });
        },
      );
    } on SocketException catch (e) {
      stopReceiver();
      emit(TransferFailed(null,
          "Message: ${e.message}\nOs Message: ${e.osError?.message}\nError Code: ${e.osError?.errorCode}\nAdress: ${e.address?.address}:${e.port}"));
    }
  }

  Future<void> stopReceiver() async {
    await listenerSocket?.close();
    await serverSocket?.close();
  }

  Future<void> acceptRequest(ShareRequest request, Socket socket) async {
    emit(Connecting(request.deviceInfo));

    // initialize files for start transfer
    var downloadDirectory = await FileOperations.getDownloadPath();
    if (downloadDirectory == null)
      throw Exception("Download directory not found");

    request.files = request.files.map<FileInfo>((e) {
      e.path = FileOperations.findUnusedFilePath(
          fileName: e.name,
          downloadPath: (p
              .join(downloadDirectory, e.subDirectory ?? "")
              .replaceAll(RegExp(r'[\\\/]'),
                  Platform.pathSeparator))); // TODO: add custom download path
      return e;
    }).toList();

    ShareResponse shareResponse = ShareResponse(response: true);
    socket
        .write(base64.encode(utf8.encode(json.encode(shareResponse.toJson()))));
    socket.close();

    Receiver(
      files: request.files,
      deviceInfo: request.deviceInfo,
      port: request.transferPort,
      onDataReport: _onDataReport,
      onEnd: _onEnd,
      onError: _onError,
    ).start();
  }

  Future<void> rejectRequest(ShareRequest request, Socket socket,
      {String? message}) async {
    ShareResponse shareResponse = ShareResponse(
        response: false, info: message ?? "User rejected request");

    socket
        .write(base64.encode(utf8.encode(json.encode(shareResponse.toJson()))));
    await socket.close();
  }

  void _onDataReport(
          List<FileInfo> files,
          List<FileInfo> filesTransferred,
          FileInfo currentFile,
          double speed,
          double progress,
          DeviceInfo deviceInfo) =>
      emit(Transferring(
          files, filesTransferred, currentFile, speed, progress, deviceInfo));

  void _onEnd(DeviceInfo deviceInfo, List<FileInfo> files) =>
      emit(TransferSuccess(deviceInfo, files));

  void _onError(DeviceInfo deviceInfo, String message) =>
      emit(TransferFailed(deviceInfo, message));
}
