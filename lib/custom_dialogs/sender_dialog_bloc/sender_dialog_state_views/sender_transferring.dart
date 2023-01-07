import 'package:flutter/material.dart';
import 'package:nocab_core/nocab_core.dart';

class TransferringView extends StatelessWidget {
  final DeviceInfo serverDeviceInfo;
  final List<FileInfo> files;
  final List<FileInfo> filesTransferred;
  final FileInfo currentFile;
  final double speed;
  final double progress;

  const TransferringView({
    Key? key,
    required this.serverDeviceInfo,
    required this.files,
    required this.filesTransferred,
    required this.currentFile,
    required this.speed,
    required this.progress,
  }) : super(key: key);

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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Please don't close the app!",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onBackground),
                    textAlign: TextAlign.center),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.phonelink_rounded, color: Theme.of(context).colorScheme.onPrimary),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * .35,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(serverDeviceInfo.name.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                                          ),
                                          overflow: TextOverflow.ellipsis),
                                      Text(serverDeviceInfo.ip,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w200,
                                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Theme.of(context).colorScheme.outline,
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              side: BorderSide(color: Theme.of(context).colorScheme.outline, width: 1),
                            ),
                            child: Row(
                              children: [
                                Text("Remaining files  ",
                                    style:
                                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(files.length.toString(),
                                        style: TextStyle(
                                            fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.surfaceVariant)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                                        child: Text(currentFile.name,
                                            style: TextStyle(
                                                fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                                        child: Text("${(currentFile.byteSize / 1024 / 1024).toStringAsFixed(2)}MB",
                                            style: TextStyle(
                                                fontSize: 14, fontWeight: FontWeight.w200, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                                      child: Text("${speed.toStringAsFixed(2)} MB/s",
                                          style: TextStyle(
                                              fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                                      child: Text("${progress.toStringAsFixed(2)}%",
                                          style: TextStyle(
                                              fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: LinearProgressIndicator(
                                value: progress / 100,
                                minHeight: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          ),
                          child: const Text("Cancel"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
