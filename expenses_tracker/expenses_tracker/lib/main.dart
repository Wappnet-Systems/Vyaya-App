import 'package:expenses_tracker/screens/splash_screen.dart';
import 'package:expenses_tracker/utils/const.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> _firebaseMessangingBackgroundHandler(RemoteMessage message)async{
  print('Handling Background Notification message ${message.messageId}');
}

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();

   await Firebase.initializeApp();
   AwesomeNotifications().initialize(
    'resource://drawable/res_app_icon',
    [
      NotificationChannel(
        channelKey: 'scheduled_channel',
        channelName: 'Scheduled Notifications',
        channelDescription: 'Notifications scheduled at 9 pm',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        vibrationPattern: highVibrationPattern,
      ),
    ],
  );

   await FirebaseMessaging.instance.getInitialMessage();
   FirebaseMessaging.onBackgroundMessage(_firebaseMessangingBackgroundHandler);
   final Future<void> firebase_app_check= FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    androidProvider: AndroidProvider.debug,
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final Future<FirebaseApp> _initialization=Firebase.initializeApp();
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vyaya App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: PrimaryColor.color_bottle_green),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
    
  }
}