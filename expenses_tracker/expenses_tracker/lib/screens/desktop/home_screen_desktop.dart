import 'package:flutter/material.dart';

import '../detail_home_screen.dart';

class HomeScreenDesktop extends StatefulWidget {
  const HomeScreenDesktop({Key? key}) : super(key: key);

  @override
  State<HomeScreenDesktop> createState() => _HomeScreenDesktopState();
}

class _HomeScreenDesktopState extends State<HomeScreenDesktop> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vyaya (Manage Your Expenses)'),
      ),
      body: Row(
        children: [          
          Container(
            width: 200,
            color: Colors.grey[200],
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () {

                  },
                ),
                ListTile(
                  leading: const Icon(Icons.format_list_bulleted),
                  title: const Text('Transactions'),
                  onTap: () {
                    
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.analytics),
                  title: const Text('Analytics'),
                  onTap: () {
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profile'),
                  onTap: () {
                  },
                ),
              ],
            ),
          ),
          const Expanded(
            child: DetailHomeScreen(),
                    
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle FAB click
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
