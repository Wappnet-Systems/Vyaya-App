import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/const.dart';

class MyTheme {
  static final lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: PrimaryColor.color_bottle_green).copyWith(

        primary: PrimaryColor.color_white,
        onPrimary: PrimaryColor.color_bottle_green,
        secondary: PrimaryColor.color_black,
        background: PrimaryColor.color_white,
        onBackground: PrimaryColor.color_bottle_green,        
        ),
        
        cardColor: PrimaryColor.color_white,
        bottomAppBarColor: PrimaryColor.color_white,
        hintColor: Colors.black38,    
        dialogBackgroundColor: PrimaryColor.color_white,
        useMaterial3: true,  
  );
  
  static final darkTheme = ThemeData(
     primaryColor: PrimaryColor.color_bottle_green,   
          
        colorScheme: ColorScheme.fromSeed(seedColor: PrimaryColor.color_bottle_green).copyWith(

        primary: PrimaryColor.color_black,
        onPrimary: PrimaryColor.color_bottle_green,
        secondary: PrimaryColor.color_white,
        onSecondary: PrimaryColor.color_bottle_green,
        background: PrimaryColor.color_white,
        onBackground: PrimaryColor.color_bottle_green,
      ),
      cardColor: PrimaryColor.color_black,
      hintColor: Colors.white60,
      dialogBackgroundColor: PrimaryColor.color_black,
      bottomAppBarColor: Color.fromARGB(154, 33, 25, 25),
      useMaterial3: true,
  );
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode? _themeMode;

  ThemeProvider() {
    loadThemeMode();
  }

    ThemeMode get themeMode{
      if(_themeMode==null){
        return ThemeMode.system;
      }
      else{
        return _themeMode!;
      }
      
    } 

  void setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', mode.index);
    notifyListeners();
  }
   
  void loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt('theme_mode');
    _themeMode = index != null ? ThemeMode.values[index] : ThemeMode.system;
    notifyListeners();
  }   
}