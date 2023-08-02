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
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final double screenWidth = constraints.maxWidth;

            // Mobile and tablet view (with bottom navigation bar)
            if (screenWidth < 600) {
              return _buildMobileTabletView();
            }
            // Desktop and large screen view (with left-side navigation bar)
            else {
              return _buildDesktopLargeScreenView();
            }
          },
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        
        floatingActionButton: MediaQuery.sizeOf(context).width < 600 ?const SizedBox.shrink() :_currentIndex==3 ?const SizedBox.shrink() :FloatingActionButton.extended(
          label: const Text('Add Transaction'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          backgroundColor: PrimaryColor.colorBottleGreen,
          foregroundColor: Colors.white,
          elevation: 4,
          splashColor: Colors.white.withOpacity(0.8),
          onPressed: navigationForTransaction,
          icon: Icon(Icons.add, color: PrimaryColor.colorWhite),
        ),
      ),
    );
  }

  Widget _buildMobileTabletView() {
    return Scaffold(
      body: _getCurrentScreen(),
      floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: PrimaryColor.colorBottleGreen,
            foregroundColor: Theme.of(context).colorScheme.primary,
            elevation: 4,
            splashColor: Colors.white.withOpacity(0.8),
            onPressed: navigationForTransaction,
            child: Icon(Icons.add, color: PrimaryColor.colorWhite),
          ),              
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin:  MediaQuery.sizeOf(context).width*0.010,
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
    );
  }

  Widget _buildDesktopLargeScreenView() {
    return Row(
      children: [
        NavigationRail(
          selectedIconTheme: IconThemeData(color: PrimaryColor.colorBottleGreen,),
          backgroundColor: Theme.of(context).colorScheme.primary,
          destinations: const [
            NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
            NavigationRailDestination(icon: Icon(Icons.format_list_bulleted), label: Text('Transaction')),
            NavigationRailDestination(icon: Icon(Icons.analytics), label: Text('Analytics')),
            NavigationRailDestination(icon: Icon(Icons.person), label: Text('Profile')),
          ],
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(
          child: _getCurrentScreen(),
        ),
      ],
    );
  }

  Widget _getCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return const DetailHomeScreen();
      case 1:
        return const FilterTransaction();
      case 2:
        return const AnalyticsScreen();
      case 3:
        return const ProfileScreen();
      default:
        return Container();
    }
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
        ),
      ),
    );
  }
}
