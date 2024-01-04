import 'package:expenses_tracker/exports.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  await Hive.initFlutter('hive.db');
  Hive.registerAdapter(LocalTransactionAdapter());
  Hive.registerAdapter(LocalUserAdapter());
  await Hive.openBox<LocalUser>('local_user');
  final provider = ThemeProvider();
  provider.loadThemeMode();
  runApp(
    ChangeNotifierProvider.value(
      value: provider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final provider = context.watch<ThemeProvider>();
          return ScreenUtilInit(
              designSize: MediaQuery.of(context).size,
              builder: (context, child) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: AppDetailsClass.appName,
                  theme: MyTheme.lightTheme,
                  darkTheme: MyTheme.darkTheme,                  
                  themeMode: provider.themeMode,
                  home: const SplashScreen(),
                );
              });
        });
  }
}
