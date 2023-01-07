import 'package:flutter/material.dart';
import 'package:nocab/extensions/size_extension.dart';
import 'package:nocab_core/nocab_core.dart';

class FileList extends StatefulWidget {
  final List<FileInfo> files;
  final Function(FileInfo file)? onTap;

  const FileList({super.key, required this.files, this.onTap});

  @override
  State<FileList> createState() => _FileListState();
}

class _FileListState extends State<FileList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.files.length,
      itemBuilder: (BuildContext context, int index) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            onTap: () => widget.onTap?.call(widget.files[index]),
            child: SizedBox(
              //color: Colors.red,
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Center(
                              child: Text(
                                  widget.files[index].name.split('.').last.length > 4 ? "?" : widget.files[index].name.split('.').last.toUpperCase(),
                                  style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 15, fontWeight: FontWeight.w900))),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Tooltip(
                                message: widget.files[index].name,
                                child: Text(
                                  widget.files[index].name,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Text(widget.files[index].byteSize.formatBytes(), style: const TextStyle(fontSize: 12)),
                            if (widget.files[index].subDirectory != null) ...[
                              Text(widget.files[index].subDirectory!, style: const TextStyle(fontSize: 10), maxLines: 2),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
