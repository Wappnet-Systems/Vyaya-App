import 'dart:convert';
import 'dart:developer';
import 'package:expenses_tracker/screens/notification_screen.dart';
import 'package:expenses_tracker/screens/profile_screen.dart';
import 'package:expenses_tracker/screens/transaction_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/const.dart';
import 'analytics_screen.dart';
import 'detail_home_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _isloading = false;
  // String? user_token;
  // late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  // initinfo() {
  //   var androidInitialize =
  //       const AndroidInitializationSettings('ic_launcher');
  //   var initializationSettings =
  //       InitializationSettings(android: androidInitialize);
  //   flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //       onSelectNotification: (String? payload) async {
  //     try {
  //       if (payload != null) {
  //       } else {}
  //     } catch (e) {}
  //     return;
  //   });

  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
  //     print("on Message: ${message.notification?.title}");
  //     BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
  //         message.notification!.body.toString(),
  //         htmlFormatBigText: true,
  //         contentTitle: message.notification!.title.toString(),
  //         htmlFormatContentTitle: true);
  //     AndroidNotificationDetails androidNotificationDetails =
  //         AndroidNotificationDetails(
  //             'channelId', 'channelName', 'channelDescription',
  //             importance: Importance.high,
  //             priority: Priority.high,
  //             styleInformation: bigTextStyleInformation,
  //             playSound: true);
  //     NotificationDetails platformspecific =
  //         NotificationDetails(android: androidNotificationDetails);
  //     // await flutterLocalNotificationsPlugin.zonedSchedule(0, message.notification?.title, message.notification?.body,, platformspecific, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime), androidAllowWhileIdle: );
  //     await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
  //         message.notification?.body, platformspecific,
  //         payload: message.data['body']);
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // initinfo();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      const DetailHomeScreen(),
      const AnalyticsScreen(),
      const NotificationScreen(),
      const ProfileScreen(),
    ];

    return SafeArea(
        child: Scaffold(
            backgroundColor: PrimaryColor.color_white,
            body: Container(
              child: _screens[_currentIndex],
            ),
            bottomNavigationBar: BottomAppBar(
              shape: CircularNotchedRectangle(),
              notchMargin: 8.0,
              clipBehavior: Clip.antiAlias,
              color: PrimaryColor.color_white,
              height: MediaQuery.of(context).size.height * 0.08,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.home,
                      size: MediaQuery.of(context).size.height * 0.038,
                    ),
                    color: _currentIndex == 0
                        ? PrimaryColor.color_bottle_green
                        : PrimaryColor.color_black,
                    onPressed: () {
                      setState(() {
                        _currentIndex = 0;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.analytics,
                      size: MediaQuery.of(context).size.height * 0.038,
                    ),
                    color: _currentIndex == 1
                        ? PrimaryColor.color_bottle_green
                        : PrimaryColor.color_black,
                    onPressed: () {
                      setState(() {
                        _currentIndex = 1;
                      });
                    },
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.06,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.notifications,
                      size: MediaQuery.of(context).size.height * 0.038,
                    ),
                    color: _currentIndex == 2
                        ? PrimaryColor.color_bottle_green
                        : PrimaryColor.color_black,
                    onPressed: () {
                      setState(() {
                        _currentIndex = 2;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.people_rounded,
                      size: MediaQuery.of(context).size.height * 0.038,
                    ),
                    color: _currentIndex == 3
                        ? PrimaryColor.color_bottle_green
                        : PrimaryColor.color_black,
                    onPressed: () {
                      setState(() {
                        _currentIndex = 3;
                      });
                    },
                  ),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              backgroundColor: PrimaryColor.color_bottle_green,
              foregroundColor: Colors.white,
              elevation: 4,
              splashColor: Colors.white.withOpacity(0.8),
              onPressed: navigationForTransaction,
              child: Icon(Icons.add, color: PrimaryColor.color_white),
            )));
  }

  String formatTimestamp(int timestamp) {
    var format = new DateFormat('d MMM, hh:mm a');
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return format.format(date);
  }

  Future<void> navigationForTransaction() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TransactionScreen(
                  id: 1,
                )));
  }
}
