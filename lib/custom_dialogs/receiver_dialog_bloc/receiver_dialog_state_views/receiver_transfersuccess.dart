import 'package:flutter/material.dart';
import 'package:nocab/custom_widgets/file_list/file_list.dart';
import 'package:nocab_core/nocab_core.dart';
import 'package:open_filex/open_filex.dart';

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
              //height: 208,
              //width: 150,
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                        "${files.length} file(s) received successfully from ${serverDeviceInfo.name}",
                        style: Theme.of(context).textTheme.labelMedium,
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).colorScheme.surfaceVariant,
                          ),
                          child: FileList(
                            files: files,
                            onTap: (FileInfo file) => OpenFilex.open(file.path),
                          ),
                        ),
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
