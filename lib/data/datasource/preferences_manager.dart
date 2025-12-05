import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {
  static const String _darkModeKey = 'dark_mode';
  static const String _languageCodeKey = 'language_code';

  static Future<bool> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkModeKey) ?? false;
  }

  static Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, value);
  }

  static Future<String> getLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageCodeKey) ?? 'en';
  }

  static Future<void> setLanguageCode(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCodeKey, languageCode);
  }

  static Future<Locale> getSavedLocale() async {
    final languageCode = await getLanguageCode();
    return Locale(languageCode);
  }

  static Future<void> updateLocaleAndReloadWeather(
    BuildContext context,
    String languageCode,
    Function refreshCallback,
  ) async {
    await setLanguageCode(languageCode);
    refreshCallback();
  }
}
