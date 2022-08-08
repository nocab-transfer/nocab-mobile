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
            var _deviceInfoRaw = utf8.decode(base64.decode(code!));
            var _deviceInfo = DeviceInfo.fromJson(json.decode(_deviceInfoRaw));
            Navigator.pop(context, _deviceInfo);
          } catch (e) {
            print("error $e" + code!);
          }
        },
      ),
    );
  }
}
