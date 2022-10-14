import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nocab/custom_widgets/device_finder_bloc/device_finder_state.dart';
import 'package:nocab/models/deviceinfo_model.dart';
import 'package:nocab/services/network/network.dart';

class DeviceFinderCubit extends Cubit<DeviceFinderState> {
  DeviceFinderCubit() : super(const NoDevice());

  Timer? timer;

  Future<void> startScanning() async {
    NetworkInterface currentInterface =
        await Network.getCurrentNetworkInterface();
    String baseIp = currentInterface.addresses[0].address
        .split('.')
        .sublist(0, 3)
        .join('.');

    timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      if (isClosed) timer?.cancel();
      List<DeviceInfo> devices = [];
      Socket? socket;
      for (int i = 1; i < 255; i++) {
        try {
          socket = await Socket.connect('$baseIp.$i', 62193,
              timeout: const Duration(milliseconds: 10));
          Uint8List data =
              await socket.first.timeout(const Duration(seconds: 5));
          if (data.isNotEmpty) {
            devices.add(DeviceInfo.fromJson(
                json.decode(utf8.decode(base64.decode(utf8.decode(data))))));
            if (!isClosed) emit(Found(devices));
          }

          socket.close();
          // ignore: empty_catches
        } on SocketException {
          socket?.close();
        }
      }

      if (devices.isEmpty && !isClosed) emit(const NoDevice());
    });
  }

  Future<void> stopScanning() async {
    timer?.cancel();
  }

  Future<bool> isDeviceStillActive(DeviceInfo device) async {
    var socket = await Socket.connect(device.ip, 62193,
        timeout: const Duration(seconds: 1));
    Uint8List data = await socket.first.timeout(const Duration(seconds: 1));
    if (device.name ==
        json.decode(utf8.decode(base64.decode(utf8.decode(data))))['name'])
      return true;
    return false;
  }
}
