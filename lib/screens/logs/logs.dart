import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nocab/screens/logs/log_viewer.dart';
import 'package:nocab/services/log_manager/log_manager.dart';
import 'package:nocab/services/settings/settings.dart';
import 'package:path/path.dart';

class Logs extends StatefulWidget {
  const Logs({super.key});

  @override
  State<Logs> createState() => _LogsState();
}

class _LogsState extends State<Logs> {
  final GlobalKey<AnimatedGridState> _gridKey = GlobalKey<AnimatedGridState>();
  late final List<File> logFiles;
  StreamSubscription? _logSubscription;

  @override
  void initState() {
    super.initState();
    logFiles = LogManager.getLogFiles..sort((a, b) => basenameWithoutExtension(b.path).compareTo(basenameWithoutExtension(a.path)));

    _logSubscription = Directory(LogManager.logFolderPath).watch().listen((event) {
      if (event.type == FileSystemEvent.delete) {
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) {
            setState(() {
              var index = logFiles.indexWhere((element) => element.path == event.path);
              var file = logFiles.removeAt(index);
              _gridKey.currentState?.removeItem(
                index,
                (context, animation) => FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: animation.drive(Tween(begin: 0.8, end: 1.0)),
                    child: _buildLogFileGrid(context, file),
                  ),
                ),
              );
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _logSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 8,
        scrolledUnderElevation: 0,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(16),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              "Logs older than 7 days are automatically deleted.",
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.arrow_back_ios_rounded),
            ),
            const SizedBox(width: 8),
            const Text("Logs"),
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              "(Count: ${logFiles.length} "
              "Total Size: "
              "${logFiles.fold(0, (previousValue, element) => previousValue + element.lengthSync()) / 1000} KB)",
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: _buildGridView(logFiles),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(List<File> initialLogFiles) {
    return AnimatedGrid(
      key: _gridKey,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      initialItemCount: initialLogFiles.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index, animation) {
        return _buildLogFileGrid(
          context,
          initialLogFiles[index],
        );
      },
    );
  }

  Widget _buildLogFileGrid(BuildContext context, File file) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        border: Border.fromBorderSide(
          BorderSide(
            color: file.path == LogManager.currentLogFile.path
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary.withOpacity(0.4),
            width: 2,
          ),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => Navigator.push(
              context,
              PageRouteBuilder(
                opaque: false,
                barrierColor: Colors.black.withOpacity(0.5),
                transitionDuration: const Duration(milliseconds: 200),
                reverseTransitionDuration: const Duration(milliseconds: 200),
                pageBuilder: (context, animation, secondaryAnimation) {
                  return FadeTransition(
                    opacity: animation.drive(CurveTween(curve: Curves.easeInOut)),
                    child: ScaleTransition(
                      scale: animation.drive(Tween(begin: 0.90, end: 1.0).chain(CurveTween(curve: Curves.easeInOut))),
                      //opacity: animation.drive(CurveTween(curve: Curves.easeInOut)),
                      child: LogViewer(file: file),
                    ),
                  );
                },
              )),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                        tag: "${basenameWithoutExtension(file.path)}icon",
                        child: Container(
                          decoration: BoxDecoration(
                            color: file.path == LogManager.currentLogFile.path
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Theme.of(context).colorScheme.secondaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Icon(
                              Icons.insert_drive_file_rounded,
                              color: file.path == LogManager.currentLogFile.path
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.secondary,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Hero(
                        tag: "${basenameWithoutExtension(file.path)}text",
                        child: Text(
                          basenameWithoutExtension(file.path),
                          style: Theme.of(context).textTheme.labelLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        file.existsSync()
                            ? "Last Modified:\n${SettingsService().getSettings.dateFormatType.dateFormat.format(file.lastModifiedSync())}"
                            : "File Deleted",
                        style: Theme.of(context).textTheme.labelSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        file.path == LogManager.currentLogFile.path ? "CURRENT LOG" : "OLD LOG",
                        style: Theme.of(context).textTheme.labelSmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
