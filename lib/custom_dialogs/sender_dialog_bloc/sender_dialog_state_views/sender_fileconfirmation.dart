import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nocab/custom_widgets/device_finder_bloc/device_finder.dart';
import 'package:nocab/custom_widgets/file_list/file_list.dart';
import 'package:nocab/extensions/size_extension.dart';
import 'package:nocab/models/deviceinfo_model.dart';
import 'package:nocab/models/file_model.dart';
import 'package:nocab/screens/qr_scanner_screen/qr_scanner_screen.dart';

class FileConfirmationView extends StatelessWidget {
  final List<FileInfo> files;
  final Function(DeviceInfo onAccepted, List<FileInfo> files) onAccepted;
  const FileConfirmationView({Key? key, required this.files, required this.onAccepted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SizedBox(
          //height: 550,
          width: MediaQuery.of(context).size.width - 50,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text("Send files", style: Theme.of(context).textTheme.titleLarge),
                  ),
                  Material(color: Colors.transparent, child: CloseButton(onPressed: () => Navigator.pop(context))),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: FileList(
                  files: files,
                  height: files.length * 66 > 350 ? 350 : files.length * 66,
                  width: MediaQuery.of(context).size.width - 50,
                ),
              ),
              Text(
                "${files.length} files\nTotal size: ${(files.map((e) => e.byteSize).reduce((a, b) => a + b)).formatBytes()}",
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.surfaceVariant,
                  ),
                  child: DeviceFinder(
                    onPressed: (deviceInfo) => _onAccepted(deviceInfo, files),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QrScanner(
                          onScan: (rawData) {
                            final String code = rawData;
                            try {
                              var deviceInfoRaw = utf8.decode(base64.decode(code));
                              var deviceInfo = DeviceInfo.fromJson(json.decode(deviceInfoRaw));
                              Navigator.maybePop(context, deviceInfo);
                            } catch (e) {
                              // TODO: Show error
                            }
                          },
                        ),
                      ),
                    ).then((qrResult) {
                      if (qrResult is DeviceInfo) _onAccepted(qrResult, files);
                    }),
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(100, 40),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: Text(
                      "Scan Qr",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimary),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onAccepted(DeviceInfo deviceInfo, List<FileInfo> files) => onAccepted.call(deviceInfo, files);
}
