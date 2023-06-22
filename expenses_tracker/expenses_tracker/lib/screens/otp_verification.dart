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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const SizedBox(height: 10),
              // SizedBox(
              //     height: MediaQuery.of(context).size.height / 3,
              //     child: Image.asset("assets/phone.png")),
              Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.secondary),
              ),
              const SizedBox(
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
              const SizedBox(
                height: 30,
              ),
              Pinput(
                length: 6,
                onChanged: (value) {
                  code=value;
                },
                showCursor: true,

                
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: PrimaryColor.colorBottleGreen,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      try{
                        PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                              verificationId: PhoneAuth.verify, smsCode: code);
                      await auth.signInWithCredential(credential);
                      
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Login successful!'),));
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const UserDetail()));
                      }
                      catch(e){
                      
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Error: Invalid Otp'),
                    ));                
                    }
                    },
                    child: Text(
                      "Verify Phone Number",
                      style: TextStyle(color: PrimaryColor.colorWhite),
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