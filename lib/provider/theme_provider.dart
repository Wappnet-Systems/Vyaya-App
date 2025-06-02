import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/const.dart';

class MyTheme {
  static const fontSemiBold = 'Poppins-SemiBold';
  static const fontMedium = 'Poppins-Medium';
  static const fontRegular = 'Poppins-Regular';

  static final lightTheme = ThemeData(
    textSelectionTheme: TextSelectionThemeData(
        selectionHandleColor: PrimaryColor.colorBottleGreen),
    colorScheme:
        ColorScheme.fromSeed(seedColor: PrimaryColor.colorBottleGreen).copyWith(
      primary: PrimaryColor.colorWhite,
      onPrimary: PrimaryColor.colorBottleGreen,
      secondary: PrimaryColor.colorBlack,
      background: PrimaryColor.colorWhite,
      onBackground: PrimaryColor.colorBottleGreen,
    ),
    textTheme:const TextTheme(
      displayLarge: TextStyle(
        fontFamily: fontSemiBold,
        fontSize: 24.0,
      ),
      displayMedium: TextStyle(
        fontFamily: fontMedium,
        fontSize: 18.0,
      ),
      displaySmall: TextStyle(
        fontFamily: fontRegular,
        fontSize: 14.0,
      ),
      headlineLarge: TextStyle(
        fontFamily: fontSemiBold,
        fontSize: 24.0,
      ),
      headlineMedium: TextStyle(
        fontFamily: fontMedium,
        fontSize: 20.0,
      ),
      headlineSmall: TextStyle(
        fontFamily: fontRegular,
        fontSize: 16.0,
      ),
      titleLarge: TextStyle(
        fontFamily: fontSemiBold,
        fontSize: 20.0,
      ),
      titleMedium: TextStyle(
        fontFamily: fontMedium,
        fontSize: 16.0,
      ),
      titleSmall: TextStyle(
        fontFamily: fontRegular,
        fontSize: 14.0,
      ),
      bodyLarge: TextStyle(
        fontFamily: fontSemiBold,
        fontSize: 18.0,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontMedium,
        fontSize: 14.0,
      ),
      bodySmall: TextStyle(
        fontFamily: fontRegular,
        fontSize: 12.0,
      ),
      labelLarge: TextStyle(
        fontFamily: fontSemiBold,
        fontSize: 16.0,
      ),
      labelMedium: TextStyle(
        fontFamily: fontMedium,
        fontSize: 14.0,
      ),
      labelSmall: TextStyle(
        fontFamily: fontRegular,
        fontSize: 12.0,
      ),
    ),
    cardColor: PrimaryColor.colorWhite,
    hintColor: Colors.black38,
    dialogBackgroundColor: PrimaryColor.colorWhite,
    useMaterial3: true,
    bottomAppBarTheme: BottomAppBarTheme(color: PrimaryColor.colorWhite),
  );

  static final darkTheme = ThemeData(
    primaryColor: PrimaryColor.colorBottleGreen,
    textSelectionTheme: TextSelectionThemeData(
        selectionHandleColor: PrimaryColor.colorBottleGreen),
    colorScheme:
        ColorScheme.fromSeed(seedColor: PrimaryColor.colorBottleGreen).copyWith(
      primary: Colors.black,
      onPrimary: PrimaryColor.colorBottleGreen,
      secondary: PrimaryColor.colorWhite,
      onSecondary: PrimaryColor.colorBottleGreen,
      background: PrimaryColor.colorWhite,
      onBackground: PrimaryColor.colorBottleGreen,
    ),
    textTheme:const TextTheme(
      displayLarge: TextStyle(
        fontFamily: fontSemiBold,
        fontSize: 24.0,
      ),
      displayMedium: TextStyle(
        fontFamily: fontMedium,
        fontSize: 18.0,
      ),
      displaySmall: TextStyle(
        fontFamily: fontRegular,
        fontSize: 14.0,
      ),
      headlineLarge: TextStyle(
        fontFamily: fontSemiBold,
        fontSize: 24.0,
      ),
      headlineMedium: TextStyle(
        fontFamily: fontMedium,
        fontSize: 20.0,
      ),
      headlineSmall: TextStyle(
        fontFamily: fontRegular,
        fontSize: 16.0,
      ),
      titleLarge: TextStyle(
        fontFamily: fontSemiBold,
        fontSize: 20.0,
      ),
      titleMedium: TextStyle(
        fontFamily: fontMedium,
        fontSize: 16.0,
      ),
      titleSmall: TextStyle(
        fontFamily: fontRegular,
        fontSize: 14.0,
      ),
      bodyLarge: TextStyle(
        fontFamily: fontSemiBold,
        fontSize: 18.0,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontMedium,
        fontSize: 14.0,
      ),
      bodySmall: TextStyle(
        fontFamily: fontRegular,
        fontSize: 12.0,
      ),
      labelLarge: TextStyle(
        fontFamily: fontSemiBold,
        fontSize: 16.0,
      ),
      labelMedium: TextStyle(
        fontFamily: fontMedium,
        fontSize: 14.0,
      ),
      labelSmall: TextStyle(
        fontFamily: fontRegular,
        fontSize: 12.0,
      ),
    ),
    cardColor: const Color.fromARGB(150, 30, 30, 30),
    hintColor: Colors.white60,
    dialogBackgroundColor: PrimaryColor.colorBlack,
    useMaterial3: true,
    bottomAppBarTheme:
        const BottomAppBarTheme(color: Color.fromARGB(150, 25, 15, 20)),
  );
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode? _themeMode;

  ThemeProvider() {
    loadThemeMode();
  }

  ThemeMode get themeMode {
    if (_themeMode == null) {
      return ThemeMode.system;
    } else {
      return _themeMode!;
    }
  }

  void setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt('theme_mode', mode.index);
    notifyListeners();
  }

  void loadThemeMode() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final index = sharedPreferences.getInt('theme_mode');
    _themeMode = index != null ? ThemeMode.values[index] : ThemeMode.light;
    notifyListeners();
  }
}
