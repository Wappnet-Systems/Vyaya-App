import 'package:expenses_tracker/screens/home_screen.dart';
import 'package:expenses_tracker/screens/phone_auth.dart';
import 'package:expenses_tracker/screens/user_detail.dart';
import 'package:expenses_tracker/utils/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class MyVerify extends StatefulWidget {
  const MyVerify({Key? key}) : super(key: key);

  @override
  State<MyVerify> createState() => _MyVerifyState();
}

class _MyVerifyState extends State<MyVerify> {

  final FirebaseAuth auth=FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    var code="";
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 25,
              ),
              Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.secondary),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "We need to register your phone without getting started!",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.secondary
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),
              Pinput(
                length: 6,
                onChanged: (value) {
                  code=value;
                },
                showCursor: true,

                onCompleted: (pin) => print(pin),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: PrimaryColor.color_bottle_green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      try{
                        PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                              verificationId: PhoneAuth.verify, smsCode: code);
                      await auth.signInWithCredential(credential);
                      print(PhoneAuth.verify);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Login successful!'),));
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> UserDetail()));
                      }
                      catch(e){
                        print(e);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Error: Invalid Otp'),
                    ));                
                    }
                    },
                    child: Text(
                      "Verify Phone Number",
                      style: TextStyle(color: PrimaryColor.color_white),
                    )),
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Edit Phone Number ?",
                        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}