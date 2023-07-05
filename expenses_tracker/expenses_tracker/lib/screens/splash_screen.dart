import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:expenses_tracker/screens/auth_user.dart';
import 'package:expenses_tracker/screens/home_screen.dart';
import 'package:expenses_tracker/screens/user_detail.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? userId;
  int? authDisplay;
  SharedPreferences? sharedPreferences;

  @override
  void initState() {
    byPassLoginSharedPreferences();
    authDisplayFromSharedPreferences();
    super.initState();
  }

  void byPassLoginSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userId = sharedPreferences!.getString('userId') ?? "";
    });
  }

  void authDisplayFromSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      authDisplay = sharedPreferences!.getInt('user_auth_biometric') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 1500,
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Theme.of(context).colorScheme.primary,
      splashIconSize: MediaQuery.of(context).size.height /2,
      animationDuration: const Duration(milliseconds: 1500),
      splash: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width/2,
          child: Image.asset("assets/splashimage.png")), 
      ),
      nextScreen: userId == ""
          ? const UserDetail()
          : authDisplay == 0
              ? const HomeScreen()
              : const AuthUser(),
    );
  }
}