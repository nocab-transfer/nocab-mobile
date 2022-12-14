import 'package:nocab/provider/theme_provider.dart';
import 'package:nocab/screens/main_screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:nocab/services/settings/settings.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO
  // ignore: unused_local_variable
  var isFirstRun = await SettingsService().initialize();
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(
      themeMode: SettingsService().getSettings.darkMode ? ThemeMode.dark : ThemeMode.light,
      seedColor: SettingsService().getSettings.seedColor,
    ),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NoCab Mobile',
      home: const MainScreen(),
      themeMode: Provider.of<ThemeProvider>(context).themeMode,
      theme: ThemeData(colorSchemeSeed: Provider.of<ThemeProvider>(context).seedColor, brightness: Brightness.light, useMaterial3: true),
      darkTheme: ThemeData(colorSchemeSeed: Provider.of<ThemeProvider>(context).seedColor, brightness: Brightness.dark, useMaterial3: true),
    );
  }
}
