import 'package:expenses_tracker/screens/phone_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/const.dart';
import '../utils/functions.dart';
import '../widgets/custom_header.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? username, initial_of_name, wishingtext;
  bool _darkMode = false;
  bool _premium = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  void _toggleDarkMode() {
    setState(() {
      _darkMode = !_darkMode;
    });
  }

  void _togglePremium() {
    setState(() {
      _premium = !_premium;
    });
  }

  @override
  void initState() {
    username = UserData.CurentUserName;
    wishingtext = getCurrentHour();
    initial_of_name = username!.substring(0, 1).toUpperCase();
    _toggleDarkMode();
    _togglePremium();

    super.initState();
  }

  void signoutFunction() async {
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => PhoneAuth()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: PrimaryColor.color_red,
        onPressed: signoutFunction,
        label: Text("Signout",style: TextStyle(color: PrimaryColor.color_white),),
        icon: Icon(Icons.logout_outlined,color: PrimaryColor.color_white,),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 15),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CustomHeader(
                  initial_of_name: initial_of_name,
                  username: username,
                  wishingtext: wishingtext),
                  SizedBox(height: 20,),
                  ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
              visualDensity: VisualDensity(vertical: -4),
              onTap: () {
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About App'),
              contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
  visualDensity: VisualDensity(vertical: -4),
              onTap: () {
                // Navigate to about page
              },
            ),
            // Divider(),
            // ListTile(
            //   leading: Icon(Icons.exit_to_app),
            //   title: Text('Sign Out'),
            //   onTap: () {
            //     // Implement sign out logic
            //   },
            // ),
            Divider(),
            ListTile(
              leading: Icon(Icons.brightness_4),
              title: Text('Dark Mode'),
              contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
  visualDensity: VisualDensity(vertical: -4),
              trailing: Switch(
                value: _darkMode,
                onChanged: (value) {
                  _toggleDarkMode();
                },
              ),
            ),
            // Divider(),
            // ListTile(
            //   leading: Icon(Icons.brightness_5),
            //   title: Text('Light Mode'),
            // ),
            Divider(),
            ListTile(
              leading: Icon(Icons.star),
              title: Text('Rate Us'),
              contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
  visualDensity: VisualDensity(vertical: -4),
              onTap: () {
                // Implement rating logic
              },
            ),
            Divider(),
            // ListTile(
            //   leading: Icon(Icons.lock),
            //   title: Text(_premium ? 'Premium Version' : 'Upgrade to Premium'),
            //   trailing: Switch(
            //     value: _premium,
            //     onChanged: (value) {
            //       _togglePremium();
            //     },
            //   ),
            // ),
              // Center(
              //   child: ElevatedButton(
              //       onPressed: signoutFunction,
              //       style: ElevatedButton.styleFrom(
              //           backgroundColor: PrimaryColor.color_red,
              //           shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(10))),
              //       child: Text(
              //         "Sign-out",
              //         style: TextStyle(color: PrimaryColor.color_white),
              //       )),
              // )
            ])),
      ),
    );
  }
}
