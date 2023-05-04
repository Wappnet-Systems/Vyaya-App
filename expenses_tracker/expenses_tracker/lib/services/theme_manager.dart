import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager {
  static const String _themePreferenceKey = 'theme_preference';
  bool? isDarkMode;
   ThemeData? _lightTheme;
   ThemeData? _darkTheme;

  ThemeManager() {
    _lightTheme = ThemeData.light();
    _darkTheme = ThemeData.dark();
  }

  bool? get _isDarkMode => _isDarkMode;

  ThemeData? get lightTheme => _lightTheme;

  ThemeData? get darkTheme => _darkTheme;

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode = prefs.getBool(_themePreferenceKey) ?? false;
  }

  Future<void> setTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themePreferenceKey, isDarkMode);
  }
}
