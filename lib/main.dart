import 'package:nocab/provider/theme_provider.dart';
import 'package:nocab/screens/main_screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          return MaterialApp(
            title: 'NoCab Mobile',
            debugShowCheckedModeBanner: false,
            home: const MainScreen(),
            themeMode: Provider.of<ThemeProvider>(context).themeMode,
            theme: ThemeData(colorSchemeSeed: const Color(0xFF6750A4), brightness: Brightness.light),
            darkTheme: ThemeData(colorSchemeSeed: const Color(0xFF6750A4), brightness: Brightness.dark),
          );
        },
      );
}
