import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nocab/custom_dialogs/sender_dialog_bloc/sender_dialog_state.dart';
import 'package:nocab/models/deviceinfo_model.dart';
import 'package:nocab/models/file_model.dart';
import 'package:nocab/services/network/network.dart';
import 'package:nocab/services/transfer/sender.dart';

class SenderDialogCubit extends Cubit<SenderDialogState> {
  SenderDialogCubit() : super(const SenderInit());

  Future<void> pickFiles() async {
    emit(const FileCacheLoading());

    List<FileInfo>? files = await FilePicker.platform
        .pickFiles(
            allowMultiple: true,
            onFileLoading: (p0) {
              // TODO: İmplement which file is loading
              emit(const FileCacheLoading());
            })
        .then((filePickerResult) {
      return filePickerResult?.files.map((file) => FileInfo(name: file.name, byteSize: file.size, path: file.path, hash: "unused", isEncrypted: false)).toList();
    });

    if (files == null) {
      emit(const FileSelectCancel());
    } else {
      emit(FileConfirmation(files));
    }
  }

  Future<void> send({required DeviceInfo serverDeviceInfo, required List<FileInfo> files}) async {
    emit(Connecting(serverDeviceInfo));

    Socket socket = await Socket.connect(serverDeviceInfo.ip, serverDeviceInfo.port!);

    var _deviceInfo = await DeviceInfoPlugin().deviceInfo;

    ShareRequest shareRequest = ShareRequest(
      deviceInfo: DeviceInfo(
        name: (_deviceInfo is AndroidDeviceInfo)
            ? _deviceInfo.model
            : (_deviceInfo is IosDeviceInfo)
                ? _deviceInfo.name
                : "Unknown",
        ip: (await Network.getCurrentNetworkInterface()).addresses.first.address,
        port: 5001,
        opsystem: _deviceInfo is AndroidDeviceInfo
            ? "Android " + _deviceInfo.version.release.toString()
            : _deviceInfo is IosDeviceInfo
                ? "IOS " + _deviceInfo.systemVersion.toString()
                : 'Unknown',
        uuid: "test",
      ),
      files: files,
      transferPort: await Network.getUnusedPort(),
      uniqueId: _deviceInfo is AndroidDeviceInfo
          ? _deviceInfo.androidId
          : _deviceInfo is IosDeviceInfo
              ? _deviceInfo.identifierForVendor
              : 'Unknown',
    );

    socket.write(base64.encode(utf8.encode(json.encode(shareRequest.toJson()))));

    emit(RequestSent(serverDeviceInfo));

    var response = ShareResponse.fromJson(json.decode(utf8.decode(base64.decode(utf8.decode(await socket.first)))));
    socket.close();
    if (response.response == true) {
      emit(RequestAccepted(serverDeviceInfo));
      Sender(
        port: shareRequest.transferPort,
        deviceInfo: serverDeviceInfo,
        files: files,
        onDataReport: _onDataReport,
        onEnd: _onEnd,
        onError: _onError,
      ).start();
    } else {
      emit(RequestRejected(response.info ?? ""));
    }
  }

  void _onDataReport(List<FileInfo> files, List<FileInfo> filesTransferred, FileInfo currentFile, double speed, double progress, DeviceInfo deviceInfo) => emit(Transferring(files, filesTransferred, currentFile, speed, progress, deviceInfo));

  void _onEnd(DeviceInfo deviceInfo, List<FileInfo> files) => emit(TransferSuccess(deviceInfo, files));

  void _onError(DeviceInfo deviceInfo, String message) => emit(TransferFailed(deviceInfo, message));
}
