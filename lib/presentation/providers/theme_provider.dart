import 'package:flutter/material.dart';

import '../../data/datasource/preferences_manager.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  ThemeProvider() {
    _loadThemePreference();
  }

  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  Future<void> _loadThemePreference() async {
    _isDarkMode = await PreferencesManager.isDarkMode();
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    PreferencesManager.setDarkMode(_isDarkMode);
    notifyListeners();
  }
}