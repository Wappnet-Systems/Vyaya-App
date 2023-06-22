import 'dart:io';
import 'package:expenses_tracker/model/localtransaction.dart';
import 'package:expenses_tracker/screens/phone_auth.dart';
import 'package:expenses_tracker/screens/user_detail.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:hive/hive.dart';
import '../utils/const.dart';
import '../utils/functions.dart';
import '../widgets/change_theme_button_widget.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;
import '../widgets/custom_header.dart';
import 'dart:convert' as convert;
import 'package:googleapis/drive/v3.dart' as googleDrive;


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? username, initialOfName, wishingText;
  bool _darkMode = false;

  FirebaseAuth auth = FirebaseAuth.instance;
  late Box<LocalTransaction> localTransactionBox;
  final fileName = 'Vyaya_tracker (Data backup).txt';
  final encryptionDecryptionKey = '5a7b3c1eab9fd67032b164fae0c9d8b2';

  @override
  void initState() {
    username = UserData.currentUserName;
    localTransactionBox = Hive.box<LocalTransaction>('local_transactions');
    wishingText = getCurrentHour();
    initialOfName = username!.substring(0, 1).toUpperCase();
    _toggleDarkMode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CustomHeader(
                initialOfName: initialOfName,
                username: username,
                wishingText: wishingText,
                textColor: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                visualDensity: const VisualDensity(vertical: -4),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserDetail(
                                id: 1,
                              )));
                },
              ),
              const Divider(),
              ListTile(
                leading: Icon(
                  Icons.backup_outlined,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: Text(
                  'Upload backup',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                visualDensity: const VisualDensity(vertical: -4),
                onTap: () {
                  Box<LocalTransaction> transactionBox =
                      Hive.box<LocalTransaction>('local_transactions');
                  List<Map<String, dynamic>> jsonData =
                      transactionBox.values.map((e) {
                    return {
                      'Transaction Id': e.tID,
                      'User Id': e.userId,
                      'Transaction Category': e.tCategory,
                      'Transaction Subcategory': e.tCategory,
                      'Transaction Subcategory Index': e.tSubcategoryIndex,
                      'Transaction Amount': e.tAmount,
                      'Transaction Note': e.tNote,
                      'Transaction Time': e.tDateTime.toString(),
                      'Transaction PaymentMode': e.tPaymentMode,
                      'Transaction Created At': e.tCreatedAt.toString(),
                    };
                  }).toList();

                  createFile(fileName, jsonData);
                },
              ),
              const Divider(),
              ListTile(
                leading: Icon(
                  Icons.restore,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: Text(
                  'Restore backup',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                visualDensity: const VisualDensity(vertical: -4),
                onTap: () {
                  importDatabase();
                },
              ),
              const Divider(),
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                visualDensity: const VisualDensity(vertical: -4),
                onTap: () {},
              ),
              const Divider(),
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                visualDensity: const VisualDensity(vertical: -4),
                trailing: const ChangeThemeButtonWidget(),
              ),
              const Divider(),
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                visualDensity: const VisualDensity(vertical: -4),
                onTap: () {},
              ),
              const Divider(),
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
                                color: PrimaryColor.colorRed,
                              ),
                            ),
                            content: Text(
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
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      signOutFunction();
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "Logout",
                                      style: TextStyle(
                                          color: PrimaryColor.colorRed,
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
                        backgroundColor: PrimaryColor.colorRed,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Text(
                      "Logout",
                      style: TextStyle(color: PrimaryColor.colorWhite),
                    )),
              )
            ])),
      ),
    );
  }

  void signOutFunction() async {
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const PhoneAuth()));
  }

  Future<void> createFile(
      String fileName, List<Map<String, dynamic>> jsonData) async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['https://www.googleapis.com/auth/drive.file'],
    );
    googleDrive.DriveApi(http.Client());
    try {
      final googleSignInAccount = await googleSignIn.signIn();
      final googleSignInAuth = await googleSignInAccount!.authentication;
      final response = await http.post(
        Uri.parse('https://www.googleapis.com/drive/v3/files'),
        headers: {
          'Authorization': 'Bearer ${googleSignInAuth.accessToken}',
          'Content-Type': 'application/json',
        },
        body: convert.jsonEncode({
          'name': fileName,
          'mimeType': 'application/json',
        }),
      );

      if (response.statusCode == 200) {
        final fileId = convert.jsonDecode(response.body)['id'];
        await writeFileContent(fileId, jsonData);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to create file'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Upload failed'),
      ));
    }
  }

  Future<String> encryptData(
      List<Map<String, dynamic>> jsonData, String key) async {
    final plainText = convert.utf8.encode(convert.jsonEncode(jsonData));
    final encryptionKey = encrypt.Key.fromUtf8(key);
    final iv = encrypt.IV.fromLength(16); // Initialization vector
    final encrypter = encrypt.Encrypter(encrypt.AES(encryptionKey));
    final encrypted = encrypter.encryptBytes(plainText, iv: iv);
    return convert.base64Encode(encrypted.bytes);
  }

  String removeFirstAndLastCharacter(String text) {
    if (text.length <= 2) {
      return '';
    } else {
      return text.substring(1, text.length - 1);
    }
  }

  List<Map<String, dynamic>> decryptData(String encryptedData, String key) {
    final decryptionKey = encrypt.Key.fromUtf8(key);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(decryptionKey));
    String modifiedText = removeFirstAndLastCharacter(encryptedData);
    final encryptedBytes = convert.base64.decode(modifiedText);
    final decrypted =
        encrypter.decryptBytes(encrypt.Encrypted(encryptedBytes), iv: iv);
    final decryptedJson = convert.utf8.decode(decrypted);
    final jsonData = convert.jsonDecode(decryptedJson);
    return List<Map<String, dynamic>>.from(jsonData);
  }

  Future<void> writeFileContent(
      String fileId, List<Map<String, dynamic>> jsonData) async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['https://www.googleapis.com/auth/drive.file'],
    );
    googleDrive.DriveApi(http.Client());
    try {
      final encryptedData =
          await encryptData(jsonData, encryptionDecryptionKey);
      final googleSignInAccount = await googleSignIn.signIn();
      final googleSignInAuth = await googleSignInAccount!.authentication;
      final response = await http.patch(
        Uri.parse(
            'https://www.googleapis.com/upload/drive/v3/files/$fileId?uploadType=media'),
        headers: {
          'Authorization': 'Bearer ${googleSignInAuth.accessToken}',
          'Content-Type': 'application/json',
        },
        body: convert.jsonEncode(encryptedData),
      );

      if (response.statusCode == 200) {
    

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Row(
    children: [
      Icon(Icons.check_circle, color: Colors.green),
      SizedBox(width: 10),
      Text('File Uploaded successfully',style: TextStyle(color: Colors.green),),
    ],
  ),
        ));
      } else {

    


        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Row(
    children: [
      Icon(Icons.warning, color: Colors.orange),
      SizedBox(width: 10),
      Text('Empty File is Created',style: TextStyle(color: Colors.orange),),
    ],
  ),
        ));
      }
    } catch (e) {
      
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Row(
          children: [
        Icon(Icons.error, color: Colors.red),
        SizedBox(width: 10),
        Text('Upload failed',style: TextStyle(color: Colors.red),),
          ],
        ),
      ));
    }
  }

  Future<ServiceAccountCredentials> obtainCredentials() async {
    return ServiceAccountCredentials.fromJson({
      "type": "service_account",
      "private_key_id": "ccbb4f0477c9a9b4e6cd828612d4243a1bb8b9dc",
      "client_id": "109081127354933570434",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDLIK39TPQTt9on\ntVZrWGXh++vzoljGZbWkl9ZiO8M4mtyPiuZpe3gniON/HWx71p1LLmmmuLBSSrXw\ntePJaEaV653WOkDtXqb4ZrFU/EYh67GyBM2eoKxqPRbIh0XCEnuFaQdaz1zNiX7f\nwBmKs38YdFWJpFp0B9EBaBEcgZ55AtQbExWYS7j/R6T5jNwrxpaGi9HYWC4lj4ue\nTmCA4jtH97gdu2E34reDdv2iz0ENBElfUQ/t+C0ub+wyOiEpGnkIsI4sdqiZ1Wxw\nmLLnyCNMXANwByQgyj8aqPZoNeC2ozz2DeH41Momh4XwfZXR05lpYF5JBZqFewem\ndz7du2kXAgMBAAECggEAR0WBJvZgUabZucMLvoB2xxMQmBynj31SfZz1EOStO+hC\naW8wJ2S2JREH2asmTFFiQWXYljIJU+Z47iuz8BBRa/sPF4K7E055wYCuygX2SaKc\nZ7z9tKHlvSUQIG4uUMkRZB8VAIzvoAKVbMbHb35Jovf2p2PuhPXVJOwxzNHCG+z8\nuKYpjCq3w48yJyznJ4c6vt4cjxI1+ZWg0k1w0KPKxhIepZQSLsTRG3TJiUb6Wf+f\nIuYnDvDLMW+cxNcb+bjDn4uozXNlkgdyKqiJfbBtExx7e9DPr9gsGjypV09kNPLd\ng4yr/eRdaVebw4/5QdUECCPQgxfIFHtYLljvLO23GQKBgQD0uMJj7VdDRS7nwq09\nYkiw2Y26tzm1rMWlmLgsScTytI3pBVXnqELL2jutNVOncXcD13isLZG/OItTswhi\ndZCcQVfXp0Dh4irV6XYI7UPNk3LmYmYKL09GdWnjhofAb06fW0GNPeTFcyybj7Hu\ncVZE1grZ6fNVCkrFT3KHwYWQFQKBgQDUfTDzufs34X8KyLDnM5VoHksO45cd6IiW\ns3TtMqpmIpVApISEEn3Mux+VEndLthfGIa/d1VqSUV+we619GOf0FmL8Fp0zQg8G\nxKXRh/X1mzw/PSnOpPzyrHlnSoskEjcCG4OgndrGA8dWVN0wqIb5Eqat8Uaglu1G\nyQ0MRy8zewKBgCirB4rpp0XDmn7jSDzaN3BERxxPVKTPWG0jiv+5JqSawraFr3f2\n61rLIn2vTf6WiYu25BPg4safU/AN4YfTN7vv0/Q/lDW1ix7PVFE5dLoWFdMZaRGq\nOQdhfb5U3fxpwuwSkzswnPL/J9uWLqCMbySzWUxLZ6erNS/C+yp6S4LdAoGAIprU\nywyBxiL6HpZ6gNycu10bmiwkYyGIhQpqw2pZ59I//kwMrLmaNSpQRWXBedoI2yKH\nUpg5bNTFwacSpOnWdKDks+s25K8gZVjHLG149+u1DxN16IpkC11dVB4GtPQmczhp\n4lFy3IanAv9FGnSHrq6D6JX/i42ozLtXXaWGIVsCgYEAsz1bkpmxIsZDJFIiPeMM\nXY+aztnZlcnL3hVTLFPXS1tAIDnCv4EkW/Qxo/J2vKPoBXMvrLsRYG8KCmUJ8dvW\ngtc1tSR5WdhEm6aKc7GOx5euR7QGNlTZpHH4/8C/ialEMNHmH269hOzt9Tb2iYpL\njqyjmAZ9lmtjtNDgXhzxKSc=\n-----END PRIVATE KEY-----\n",
      "client_email":
          "vyaya-manage-your-expenses@expenses-tracker-56eb0.iam.gserviceaccount.com",
    });
  }

  Future<void> importDatabase() async {
    final filePath = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );

    if (filePath == null) {
      return;
    }
    final file = File(filePath.files.single.path!);
    final fileContent = await file.readAsString();

    final fileDecryptedData = decryptData(fileContent, encryptionDecryptionKey);
    setState(() {
      final jsonData = convertListToMap(fileDecryptedData);
      Box<LocalTransaction> transactionBox =
          Hive.box<LocalTransaction>('local_transactions');
      transactionBox.clear();
      jsonData.forEach((key, data) {
        LocalTransaction transaction = LocalTransaction(
          tID: data['Transaction Id'],
          userId: data['User Id'],
          tCategory: data['Transaction Category'],
          tSubcategory: data['Transaction Subcategory'],
          tSubcategoryIndex: data['Transaction Subcategory Index'],
          tAmount: data['Transaction Amount'],
          tNote: data['Transaction Note'],
          tDateTime: DateTime.parse(data['Transaction Time']),
          tPaymentMode: data['Transaction PaymentMode'],
          tCreatedAt: DateTime.parse(data['Transaction Created At']),
        );
        transactionBox.add(transaction);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Imported Data Successfully\nyou just need to Re-open an App'),
        ));
      });
    });
  }

  Map<String, dynamic> convertListToMap(List<dynamic> list) {
    final map = <String, dynamic>{};
    for (var i = 0; i < list.length; i++) {
      final item = list[i];
      map[i.toString()] = item;
    }
    return map;
  }

  void _toggleDarkMode() {
    setState(() {
      _darkMode = !_darkMode;
    });
  }  
}
