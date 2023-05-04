import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_tracker/screens/home_screen.dart';
import 'package:expenses_tracker/utils/const.dart';
import 'package:expenses_tracker/utils/validation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/users.dart';
import '../widgets/custom_text_form_field.dart';

class UserDetail extends StatefulWidget {
  String? uid, uname, umobile, uemail;
  int? id;
  UserDetail({this.uid, this.umobile,this.id});

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  String? uid, uname, umobile, uemail, upassword;
  bool _isloading = false;

  TextEditingController _useremailController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  GlobalKey<FormState> userDetailFormGlobalKey = GlobalKey<FormState>();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Users> listofUsers = [];

  void addUser() {
    if (userDetailFormGlobalKey.currentState!.validate()) {
      uname = _usernameController.text;
      uemail = _useremailController.text;
      UserData.CurrentUserId = uid;
      final usersRef = firestore
          .collection('users')
          .doc(uid)
          .collection('user_details')
          .doc(uid);
      usersRef.set({
        'userIdfrommobile': uid,
        'userName': uname,
        'userMobile': umobile,
        'Useremail': uemail,
        'UserToken': UserData.CurentUserToken
      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }

  Future<void> getSingleUserData() async {
    listofUsers.clear();
    setState(() {
      _isloading = true;
      print(UserData.CurrentUserId);
    });
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('user_details')
          .get();
      final userData = snapshot.docs
          .map((e) => Users(
              Useremail: e['Useremail'],
              userIdfrommobile: e['userIdfrommobile'],
              userMobile: e['userMobile'],
              userName: e['userName'],
              userToken: e['UserToken']))
          .toList();
      setState(() {
        listofUsers = userData;
        UserData.CurentUserName = listofUsers[0].userName;
        UserData.CurentUserPhone = listofUsers[0].userMobile;
        UserData.CurrentUserEmail = listofUsers[0].Useremail;
        _isloading = false;
      });
    } catch (e) {
      setState(() {
        _isloading = false;
      });
      print(e);
    }
    print(listofUsers.length);
  }

  void getFcmToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        UserData.CurentUserToken = token;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getFcmToken();
    getSingleUserData();
    uid = FirebaseAuth.instance.currentUser!.uid;
    umobile = FirebaseAuth.instance.currentUser!.phoneNumber;
    print(UserData.CurentUserName);
    print(UserData.CurrentUserEmail);
    if (UserData.CurentUserName == null || UserData.CurrentUserEmail == null) {
      _useremailController.text="";
      _usernameController.text="";
    }
    else{
      _usernameController.text = UserData.CurentUserName!;
      _useremailController.text = UserData.CurrentUserEmail!;      
    }
    print(uid);
    print(umobile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: PrimaryColor.color_bottle_green,
        elevation: 5,
        iconTheme: IconThemeData(color: PrimaryColor.color_white),
        title: widget.id==1 ?Text(
          'Update Profile',
          style: TextStyle(color: PrimaryColor.color_white),
        ) 
        :Text(
          'User Detail',
          style: TextStyle(color: PrimaryColor.color_white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: userDetailFormGlobalKey,
          child: Column(
            children: [
              TextFormField(
                style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),],
                keyboardType: TextInputType.name,
                mouseCursor: null,
                cursorColor: Theme.of(context).colorScheme.onPrimary,
                controller: _usernameController,
                 enableInteractiveSelection: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color:Theme.of(context).hintColor),
                    borderRadius: BorderRadius.vertical(),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color:Theme.of(context).colorScheme.onPrimary),
                    borderRadius: BorderRadius.vertical(),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 13, vertical: 12),
                  hintText: "Name",
                  hintStyle: TextStyle(
                    color:Theme.of(context).hintColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                  prefixIcon: Icon(Icons.people),
                  suffixIcon: null,
                ),
                validator: nameValidator,
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextFormField(
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _useremailController,
                  texteditinghinttext: "Email",
                  customprefixicon: const Icon(Icons.email),
                  customobscuretext: true,
                  validationfunction: emailValidator,
                  custominkwell: null),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: addUser,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: PrimaryColor.color_bottle_green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: widget.id ==1  ?Text(
                    "Update",
                    style: TextStyle(color: PrimaryColor.color_white),
                  )
                  :Text(
                    "Save",
                    style: TextStyle(color: PrimaryColor.color_white),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
