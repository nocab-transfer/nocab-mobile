import 'package:flutter/material.dart';
import 'package:nocab/extensions/size_extension.dart';
import 'package:nocab/models/file_model.dart';

class FileList extends StatelessWidget {
  final List<FileInfo> files;
  final double height;
  final double width;
  final Function(FileInfo file)? onTap;

  const FileList({super.key, required this.files, required this.height, required this.width, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ListView.builder(
        itemCount: files.length,
        itemBuilder: (context, index) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => onTap?.call(files[index]),
              child: SizedBox(
                height: 66,
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
                            child: Center(child: Text(files[index].name.split('.').last.toUpperCase(), style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 18, fontWeight: FontWeight.bold))),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                files[index].name,
                                maxLines: 2,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(files[index].byteSize.formatBytes(), style: const TextStyle(fontSize: 12)),
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
      ),
    );
  }
}
