import 'dart:io';

import 'package:expenses_tracker/screens/notification_screen.dart';
import 'package:expenses_tracker/screens/profile_screen.dart';
import 'package:expenses_tracker/screens/transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/const.dart';
import 'analytics_screen.dart';
import 'detail_home_screen.dart';
import 'filter_transaction.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _isloading = false;
  
  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    
    final List<Widget> _screens = [
      const DetailHomeScreen(),
      const FilterTransaction(),
      const AnalyticsScreen(),
      const ProfileScreen(),
    ];

    return SafeArea(
        child: WillPopScope(
          onWillPop: ()async{
            final shouldPop = await 
            showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(side: BorderSide(color: Theme.of(context).colorScheme.secondary),borderRadius: BorderRadius.circular(8)),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            title: Text(
                              "Close App",
                              style: TextStyle(
                                color: PrimaryColor.color_red,
                              ),
                            ),
                            content:
                                new Text("Are you sure you want to Exit?",style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                              ),),
                            actions: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Close",style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                              ),),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      exit(0);
                                    },
                                    child: Text(
                                      "Exit",
                                      style: TextStyle(
                                          color: PrimaryColor.color_red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
        return shouldPop!;
          },
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primary,
              body: Container(
                child: _screens[_currentIndex],
              ),
              bottomNavigationBar: BottomAppBar(
                shape: CircularNotchedRectangle(),
                notchMargin: 8.0,
                clipBehavior: Clip.antiAlias,
                color: Theme.of(context).bottomAppBarColor,
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
                          : Theme.of(context).colorScheme.secondary,
                      onPressed: () {
                        setState(() {
                          _currentIndex = 0;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.format_list_bulleted,
                        size: MediaQuery.of(context).size.height * 0.038,
                      ),
                      color: _currentIndex == 1
                          ? PrimaryColor.color_bottle_green
                          : Theme.of(context).colorScheme.secondary,
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
                        Icons.analytics,
                        size: MediaQuery.of(context).size.height * 0.038,
                      ),
                      color: _currentIndex == 2
                          ? PrimaryColor.color_bottle_green
                          : Theme.of(context).colorScheme.secondary,
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
                          : Theme.of(context).colorScheme.secondary,
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
              )),
        ));
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
