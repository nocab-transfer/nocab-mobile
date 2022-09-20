import 'dart:convert';

import 'package:nocab/models/deviceinfo_model.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanner extends StatelessWidget {
  QrScanner({Key? key}) : super(key: key);

  final MobileScannerController cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileScanner(
        allowDuplicates: false,
        controller: cameraController,
        onDetect: (barcode, args) {
          final String? code = barcode.rawValue;
          try {
            var deviceInfoRaw = utf8.decode(base64.decode(code!));
            var deviceInfo = DeviceInfo.fromJson(json.decode(deviceInfoRaw));
            Navigator.pop(context, deviceInfo);
          } catch (e) {
            print("error $e${code!}");
          }
        },
      ),
    );
  }
}
