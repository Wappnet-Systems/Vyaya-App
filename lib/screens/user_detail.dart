import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:encrypt/encrypt.dart';
import 'package:expenses_tracker/screens/home_screen.dart';
import 'package:expenses_tracker/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/localuser.dart';
import '../model/users.dart';
import '../utils/validation.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/fade_transition.dart';
import 'auth_user.dart';

class UserDetail extends StatefulWidget {
  final String? uid, uname, uEmail;
  final int? id;
  const UserDetail({super.key, this.uid, this.id, this.uname, this.uEmail});

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

  List<Users> listOfUsers = [];
  Map<String, Users> usersList = {};
  // final RegExp _noWhitespaceRegex = RegExp(r'^\S*$');

  late Box<LocalUser> _localUserLoginBox;

  @override
  void initState() {
    super.initState();
    openBox();
    getSingleUserData();

    if (UserData.currentUserName == null || UserData.currentUserEmail == null) {
      userEmailController.text = "";
      firstNameController.text = "";
      lastNameController.text = "";
    } else {
      List<String> nameParts = UserData.currentUserName!.split(' ');
      String firstName = nameParts[0];
      String lastName = nameParts[1];
      firstNameController.text = firstName;
      lastNameController.text = lastName;
      userEmailController.text = UserData.currentUserEmail!;
    }
  }

  Future<void> openBox() async {
    _localUserLoginBox = await Hive.openBox<LocalUser>('local_user');
  }

  void addUserLogin(LocalUser localUser) async {
    var userLoginList = _localUserLoginBox.values.toList();
    var existingUserIndex = userLoginList
        .indexWhere((element) => element.userId == localUser.userId);

    if (existingUserIndex != -1) {
      updateUserLogin(existingUserIndex, localUser);
    } else {
      await _localUserLoginBox.add(localUser);
    }
    getUserLogin();
  }

  List<LocalUser> getUserLogin() {
    // final userLogins = _localUserLoginBox.values.toList();
    return _localUserLoginBox.values.toList();
  }

  void updateUserLogin(int index, LocalUser userLogin) async {
    await _localUserLoginBox.putAt(index, userLogin);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: 
      ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Form(
              // autovalidateMode: AutovalidateMode.onUserInteraction,
              key: userDetailFormGlobalKey,                      
              child: Padding(
                          padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.03,horizontal: MediaQuery.of(context).size.width*0.03),

                child: Column(
                  children: [                                      
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                    child: Image.asset("assets/splashimage.png",height: MediaQuery.of(context).size.height/3.5,width: MediaQuery.of(context).size.width/2.5,)),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                                                child: widget.id == 1
                          ? Text(
                              'Update your Profile',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(
                                      color:
                                          PrimaryColor.colorBottleGreen),
                            )
                          : Text(
                              'Login / Registration',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(
                                      color:
                                          PrimaryColor.colorBottleGreen),
                            )
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),                                    
                    CustomTextFormField(
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    textInputType: TextInputType.name,
                    textEditingController: firstNameController,
                    textEditingHintText: "First Name",
                    customPreFixIcon: Icon(Icons.person,
                    color: Theme.of(context).colorScheme.secondary),
                    customObscureText: true,
                    validationFunction: nameValidator,
                    customInkwell: null),              
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                    textInputAction: TextInputAction.next,
                    textInputType: TextInputType.name,
                    textEditingController: lastNameController,
                    textEditingHintText: "Last Name",
                    customPreFixIcon: Icon(Icons.person,
                        color: Theme.of(context).colorScheme.secondary),
                    customObscureText: true,
                    validationFunction: nameValidator,
                    customInkwell: null,
                    textCapitalization: TextCapitalization.words),
                    
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                    textInputAction: TextInputAction.done,
                    textCapitalization: TextCapitalization.none,
                    readOnly: widget.id == 1 ? true : false,
                    textInputType: TextInputType.emailAddress,
                    textEditingController: userEmailController,
                    textEditingHintText: "Email",
                    customPreFixIcon: Icon(Icons.email,
                        color: Theme.of(context).colorScheme.secondary),
                    customObscureText: true,
                    validationFunction: emailValidator,
                    customInkwell: null),
                    Padding(
                padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom)),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                    onTap: (){addUser(context);},
                    child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: PrimaryColor.colorBottleGreen,
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 18,
                        padding: const EdgeInsets.all(12),
                        child: widget.id == 1
                            ? Text(
                                "Update",
                                style: TextStyle(
                                    color: PrimaryColor.colorWhite,
                                    fontWeight: FontWeight.w400,
                                    fontSize: MediaQuery.of(context)
                                            .size
                                            .height /
                                        50),
                              )
                            : Text(
                                "Save",
                                style: TextStyle(
                                    color: PrimaryColor.colorWhite,
                                    fontWeight: FontWeight.w400,
                                    fontSize: MediaQuery.of(context)
                                            .size
                                            .height /
                                        50),
                              ))),
                    
                    
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  } 
    
  Future<String> encryptData(String? email, String key) async {
    final plainText = utf8.encode(email!);
    final encryptionKey = encrypt.Key.fromUtf8(key);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(encryptionKey));
    final encrypted = encrypter.encryptBytes(plainText, iv: iv);
    uid = base64Encode(encrypted.bytes);
    return base64Encode(encrypted.bytes);
  }

  void addUser(context) async {
    if (userDetailFormGlobalKey.currentState!.validate()) {
      uname = "${firstNameController.text} ${lastNameController.text}";
      uEmail = userEmailController.text;
      encryptData(uEmail, "5a7b3c1eab9fd67032b164fae0c9d8b2");
      UserData.currentUserId = uid;

      final userlogin = LocalUser(
        userId: uid!,
        userName: uname!,
        userEmail: uEmail!,
      );

      addUserLogin(userlogin);
      UserData.currentUserEmail = uEmail;
      UserData.currentUserName = uname;

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString('userId', uid!);

      widget.id == 1
          ? Navigator.of(context).pushReplacement(
                              FadeSlideTransitionRoute(
                                  page: const HomeScreen()),)
          
            
          // ignore: use_build_context_synchronously
          : await showDialog(
              context: context,
              builder: (BuildContext context) {
                return ZoomInOutDialogWrapper(
          builder: (context){
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
                              Navigator.of(context).pushReplacement(
                                FadeSlideTransitionRoute(
                                    page: const HomeScreen()),);                              
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
                              Navigator.of(context).pushReplacement(
                                FadeSlideTransitionRoute(
                                    page: const AuthUser()),);
                              
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
                }
                );
              },
      );
    }
  }

  Future<LocalUser> getSingleUser(String currentUserID) async {
    final box = await Hive.openBox<LocalUser>('local_user');
    final users = box.values.firstWhere((user) => user.userId == currentUserID);

    UserData.currentUserId = users.userId;
    UserData.currentUserName = users.userName;
    UserData.currentUserEmail = users.userEmail;
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
}
