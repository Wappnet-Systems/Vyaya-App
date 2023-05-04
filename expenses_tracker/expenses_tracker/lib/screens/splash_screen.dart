import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:expenses_tracker/screens/home_screen.dart';
import 'package:expenses_tracker/screens/phone_auth.dart';
import 'package:expenses_tracker/utils/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? _user;

  @override
  void initState() {
    _user = FirebaseAuth.instance.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return AnimatedSplashScreen(
      duration: 1500,
      splashTransition: SplashTransition.scaleTransition,
      backgroundColor: Theme.of(context).colorScheme.primary,
      splashIconSize: 250,
      animationDuration: Duration(milliseconds: 1500),
      splash: Center(
        child: Text(
          "Expenses Tracker",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary,fontSize: MediaQuery.of(context).size.height*0.035),
        ),
      ),
      nextScreen: _user == null ? PhoneAuth() : HomeScreen(),
    );
  }
}
