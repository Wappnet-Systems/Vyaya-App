import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:expenses_tracker/screens/auth_user.dart';
import 'package:expenses_tracker/screens/home_screen.dart';
import 'package:expenses_tracker/screens/phone_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? _user;
  int? authDisplay;

  @override
  void initState() {
    _user = FirebaseAuth.instance.currentUser;
    authDisplayFromSharedPreferences();
    super.initState();
  }

  void authDisplayFromSharedPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      authDisplay =
          sharedPreferences.getInt('user_auth_biometric') ?? 0;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 1500,
      splashTransition: SplashTransition.scaleTransition,
      backgroundColor: Theme.of(context).colorScheme.primary,
      splashIconSize: 250,
      animationDuration: const Duration(milliseconds: 1500),
      splash: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height/4,
              width: MediaQuery.of(context).size.width/1.5,
              child: Image.asset("assets/splashimage.png")),
            Text(
              "Vyaya (Manage your Expenses)",
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary,fontSize: MediaQuery.of(context).size.height/40),
            ),
          ],
        ),
      ),
      nextScreen: _user == null ? const PhoneAuth() : authDisplay==0 ?const HomeScreen() :const AuthUser(),
    );
  }
}
