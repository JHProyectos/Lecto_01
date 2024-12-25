// lib/src/core/providers/theme_provider.dart
import 'package:flutter/material.dart';
import '../theme/theme_config.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkTheme => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = isDarkTheme ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  ThemeData get currentTheme => isDarkTheme ? ThemeConfig.darkTheme : ThemeConfig.lightTheme;
}
