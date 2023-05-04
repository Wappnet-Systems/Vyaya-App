import 'package:expenses_tracker/screens/phone_auth.dart';
import 'package:expenses_tracker/screens/user_detail.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/const.dart';
import '../utils/functions.dart';
import '../widgets/change_theme_button_widget.dart';
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

  void getTheme() async {}

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
      backgroundColor: Theme.of(context).colorScheme.primary,
      // floatingActionButton: FloatingActionButton.extended(
      //   backgroundColor: PrimaryColor.color_red,
      //   onPressed: signoutFunction,
      //   label: Text("Signout",style: TextStyle(color: PrimaryColor.color_white),),
      //   icon: Icon(Icons.logout_outlined,color: PrimaryColor.color_white,),
      // ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 15),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CustomHeader(
                initial_of_name: initial_of_name,
                username: username,
                wishingtext: wishingtext,
                textColor: Theme.of(context).colorScheme.secondary,
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                leading: Icon(
                  Icons.edit,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: Text(
                  'Edit Profile',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                visualDensity: VisualDensity(vertical: -4),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserDetail(
                                id: 1,
                              )));
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: Text(
                  'Settings',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                visualDensity: VisualDensity(vertical: -4),
                onTap: () {},
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.info,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: Text(
                  'About App',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                visualDensity: VisualDensity(vertical: -4),
                onTap: () {
                  // Navigate to about page
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.brightness_4,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: Text(
                  'Dark Mode',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                visualDensity: VisualDensity(vertical: -4),
                trailing: ChangeThemeButtonWidget(),
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.star,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: Text(
                  'Rate Us',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                visualDensity: VisualDensity(vertical: -4),
                onTap: () {
                  // Implement rating logic
                },
              ),
              Divider(),
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                                borderRadius: BorderRadius.circular(8)),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            title: Text(
                              "Logout",
                              style: TextStyle(
                                color: PrimaryColor.color_red,
                              ),
                            ),
                            content: new Text(
                              "Are you sure you want to logout?",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            actions: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "Close",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      signoutFunction();
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "Logout",
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
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: PrimaryColor.color_red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Text(
                      "Logout",
                      style: TextStyle(color: PrimaryColor.color_white),
                    )),
              )
            ])),
      ),
    );
  }
}
