import 'dart:io';

import 'package:expenses_tracker/screens/home_screen.dart';
import 'package:expenses_tracker/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widgets/fade_transition.dart';

class AuthUser extends StatefulWidget {
  const AuthUser({super.key});

  @override
  State<AuthUser> createState() => _AuthUserState();
}

class _AuthUserState extends State<AuthUser> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool _isFaceIdAvailable = false;
  bool _isFingerprintAvailable = false;
  String _authorized = 'Not Authorized';
  int _failedAttempts = 0;

  @override
  void initState() {
    super.initState();
    _checkBiometricPermission();
    _checkBiometricAvailability();
    _authenticate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(        
      child: Container(
      color: Theme.of(context).colorScheme.primary,
          height: MediaQuery.sizeOf(context).height / 3.5,
          width: MediaQuery.sizeOf(context).width,
          padding: const EdgeInsets.all(16.0),
          child: Card(
            
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [              
              const SizedBox(
                height: 10,
              ),
              Text(
                'Vyaya Security Shield',
                style: TextStyle(
                    fontSize: MediaQuery.sizeOf(context).height / 40,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(12.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Please unlock Vyaya to continue.\nVyaya security shield protects you from \nunauthorized access to vyaya.",
                    style: TextStyle(
                        fontSize: MediaQuery.sizeOf(context).height / 53),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Container(

                    alignment: Alignment.center,
                    width: MediaQuery.sizeOf(context).width / 2.3,
                    child: GestureDetector(
                        onTap: () {
                          exit(0);
                        },
                        child: Text(
                          'Quit',
                          style: TextStyle(
                              color: PrimaryColor.colorRed,
                              fontSize: MediaQuery.sizeOf(context).height / 45),
                        )),
                  ),
                  Container(
                    color: Colors.black,
                    alignment: Alignment.center,
                    width: MediaQuery.sizeOf(context).width / 55,
                    
                  ),
                  GestureDetector(
                    onTap: () {
                      _checkBiometricAvailability();
                      _authenticate();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.sizeOf(context).width / 2.3,
                      child: Text(
                        'Unlock',
                        style: TextStyle(
                            color: PrimaryColor.colorBlue,
                            fontSize: MediaQuery.sizeOf(context).height / 45),
                      ),
                    ),
                  )
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> _checkBiometricAvailability() async {
    bool isFaceIdAvailable = await _localAuthentication.canCheckBiometrics;
    bool isFingerprintAvailable = await _localAuthentication.canCheckBiometrics;
    setState(() {
      _isFaceIdAvailable = isFaceIdAvailable;
      _isFingerprintAvailable = isFingerprintAvailable;
    });
  }

  Future<void> _checkBiometricPermission() async {
    PermissionStatus status = await Permission.camera.status;
    if (!status.isGranted) {
      PermissionStatus updatedStatus = await Permission.camera.request();
      if (updatedStatus.isGranted) {
        _isFaceIdAvailable = true;
      } else {
        _isFaceIdAvailable = false;
      }
    } else {}
  }

  Future<void> _authenticate() async {
    bool isAuthenticated = false;
    _checkBiometricPermission();

    if (_isFaceIdAvailable) {
      isAuthenticated = await _performBiometricAuthentication(
        'Authenticate using Face ID',
        BiometricType.face,
      );
    }

    if (isAuthenticated) {
      setState(() {
        _authorized = 'Authorized';
        _failedAttempts = 0;
      });
      Navigator.of(context).pushReplacement(
                              FadeSlideTransitionRoute(
                                  page: const HomeScreen()),);
      return;
    }

    if (!isAuthenticated && _isFingerprintAvailable) {
      isAuthenticated = await _performBiometricAuthentication(
        'Authenticate using Fingerprint',
        BiometricType.fingerprint,
      );
    }

    if (!isAuthenticated) {
      isAuthenticated = await _localAuthentication.authenticate(
        localizedReason: 'Confirm your screen lock PIN,Pattern or Password',
      );
    }

    if (isAuthenticated) {
      setState(() {
        _authorized = 'Authorized';
        _failedAttempts = 0;
      });
      Navigator.of(context).pushReplacement(
                              FadeSlideTransitionRoute(
                                  page: const HomeScreen()),);
    } else {
      setState(() {
        _failedAttempts++;
      });

      if (_failedAttempts >= 3) {
        await _showLockScreen();
      } else {
        setState(() {
          _authorized = 'Not Authorized';
        });
      }
    }
  }

  Future<bool> _performBiometricAuthentication(
      String reason, BiometricType type) async {
    try {
      bool isAuthenticated = await _localAuthentication.authenticate(
        localizedReason: reason,
      );

      return isAuthenticated;
    } catch (e) {
      return false;
    }
  }

  Future<void> _showLockScreen() async {
    final LocalAuthentication localAuthentication = LocalAuthentication();

    try {
      bool isAuthenticated = await localAuthentication.authenticate(
        localizedReason: 'Authenticate using PIN or password',
      );

      if (isAuthenticated) {
        Navigator.of(context).pushReplacement(
                              FadeSlideTransitionRoute(
                                  page: const HomeScreen()),);
        setState(() {
          _authorized = 'Authorized';
        });
      } else {
        setState(() {
          _authorized = 'Not Authorized';
        });
      }
    } catch (e) {}
  }
}
