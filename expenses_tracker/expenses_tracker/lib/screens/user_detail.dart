
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_tracker/model/userlogin.dart';
import 'package:expenses_tracker/screens/auth_user.dart';
import 'package:expenses_tracker/screens/home_screen.dart';
import 'package:expenses_tracker/utils/const.dart';
import 'package:expenses_tracker/utils/validation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as dev;
import '../model/users.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/custom_text_style.dart';

class UserDetail extends StatefulWidget {
  final String? uid, uname, uMobile, uEmail;
  final int? id;
  const UserDetail(
      {super.key, this.uid, this.uMobile, this.id, this.uname, this.uEmail});

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  String? uid, uname, uMobile, uEmail;
  bool isLoading = false;

  TextEditingController userEmailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  GlobalKey<FormState> userDetailFormGlobalKey = GlobalKey<FormState>();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Users> listOfUsers = [];
  Map<String, Users> usersList = {};

  late UserLogin userlogin;
  late Box<UserLogin> _userLoginBox;

  @override
  void initState() {
    super.initState();
    openBox();
    getFcmToken();
    uid = FirebaseAuth.instance.currentUser!.uid;
    uMobile = FirebaseAuth.instance.currentUser!.phoneNumber;
    getSingleUserData();

    if (UserData.currentUserName == null || UserData.currentUserEmail == null) {
      userEmailController.text = "";
      firstNameController.text = "";
      lastNameController.text="";
    } else {
      List<String> nameParts = UserData.currentUserName!.split(' ');
      dev.log("${UserData.currentUserPhone}");
      String firstName = nameParts[0];
      String lastName = nameParts[1];
      firstNameController.text = firstName;
      lastNameController.text=lastName;
      userEmailController.text = UserData.currentUserEmail!;
    }
  }

  Future<void> openBox() async {
    _userLoginBox = await Hive.openBox<UserLogin>('userlogin');
  }

  void addUserLogin(UserLogin userLogin) async {
    var userLoginList = _userLoginBox.values.toList();
    var existingUserIndex = userLoginList
        .indexWhere((element) => element.userId == userLogin.userId);

    if (existingUserIndex != -1) {
      updateUserLogin(existingUserIndex, userLogin);
    } else {
      await _userLoginBox.add(userLogin);
    }
    getUserLogin();
  }

  List<UserLogin> getUserLogin() {
    final userLogins = _userLoginBox.values.toList();
    for (final userLogin in userLogins) {
      dev.log(
          'User ID: ${userLogin.userId} & User Name: ${userLogin.userName} & User Email: ${userLogin.userEmail} & User Phone: ${userLogin.userPhone} & User Token: ${userLogin.userToken}');
    }
    return _userLoginBox.values.toList();
  }

  void updateUserLogin(int index, UserLogin userLogin) async {
    await _userLoginBox.putAt(index, userLogin);
  }

  void deleteUserLogin(int index) async {
    await _userLoginBox.deleteAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        
        body: ListView(

          physics: const AlwaysScrollableScrollPhysics(),
          primary: true,
          children: [
             Container(

              
              height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                 
                  height: MediaQuery.of(context).size.height/2.2,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: widget.id ==1 ?const SizedBox.shrink() :Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const SizedBox(height: 20,),
                              GestureDetector(
                                onTap: skipUser,
                                child: CustomTextStyle(customTextStyleText: "Skip", customTextColor: PrimaryColor.colorBlue, customTextFontWeight: FontWeight.normal, customtextstyle: null, customTextSize: MediaQuery.of(context).size.height*0.020)),
                            ],
                          ),
                      ),
                      Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          widget.id == 1?CustomTextStyle(customTextStyleText: "Update your Profile", customTextColor: PrimaryColor.colorBottleGreen, customTextFontWeight: FontWeight.normal, customtextstyle: null, customTextSize: MediaQuery.of(context).size.height*0.030)
                          :CustomTextStyle(customTextStyleText: "Complete your Profile", customTextColor: PrimaryColor.colorBottleGreen, customTextFontWeight: FontWeight.normal, customtextstyle: null, customTextSize: MediaQuery.of(context).size.height*0.030),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Expanded(child: Image.asset("assets/userprofilepage.png")),
                    ],
                  )
                ),
              
                SizedBox(height: MediaQuery.of(context).size.height/12,),
                SizedBox(
                  height: MediaQuery.of(context).size.height/2.5,
                  width: MediaQuery.of(context).size.width,
                  child: Form(
                    key: userDetailFormGlobalKey,
                    child: Column(
                      children: [
                        
                        const SizedBox(height: 10,),
                        TextFormField(
                          style:
                              TextStyle(color: Theme.of(context).colorScheme.secondary),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                          ],
                          keyboardType: TextInputType.name,
                          mouseCursor: null,
                          cursorColor: Theme.of(context).colorScheme.onPrimary,
                          controller: firstNameController,
                          enableInteractiveSelection: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                             
                              borderSide: BorderSide(color: Theme.of(context).hintColor),
                              borderRadius: BorderRadius.circular(18.0)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.onPrimary),
                              borderRadius: BorderRadius.circular(18.0)
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
                            hintText: "First Name",
                            hintStyle: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(Icons.person,color: Theme.of(context).colorScheme.secondary),
                            suffixIcon: null,
                          ),
                          validator: nameValidator,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          style:
                              TextStyle(color: Theme.of(context).colorScheme.secondary),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                          ],
                          keyboardType: TextInputType.name,
                          mouseCursor: null,
                          cursorColor: Theme.of(context).colorScheme.onPrimary,
                          controller: lastNameController,
                          enableInteractiveSelection: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(                     
                              borderSide: BorderSide(color: Theme.of(context).hintColor),
                              borderRadius: BorderRadius.circular(18.0)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.onPrimary),
                              borderRadius: BorderRadius.circular(18.0)
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
                            hintText: "Last Name",
                            hintStyle: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(Icons.person,color: Theme.of(context).colorScheme.secondary),
                            suffixIcon: null,
                          ),
                          validator: nameValidator,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextFormField(
                            textInputType: TextInputType.emailAddress,
                            textEditingController: userEmailController,
                            textEditingHintText: "Email",
                            customPreFixIcon: Icon(Icons.email,color: Theme.of(context).colorScheme.secondary),
                            customObscureText: true,
                            validationFunction: emailValidator,
                            customInkwell: null),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: addUser,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: PrimaryColor.colorBottleGreen,
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height/18,
                            padding: const EdgeInsets.all(12),
                            child: widget.id == 1
                                  ? CustomTextStyle(customTextStyleText: "Update", customTextColor: PrimaryColor.colorWhite, customTextFontWeight: FontWeight.w400, customtextstyle: null, customTextSize: MediaQuery.of(context).size.height/50) 
                                  : CustomTextStyle(customTextStyleText: "save", customTextColor: PrimaryColor.colorWhite, customTextFontWeight: FontWeight.w400, customtextstyle: null, customTextSize: MediaQuery.of(context).size.height/50))
                        ),
                        
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        
          ],
      ),)
    );
  }

  void skipUser() async{
    String firstName="userFirst";
      String capitalizedFirstName = firstName[0].toUpperCase() + firstName.substring(1);
      String lastName="userLast";
      String capitalizedLastName = lastName[0].toUpperCase() + lastName.substring(1);
      uname = "$capitalizedFirstName $capitalizedLastName";
      uEmail = userEmailController.text;
      UserData.currentUserId = uid;
      String uToken = UserData.currentUserToken!;

      final userlogin = UserLogin(
          userId: uid!,
          userName: uname!,
          userEmail: uEmail!,
          userPhone: uMobile!,
          userToken: uToken);

      addUserLogin(userlogin);

      UserData.currentUserEmail = uEmail;
      UserData.currentUserName = uname;
      UserData.currentUserPhone = uMobile;
      UserData.currentUserToken = uToken;

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString('userId', uid!);

      dev.log("User Id: ${UserData.currentUserId}");

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  // void _showFaceIdDialog(BuildContext context) async {
  //   bool? enableFaceId = await showDialog<bool>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return const FaceIdDialog();
  //     },
  //   );

  //   if (enableFaceId != null && enableFaceId) {
  //     Navigator.pushReplacement(
  //         context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  //     dev.log('Face ID authentication enabled.');
  //   } else {
  //     Navigator.pushReplacement(
  //         context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  //     dev.log('Face ID authentication not enabled.');
  //   }
  // }

  void addUser() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    if (userDetailFormGlobalKey.currentState!.validate()) {
      String firstName=firstNameController.text;
      String capitalizedFirstName = firstName[0].toUpperCase() + firstName.substring(1);
      String lastName=lastNameController.text;
      String capitalizedLastName = lastName[0].toUpperCase() + lastName.substring(1);
      uname = "$capitalizedFirstName $capitalizedLastName";
      uEmail = userEmailController.text;
      UserData.currentUserId = uid;
      String uToken = UserData.currentUserToken!;

      final userlogin = UserLogin(
          userId: uid!,
          userName: uname!,
          userEmail: uEmail!,
          userPhone: uMobile!,
          userToken: uToken);

      addUserLogin(userlogin);

      UserData.currentUserEmail = uEmail;
      UserData.currentUserName = uname;
      UserData.currentUserPhone = uMobile;
      UserData.currentUserToken = uToken;

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString('userId', uid!);

      dev.log("User Id: ${UserData.currentUserId}");

      // ignore: use_build_context_synchronously
      await showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Text(
        "User Authentication",
        style: TextStyle(
          color: PrimaryColor.colorRed,
        ),
      ),
      content: Text(
        "Authentication using FaceId, Fingerprint, or Password?",
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
                sharedPreferences.setInt('user_auth_biometric', 0);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child: Text(
                "No",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            GestureDetector(
              onTap: () {
                sharedPreferences.setInt('user_auth_biometric', 1);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthUser()),
                );
              },
              child: Text(
                "Yes",
                style: TextStyle(
                  color: PrimaryColor.colorRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  },
);

        

    }
  }

  Future<UserLogin> getSingleUser(String currentUserID) async {
    final box = await Hive.openBox<UserLogin>('userlogin');
    final users = box.values.firstWhere((user) => user.userId == currentUserID);
    UserData.currentUserId = users.userId;
    UserData.currentUserName = users.userName;
    UserData.currentUserEmail = users.userEmail;
    UserData.currentUserPhone = users.userPhone;
    UserData.currentUserToken = users.userToken;
    return users;
  }

  Future<void> getSingleUserData() async {
    listOfUsers.clear();
    setState(() {
      isLoading = true;
    });
    try {
      getSingleUser(uid!);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void getFcmToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        UserData.currentUserToken = token;
            dev.log("${UserData.currentUserToken}");
      });
    });
  }
}
