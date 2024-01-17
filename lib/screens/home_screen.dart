// ignore_for_file: library_private_types_in_public_api

import 'dart:io';
import 'package:expenses_tracker/screens/profile_screen.dart';
import 'package:expenses_tracker/screens/transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/const.dart';
import '../widgets/fade_transition.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const DetailHomeScreen(),
      const FilterTransaction(),
      const AnalyticsScreen(),
      const ProfileScreen(),
    ];

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        final shouldPop = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return ZoomInOutDialogWrapper(
              builder: (context) => const CustomDialogContent(),
            );
          },
        );
        return shouldPop!;
      },
      child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primary,
          resizeToAvoidBottomInset: true,          
          body: SafeArea(
            child: Container(
              child: screens[_currentIndex],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 8.0,
            clipBehavior: Clip.antiAlias,
            color: Theme.of(context).bottomAppBarTheme.color,
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
                      ? PrimaryColor.colorBottleGreen
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
                      ? PrimaryColor.colorBottleGreen
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
                      ? PrimaryColor.colorBottleGreen
                      : Theme.of(context).colorScheme.secondary,
                  onPressed: () {
                    setState(() {
                      _currentIndex = 2;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.person,
                    size: MediaQuery.of(context).size.height * 0.038,
                  ),
                  color: _currentIndex == 3
                      ? PrimaryColor.colorBottleGreen
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: PrimaryColor.colorBottleGreen,
            foregroundColor: Colors.white,
            elevation: 4,
            splashColor: Colors.white.withOpacity(0.8),
            onPressed: navigationForTransaction,
            child: Icon(Icons.add, color: PrimaryColor.colorWhite),
          )),
    );
  }

  String formatTimestamp(int timestamp) {
    var format = DateFormat('d MMM, hh:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return format.format(date);
  }

  Future<void> navigationForTransaction() async {
    Navigator.of(context).push(
      ZoomInTransitionRoute(
          zoomIn: true,
          page: const TransactionScreen(
            id: 1,
          )),
    );
  }
}

class CustomDialogContent extends StatelessWidget {
  const CustomDialogContent({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Text(
        "Close App",
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: PrimaryColor.colorRed),        
      ),
      content: Text(
        "Are you sure you want to Exit?",
        style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
        
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pop(false); // Close the dialog without exiting
              },
              child: Text(
                "Close",
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            GestureDetector(
              onTap: () {
                exit(0);
              },
              child:  Text(
                "Exit",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: PrimaryColor.colorRed),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ZoomInOutDialogWrapper extends StatefulWidget {
  final Widget Function(BuildContext) builder;

  const ZoomInOutDialogWrapper({super.key, required this.builder});

  @override
  _ZoomInOutDialogWrapperState createState() => _ZoomInOutDialogWrapperState();
}

class _ZoomInOutDialogWrapperState extends State<ZoomInOutDialogWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return ScaleTransition(
          scale: _scaleAnimation,
          child: Opacity(
            opacity: _animationController.value,
            child: widget.builder(context),
          ),
        );
      },
    );
  }
}
