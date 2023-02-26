import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nocab/services/log_manager/log_manager.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';

class LogViewer extends StatefulWidget {
  final File file;
  final bool isCurrentLog;
  LogViewer({super.key, required this.file}) : isCurrentLog = file.path == LogManager.currentLogFile.path;

  @override
  State<LogViewer> createState() => _LogViewerState();
}

class _LogViewerState extends State<LogViewer> {
  List<String> logs = [];
  bool isCorrupted = false;
  StreamSubscription? subscription;
  StreamSubscription? _deleteSubscription;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.isCurrentLog) {
      // If the file is the current log file, then we need to listen to the stream
      LogManager.getCurrentLogs.then((value) {
        setState(() => logs = value);

        Future.delayed(const Duration(milliseconds: 200), () {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent + 100,
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
          );
        });
      });

      subscription = LogManager.onLog.listen((event) async {
        if (logs.isEmpty) return;

        setState(() {
          logs.add(event);
        });

        Future.delayed(const Duration(milliseconds: 500), () {
          if (scrollController.positions.isEmpty) return;
          scrollController.animateTo(
            scrollController.position.maxScrollExtent + 20,
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
          );
        });
      });
      return;
    }

    // If the file is not the current log file, then we need to read from the file
    LogManager.getLogsFromFile(widget.file)
        .then((value) => setState(() => logs = value))
        .onError((error, stackTrace) => setState(() => isCorrupted = true));

    subscription = widget.file.parent.watch(events: FileSystemEvent.modify).listen((event) {
      if (event.path == widget.file.path) {
        LogManager.getLogsFromFile(widget.file)
            .then((value) => setState(() {
                  logs = value;
                  isCorrupted = false;
                }))
            .onError((error, stackTrace) => setState(() => isCorrupted = true));
      }
    });
  }

  @override
  void dispose() {
    // If the file is the current log file, subscription is logStream
    // If the file is not the current log file, subscription is fileWatcher
    subscription?.cancel();
    _deleteSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _deleteSubscription ??= widget.file.parent.watch(events: FileSystemEvent.delete).listen((event) {
      if (event.path == widget.file.path) {
        Navigator.of(context).pop();
      }
    });

    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              //color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildHero(context),
                const SizedBox(height: 8),
                _buildLogs(context),
                const SizedBox(height: 8),
                _buildActions(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 70,
        width: MediaQuery.of(context).size.width - 16,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          border: Border.fromBorderSide(
            BorderSide(
              color: widget.file.path == LogManager.currentLogFile.path
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary.withOpacity(0.4),
              width: 2,
            ),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Hero(
                    tag: "${basenameWithoutExtension(widget.file.path)}icon",
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.file.path == LogManager.currentLogFile.path
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.secondaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.insert_drive_file_rounded,
                          color: widget.file.path == LogManager.currentLogFile.path
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.secondary,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Hero(
                    tag: "${basenameWithoutExtension(widget.file.path)}text",
                    child: Text(
                      basenameWithoutExtension(widget.file.path),
                      style: Theme.of(context).textTheme.labelLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              IconButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.background),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                icon: Icon(
                  Icons.open_in_new_rounded,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: () => OpenFilex.open(widget.file.path, type: "text/plain"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogs(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Center(
        child: Container(
            height: 550,
            width: MediaQuery.of(context).size.width - 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                isCorrupted
                    ? Center(
                        child: Text("Log file is corrupted!", style: Theme.of(context).textTheme.titleMedium),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SelectionArea(
                          child: ListView.builder(
                            controller: scrollController,
                            physics: const BouncingScrollPhysics(),
                            itemCount: logs.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              String log = logs[index];
                              return Text(log);
                            },
                          ),
                        ),
                      ),
                if (widget.isCurrentLog) ...[
                  SizedBox.expand(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            child: Text(
                              "Active",
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]
              ],
            )),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: GestureDetector(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Tooltip(
                    message: widget.isCurrentLog ? "You can't delete the current log file" : "",
                    child: IconButton(
                      onPressed: widget.isCurrentLog ? null : () => widget.file.deleteSync(),
                      icon: const Icon(Icons.delete_rounded),
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Share.shareXFiles([XFile(widget.file.path)]),
                    icon: const Icon(Icons.share_rounded),
                    style: IconButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Clipboard.setData(ClipboardData(text: logs.join("\r\n"))),
                    icon: const Icon(Icons.copy_all_rounded),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
