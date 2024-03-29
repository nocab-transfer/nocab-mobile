import 'package:animations/animations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:nocab/custom_dialogs/sender_dialog_bloc/sender_dialog.dart';

import 'package:nocab/provider/theme_provider.dart';
import 'package:nocab/screens/main_screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:nocab/services/database/database.dart';
import 'package:nocab/services/log_manager/log_manager.dart';
import 'package:nocab/services/network/network.dart';
import 'package:nocab/services/settings/settings.dart';
import 'package:nocab/services/share_intent/share_intent.dart';
import 'package:nocab_core/nocab_core.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: Make first launch screen
  // ignore: unused_local_variable
  var isFirstRun = await SettingsService().initialize();
  FilePicker.platform.clearTemporaryFiles();
  LogManager.cleanOldLogs();
  ShareIntent().initialize(onData: (paths) => _processFilesAndShowDialog(paths));
  Network().initialize((ip) => NoCabCore().updateDeviceInfo(ip: ip));
  NoCabCore.init(
    deviceName: SettingsService().getSettings.deviceName,
    deviceIp: (await Network().getLocalIp()) ?? '',
    requestPort: SettingsService().getSettings.mainPort,
    logFolderPath: LogManager.logFolderPath,
  );

  await Database().initialize();

  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(
      themeMode: SettingsService().getSettings.darkMode ? ThemeMode.dark : ThemeMode.light,
      seedColor: SettingsService().getSettings.seedColor,
    ),
    child: const MyApp(),
  ));
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NoCab Mobile',
      home: const MainScreen(),
      navigatorKey: navigatorKey,
      themeMode: Provider.of<ThemeProvider>(context).themeMode,
      theme: ThemeData(colorSchemeSeed: Provider.of<ThemeProvider>(context).seedColor, brightness: Brightness.light, useMaterial3: true),
      darkTheme: ThemeData(colorSchemeSeed: Provider.of<ThemeProvider>(context).seedColor, brightness: Brightness.dark, useMaterial3: true),
    );
  }
}

_processFilesAndShowDialog(List<String> paths) async {
  List<FileInfo> files = await FileOperations.convertPathsToFileInfos(paths);

  while (navigatorKey.currentState?.context == null) {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  // ignore: use_build_context_synchronously
  showModal(
    context: navigatorKey.currentState!.context,
    configuration: const FadeScaleTransitionConfiguration(barrierDismissible: false),
    builder: ((context) => SenderDialog(files: files)),
  );
}
