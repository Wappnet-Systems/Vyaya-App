import 'package:expenses_tracker/screens/otp_verification.dart';
import 'package:expenses_tracker/utils/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({Key? key}) : super(key: key);
  static String verify = "";

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  TextEditingController countryController = TextEditingController();
  bool isLoading = false;
  var phone = "";
  @override
  void initState() {
    countryController.text = "+91";
    super.initState();
  }

  var maskFormatter = MaskTextInputFormatter(
    mask: '##### #####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  child: Image.asset("assets/phone.png")),
              Text(
                "Phone Verification",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(
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
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 40,
                      child: TextField(
                        readOnly: true,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        controller: countryController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Text(
                      "|",
                      style: TextStyle(
                          fontSize: 33,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: TextField(
                      inputFormatters: [maskFormatter],
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      cursorColor: Theme.of(context).colorScheme.onPrimary,
                      onChanged: (value) {
                        phone = value;
                      },
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Phone",
                      ),
                    ))
                  ],
                ),
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
                      setState(() {
                        isLoading = true;
                      });
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        timeout: const Duration(seconds: 60),
                        phoneNumber: countryController.text + phone,
                        verificationCompleted: (PhoneAuthCredential credential) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Row(
                              children: [
                                Text(
                                  'Login successful!',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                          ));
                        },
                        verificationFailed: (FirebaseAuthException e) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Row(
                              children: [
                                Icon(Icons.error, color: Colors.red),
                                SizedBox(width: 10),
                                Text(
                                  'Verification failed,Try Again',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ));
                          setState(() {
                            isLoading = false;
                          });
                        },
                        codeSent: (String verificationId, int? resendToken) {
                          PhoneAuth.verify = verificationId;
        
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.green),
                                SizedBox(width: 10),
                                Text(
                                  'Verification code sent!',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                          ));
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyVerify()));
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                      );
                    },
                    child: isLoading == true
                        ? const Padding(
                            padding: EdgeInsets.all(6.0),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            "Send the code",
                            style: TextStyle(color: PrimaryColor.colorWhite),
                          )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
