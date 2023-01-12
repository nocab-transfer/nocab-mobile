import 'package:flutter/material.dart';
import 'package:nocab_core/nocab_core.dart';

class TransferSuccessView extends StatelessWidget {
  final DeviceInfo serverDeviceInfo;
  final List<FileInfo> files;
  const TransferSuccessView({Key? key, required this.serverDeviceInfo, required this.files}) : super(key: key);

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
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 208,
              width: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const RadialGradient(
                          center: Alignment.center,
                          radius: 0.5,
                          colors: [Colors.blue, Colors.green],
                          tileMode: TileMode.mirror,
                        ).createShader(bounds),
                        child: const Icon(Icons.celebration_rounded, size: 50),
                      ),
                      //Icon(Icons.celebration_rounded, size: 50, color: Colors.),
                      const SizedBox(height: 16),
                      Text(
                        "${files.length} file(s) sent successfully to ${serverDeviceInfo.name}",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onBackground),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(), child: Text("click to close", style: Theme.of(context).textTheme.bodySmall))
                ],
              ),
            )),
      ),
    );
  }
}
