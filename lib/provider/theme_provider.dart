import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider({this.themeMode = ThemeMode.light, this.seedColor = const Color(0xFF6750A4)});
  ThemeMode themeMode;
  Color seedColor;

  void changeThemeMode(ThemeMode themeMode) {
    this.themeMode = themeMode;
    notifyListeners();
  }

  void changeSeedColor(Color color) {
    seedColor = color;
    notifyListeners();
  }
}
