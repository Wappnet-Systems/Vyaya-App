import 'package:expenses_tracker/screens/otp_verification.dart';
import 'package:expenses_tracker/utils/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';


class PhoneAuth extends StatefulWidget {
  const PhoneAuth({Key? key}) : super(key: key);
  static String verify = "";

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  TextEditingController countryController = TextEditingController();
  bool isloading=false;
  var phone = "";
  @override
  void initState() {
    countryController.text = "+91";
    super.initState();
  }

  var maskFormatter = new MaskTextInputFormatter(
    mask: '##### #####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
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
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.secondary,
),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "We need to register your phone without getting started!",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(width: 1,color: Theme.of(context).colorScheme.secondary,),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 40,
                      child: TextField(
                        readOnly: true,
                        style: TextStyle(color:Theme.of(context).colorScheme.secondary,),
                        controller: countryController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Text(
                      "|",
                      style: TextStyle(fontSize: 33, color: Theme.of(context).colorScheme.secondary),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: TextField(
                      inputFormatters: [maskFormatter],
                        style: TextStyle(color:Theme.of(context).colorScheme.secondary,),
                        cursorColor: Theme.of(context).colorScheme.onPrimary,

                      onChanged: (value) {
                        phone = value;
                      },
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Phone",
                      ),
                    ))
                  ],
                ),
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
                      setState(() {
                        isloading=true;
                      });
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        timeout: Duration(seconds: 60),
                        phoneNumber: '${countryController.text + phone}',
                        verificationCompleted:
                            (PhoneAuthCredential credential) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Login successful!'),
                        ));
                            },
                        verificationFailed: (FirebaseAuthException e) {
                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Verification failed,Try Again'),
                          
                        ));
                        setState(() {
                        isloading=false;
                      }); 
                          //Fluttertoast.showToast(msg: 'Verification failed. Code: ${e.code}. Message: ${e.message}');
                        },
                        codeSent: (String verificationId, int? resendToken) {
                          PhoneAuth.verify = verificationId;
                          print(verificationId);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Verification code sent!'),
                          
                        ));
                        setState(() {
                        isloading=false;
                      });
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyVerify()));
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {  
                        },
                      );
                    },
                    child: isloading==true ?Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: CircularProgressIndicator(),
                    ) 
                    :Text(
                      "Send the code",
                      style: TextStyle(color: PrimaryColor.color_white),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}