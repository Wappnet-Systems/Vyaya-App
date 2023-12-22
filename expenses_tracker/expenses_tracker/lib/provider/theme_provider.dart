import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/const.dart';

class MyTheme {
  static final lightTheme = ThemeData(
    textSelectionTheme: TextSelectionThemeData(selectionHandleColor: PrimaryColor.colorBottleGreen),  
    colorScheme: ColorScheme.fromSeed(seedColor: PrimaryColor.colorBottleGreen).copyWith(
        primary: PrimaryColor.colorWhite,
        onPrimary: PrimaryColor.colorBottleGreen,
        secondary: PrimaryColor.colorBlack,
        background: PrimaryColor.colorWhite,
        onBackground: PrimaryColor.colorBottleGreen,        
        ),        
        cardColor: PrimaryColor.colorWhite,
        hintColor: Colors.black38,    
        dialogBackgroundColor: PrimaryColor.colorWhite,
        useMaterial3: true, 
        bottomAppBarTheme: BottomAppBarTheme(color: PrimaryColor.colorWhite),  
  );
  
  static final darkTheme = ThemeData(
     primaryColor: PrimaryColor.colorBottleGreen, 
     textSelectionTheme: TextSelectionThemeData(selectionHandleColor: PrimaryColor.colorBottleGreen),            
        colorScheme: ColorScheme.fromSeed(seedColor: PrimaryColor.colorBottleGreen).copyWith(
        primary: Colors.black,        
        onPrimary: PrimaryColor.colorBottleGreen,
        secondary: PrimaryColor.colorWhite,
        onSecondary: PrimaryColor.colorBottleGreen,
        background: PrimaryColor.colorWhite,
        onBackground: PrimaryColor.colorBottleGreen,        
      ),
      cardColor: const Color.fromARGB(150, 25, 15, 20),
      hintColor: Colors.white60,
      dialogBackgroundColor: PrimaryColor.colorBlack,
      useMaterial3: true, 
      bottomAppBarTheme:  const BottomAppBarTheme(color:Color.fromARGB(150, 25, 15, 20)),
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


