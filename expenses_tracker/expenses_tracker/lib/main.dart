import 'package:expenses_tracker/provider/theme_provider.dart';
import 'package:expenses_tracker/screens/splash_screen.dart';
import 'package:expenses_tracker/services/notification_services.dart';
import 'package:expenses_tracker/services/theme_manager.dart';
import 'package:expenses_tracker/utils/const.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> _firebaseMessangingBackgroundHandler(RemoteMessage message)async{
  print('Handling Background Notification message ${message.messageId}');
}


Future main() async{
  WidgetsFlutterBinding.ensureInitialized();

   await Firebase.initializeApp();
   await NotificationService.initializeNotification();
   await FirebaseMessaging.instance.getInitialMessage();
   final provider = ThemeProvider();
    provider.loadThemeMode();
    

  runApp(ChangeNotifierProvider.value(
      value: provider,
      child: MyApp(),
    ),);
}


class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();

  }  
  
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(

        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context,listen: true);
          final provider = context.watch<ThemeProvider>();
                   
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vyaya App',
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      themeMode: provider.themeMode,
    home: SplashScreen(),
    );}   
  );
}