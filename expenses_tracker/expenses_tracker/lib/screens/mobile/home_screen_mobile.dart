import 'package:expenses_tracker/utils/const.dart';
import 'package:flutter/material.dart';

import '../../widgets/fade_transition.dart';
import '../detail_home_screen.dart';
import '../profile_screen.dart';
import '../transaction_screen.dart';

class HomeScreenMobile extends StatefulWidget {
  const HomeScreenMobile({Key? key}) : super(key: key);

  @override
  State<HomeScreenMobile> createState() => _HomeScreenMobileState();
}

class _HomeScreenMobileState extends State<HomeScreenMobile> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const DetailHomeScreen(),
      Container(),
      Container(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: Container(
            child: screens[_currentIndex],
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
          ));

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

class ZoomInOutDialogWrapper extends StatefulWidget {
  final Widget Function(BuildContext) builder;

  const ZoomInOutDialogWrapper({super.key, required this.builder});

  @override
  _ZoomInOutDialogWrapperState createState() => _ZoomInOutDialogWrapperState();
}

class _ZoomInOutDialogWrapperState extends State<ZoomInOutDialogWrapper> with SingleTickerProviderStateMixin {
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

