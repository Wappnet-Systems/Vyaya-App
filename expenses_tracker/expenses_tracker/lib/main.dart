import 'package:window_manager/window_manager.dart';
import 'package:expenses_tracker/provider/theme_provider.dart';
import 'package:expenses_tracker/screens/splash_screen.dart';
import 'package:expenses_tracker/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'model/localtransaction.dart';
import 'model/localuser.dart';

void main() {  
  WidgetsFlutterBinding.ensureInitialized();
  setMinWindowSize();
  final provider = ThemeProvider();
  Hive.initFlutter('hive.db'); 
  Hive.registerAdapter(LocalTransactionAdapter());
  Hive.registerAdapter(LocalUserAdapter());    
  provider.loadThemeMode();
  runApp(ChangeNotifierProvider.value(
      value: provider,
      child: const MyApp(),
    ),);
}

void setMinWindowSize() async {
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    minimumSize: Size(425,800),
    windowButtonVisibility: true,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context){

  return ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final provider = context.watch<ThemeProvider>();
    return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: AppDetailsClass.appName,
    theme: MyTheme.lightTheme,
    darkTheme: MyTheme.darkTheme,
    themeMode: provider.themeMode,
      home: const SplashScreen(),
      );}   
  );
}
}