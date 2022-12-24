import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanner extends StatelessWidget {
  final Function(String rawData) onScan;
  const QrScanner({Key? key, required this.onScan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileScanner(
        onDetect: (capture) => onScan.call(capture.barcodes.first.rawValue ?? ""),
      ),
    );
  }
}
