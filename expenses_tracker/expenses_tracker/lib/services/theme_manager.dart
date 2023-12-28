import 'package:expenses_tracker/exports.dart';

class ThemeManager {
  static const String _themePreferenceKey = 'theme_preference';
  bool? isDarkMode;
   ThemeData? _lightTheme;
   ThemeData? _darkTheme;

  ThemeManager() {
    _lightTheme = ThemeData.light();
    _darkTheme = ThemeData.dark();
  }

  // bool? get _isDarkMode => isDarkMode;

  ThemeData? get lightTheme => _lightTheme;

  ThemeData? get darkTheme => _darkTheme;

  Future<void> loadTheme() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    isDarkMode = sharedPreferences.getBool(_themePreferenceKey) ?? false;
  }

  Future<void> setTheme(bool isDarkMode) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool(_themePreferenceKey, isDarkMode);
  }
}
