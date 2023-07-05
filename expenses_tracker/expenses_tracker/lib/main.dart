import 'package:expenses_tracker/model/localuser.dart';
import 'package:expenses_tracker/provider/theme_provider.dart';
import 'package:expenses_tracker/screens/splash_screen.dart';
import 'package:expenses_tracker/services/notification_services.dart';
import 'package:expenses_tracker/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'model/localtransaction.dart';

Future main() async{
  
  WidgetsFlutterBinding.ensureInitialized();
   await NotificationService.initializeNotification();
   //  For Local Database
   final appDocumentDir = await getApplicationDocumentsDirectory();
   Hive.init(appDocumentDir.path);
   await Hive.initFlutter('hive.db'); 
   Hive.registerAdapter(LocalTransactionAdapter());
   Hive.registerAdapter(LocalUserAdapter());  
   await Hive.openBox<LocalUser>('local_user');
   
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