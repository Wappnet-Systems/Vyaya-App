import 'package:expenses_tracker/provider/theme_provider.dart';
import 'package:expenses_tracker/screens/splash_screen.dart';
import 'package:expenses_tracker/services/notification_services.dart';
import 'package:expenses_tracker/utils/functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'model/localtransaction.dart';
import 'model/userlogin.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
   await NotificationService.initializeNotification();
   //  For Local Database
   final appDocumentDir = await getApplicationDocumentsDirectory();
   Hive.init(appDocumentDir.path);
   await Hive.initFlutter('hive.db'); 
   Hive.registerAdapter(LocalTransactionAdapter());
   Hive.registerAdapter(UserLoginAdapter());  
   await Hive.openBox<UserLogin>('userlogin');
   
  //  For Firebase Notification
   await FirebaseMessaging.instance.getInitialMessage();
   final provider = ThemeProvider();
    provider.loadThemeMode();   

  runApp(ChangeNotifierProvider.value(
      value: provider,
      child: const MyApp(),
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){

  return ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final provider = context.watch<ThemeProvider>();

    return ScreenUtilInit(
      designSize: MediaQuery.of(context).size,
      splitScreenMode: true,
      builder: (context,child){
        return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppDetailsClass.appName,
        theme: MyTheme.lightTheme,
        darkTheme: MyTheme.darkTheme,
        themeMode: provider.themeMode,
      home: const SplashScreen(),
      );
      }
    );}   
  );
}
}