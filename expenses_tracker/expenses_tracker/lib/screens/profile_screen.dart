// ignore_for_file: use_build_context_synchronously
import 'package:encrypt/encrypt.dart';
// import 'package:excel/excel.dart';
import 'package:expenses_tracker/exports.dart';
import 'package:expenses_tracker/model/linear_regrassion_model.dart';
import 'package:expenses_tracker/model/prediaction_helper.dart';
import 'package:expenses_tracker/screens/prediction_page.dart';
import 'dart:developer' as dev;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert' as convert;
// ignore: library_prefixes
import 'package:googleapis/drive/v3.dart' as googleDrive;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? username, initialOfName, wishingText;

  static List<LocalTransaction> recentTransaction = [];
  static List<AllTransactionDetails> currentPageTransactions = [];
  Map<String, List<AllTransactionDetails>>? categorizedTransactionsMap;
  Map<String, PredictionHelper>? predictionHelperMap;
  List<Map<String, PredictionHelper>> predictionHelperList = [];

  bool _darkMode = false;
  bool? syncCheck;
  String? masterPassword, lastBackupTime;
  final TextEditingController masterPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  GoogleSignIn googleSignIn = GoogleSignIn();

  late Box<LocalTransaction> localTransactionBox;
  // final fileName = 'Vyaya (backup).txt';
  final encryptionDecryptionKey = '5a7b3c1eab9fd67032b164fae0c9d8b2';
  final masterPasswordKey = "5a7b3c1eab9fd67032b164fae0c9d8b2";

  @override
  void initState() {
    checkForSync();
    print("UserId : ${UserData.currentUserId}");
    username = UserData.currentUserName;
    localTransactionBox = Hive.box<LocalTransaction>('local_transactions');
    wishingText = getCurrentHour();
    initialOfName = username!.substring(0, 1).toUpperCase();
    _toggleDarkMode();
    super.initState();
  }

  void checkForSync() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      syncCheck = sharedPreferences.getBool('sync') ?? false;
      if (syncCheck == true) {
        setState(() {
          lastBackupTime = sharedPreferences.getString('lastUpdated') ?? "";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12.0),
                        visualDensity: const VisualDensity(vertical: -4),
                        onTap: () {
                          Navigator.of(context).push(
                            FadeSlideTransitionRoute(
                                page: const UserDetail(
                              id: 1,
                            )),
                          );
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: Icon(
                          Icons.backup_outlined,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        trailing: syncCheck == true
                            ? GestureDetector(
                                onTap: () async {
                                  final sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  String masterPasswordForSync =
                                      sharedPreferences
                                              .getString('masterPassword') ??
                                          "";
                                  String fileIdForSync =
                                      sharedPreferences.getString('fileId') ??
                                          "";

                                  Box<LocalTransaction> transactionBox =
                                      Hive.box<LocalTransaction>(
                                          'local_transactions');
                                  List<Map<String, dynamic>> jsonData =
                                      transactionBox.values.map((e) {
                                    return {
                                      'Transaction Id': e.tID,
                                      'User Id': e.userId,
                                      'Transaction Category': e.tCategory,
                                      'Transaction Subcategory': e.tSubcategory,
                                      'Transaction Subcategory Index':
                                          e.tSubcategoryIndex,
                                      'Transaction Amount': e.tAmount,
                                      'Transaction Note': e.tNote,
                                      'Transaction Time':
                                          e.tDateTime.toString(),
                                      'Transaction PaymentMode': e.tPaymentMode,
                                      'Transaction Created At':
                                          e.tCreatedAt.toString(),
                                    };
                                  }).toList();
                                  setState(() {
                                    isLoading = true;
                                  });
                                  removeTextFromFile(fileIdForSync, jsonData,
                                          masterPasswordForSync)
                                      .then((_) {});
                                },
                                child: Text(
                                  "Sync Now",
                                  style:
                                      TextStyle(color: PrimaryColor.colorBlue),
                                ))
                            : const SizedBox.shrink(),
                        title: syncCheck == false
                            ? Text(
                                'Upload backup',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Upload backup',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  ),
                                  Text(
                                    'Last Backup : $lastBackupTime',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.012,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  ),
                                ],
                              ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12.0),
                        visualDensity: const VisualDensity(vertical: -4),
                        onTap: () async {
                          if (syncCheck == false) {
                            showCustomDialog(
                                "Set Master Password",
                                "Set a Master Password for your Backup file.\nIt will ask at the time of importing backup so it is important to Remember.",
                                0);
                          }
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
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12.0),
                        visualDensity: const VisualDensity(vertical: -4),
                        onTap: () {
                          showCustomDialog(
                              "Enter Master Password",
                              "Please make sure to enter correct Password which you have entered at the time of Backup otherwise you won't be able to restore Restore backup",
                              1);
                        },
                      ),
                      const Divider(),
                      // ListTile(
                      //   leading: Icon(
                      //     Icons.messenger_outline_outlined,
                      //     color: Theme.of(context).colorScheme.secondary,
                      //   ),
                      //   onTap: (){
                      //     Navigator.of(context).push(
                      //       FadeSlideTransitionRouteForList(
                      //           page: const TextMessageList()),
                      //     );
                      //   },
                      //   title: Text(
                      //     'Auto Read Transaction',
                      //     style: TextStyle(
                      //         color: Theme.of(context).colorScheme.secondary),
                      //   ),
                      //   contentPadding:
                      //       const EdgeInsets.symmetric(horizontal: 12.0),
                      //   visualDensity: const VisualDensity(vertical: -4),
                      //   // trailing: const ChangeThemeButtonWidget(),
                      // ),
                      // const Divider(),
                      ListTile(
                        leading: Icon(
                          Icons.next_plan_rounded,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        title: Text(
                          'Budget Planning',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12.0),
                        visualDensity: const VisualDensity(vertical: -4),
                        trailing: const SizedBox.shrink(),
                        onTap: fetchDataFromGoogleScript,
                      ),
                      const Divider(),
                      ListTile(
                        leading: Icon(
                          Icons.brightness_4,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        title: Text(
                          'Dark Mode',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12.0),
                        visualDensity: const VisualDensity(vertical: -4),
                        trailing: const ChangeThemeButtonWidget(),
                      ),
                      const Divider(),
                      ListTile(
                        leading: Icon(
                          Icons.privacy_tip,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        title: Text(
                          'Privacy policy',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12.0),
                        visualDensity: const VisualDensity(vertical: -4),
                        onTap: () {
                          Navigator.of(context).push(
                            FadeSlideTransitionRouteForList(
                                page: const PrivacyPolicy()),
                          );
                        },
                      ),
                      const Divider(),
                      Center(
                        child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ZoomInOutDialogWrapper(
                                      builder: (context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                          borderRadius:
                                              BorderRadius.circular(8)),
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                      actions: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
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
                                            horizontalSpacer(15),
                                            GestureDetector(
                                              onTap: () {
                                                signOutFunction(context);
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                "Logout",
                                                style: TextStyle(
                                                    color:
                                                        PrimaryColor.colorRed,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  });
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
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  void fetchDataFromGoogleScript() async {
    // String apiUrl = "https://script.google.com/macros/s/AKfycbyGboptjZ6z6BjO4VfyHhpLpodo0kcg3ncHu2RtcryHt0D7MEhaUwP0dVw5ZOQl56uw/exec";
    // final response = await http.get(Uri.parse(apiUrl));
    // // https://script.google.com/macros/s/AKfycbyGboptjZ6z6BjO4VfyHhpLpodo0kcg3ncHu2RtcryHt0D7MEhaUwP0dVw5ZOQl56uw/exec

    // if (response.statusCode == 200) {
    //   // Parse and handle the response data here
    //   print(response.body);
    // } else {
    //   // Handle errors
    //   print('Error: ${response.statusCode}');
    // }
    try {
      recentTransaction = await getAllLocalTransactions();

      setState(() {
        currentPageTransactions = recentTransaction
            .map((e) => AllTransactionDetails(
                uId: e.userId,
                tID: e.tID,
                transactionDate: e.tDateTime,
                transactionAmount: e.tAmount,
                transactionCategory: e.tCategory,
                transactionSubcategory: e.tSubcategory,
                transactionSubcategoryIndex: e.tSubcategoryIndex,
                transactionNote: e.tNote,
                transactionPaymentMode: e.tPaymentMode,
                transactionCreatedAt: e.tCreatedAt))
            .where((element) => element.uId == UserData.currentUserId)
            .toList();
      });
      currentPageTransactions
          .sort((a, b) => a.transactionDate!.compareTo(b.transactionDate!));

      if (currentPageTransactions.isNotEmpty) {
        categorizedTransactionsMap = {};

        for (AllTransactionDetails transaction in currentPageTransactions) {
          String monthYearKey =
              DateFormat.yMMM().format(transaction.transactionDate!);

          if (categorizedTransactionsMap!.containsKey(monthYearKey)) {
            categorizedTransactionsMap![monthYearKey]!.add(transaction);
          } else {
            categorizedTransactionsMap![monthYearKey] = [transaction];
          }
        }
        categorizedTransactionsMap!.forEach((monthYearKey, transactions) {
          predictionHelperMap = {};
          transactions.forEach((transaction) {
            int totalIncome = 0;
            int totlaExpenses = 0;
            int totalNeeds = 0;
            int totalWants = 0;
            int totalSavings = 0;
            for (AllTransactionDetails transaction in transactions) {
              if (transaction.transactionCategory == 0 ||
                  transaction.transactionCategory == 3) {
                totalIncome += transaction.transactionAmount!;
              } else if (transaction.transactionCategory == 1) {
                if (transaction.transactionSubcategory == 0) {
                  totalNeeds += transaction.transactionAmount!;
                } else if (transaction.transactionSubcategory == 1) {
                  totalWants += transaction.transactionAmount!;
                } else if (transaction.transactionSubcategory == 2) {
                  totalSavings += transaction.transactionAmount!;
                } else {}
                totlaExpenses += transaction.transactionAmount!;
              }
            }
            PredictionHelper model = PredictionHelper(
                totalIncome: totalIncome,
                totalExpenses: totlaExpenses,
                needExpenses: totalNeeds,
                wantsExpenses: totalWants,
                savingExpenses: totalSavings,
                remaininBalance: (totalIncome - totlaExpenses));

            bool containsKey = predictionHelperList
                .any((map) => map.containsKey(monthYearKey));
            if (containsKey) {
              // Update the existing map if it contains the key
              predictionHelperList.forEach((map) {
                if (map.containsKey(monthYearKey)) {
                  map[monthYearKey] = model;
                }
              });
            } else {
              Map<String, PredictionHelper> newMap = {monthYearKey: model};
              predictionHelperList.add(newMap);
            }
          });
        });
      } else {
        print("The list is empty");
      }
    } catch (e) {
      dev.log("$e");
    }


    var incomeModel = IncomeModel();
    incomeModel.trainForIncome(predictionHelperList);
    double predictedIncome =
        incomeModel.predictIncome((predictionHelperList.length + 1));
    print('Upcoming Months Income: $predictedIncome');

    var expensesModel = ExpensesModel();
    expensesModel.trainForExpenses(predictionHelperList);
    double predictedExpenses =
        expensesModel.predictExpenses((predictionHelperList.length + 1));
    print('Upcoming Months Expenses: $predictedExpenses');

    var needExpensesModel = NeedExpensesModel();
    needExpensesModel.trainForNeedExpenses(predictionHelperList);
    double predictedNeedExpenses = needExpensesModel
        .predictNeedExpenses((predictionHelperList.length + 1));
    print('Upcoming Months Needs Expenses: $predictedNeedExpenses');

    var wantExpensesModel = WantExpensesModel();
    wantExpensesModel.trainForWantExpenses(predictionHelperList);
    double predictedWantExpenses = wantExpensesModel
        .predictWantExpenses((predictionHelperList.length + 1));
    print('Upcoming Months Wants Expenses: $predictedWantExpenses');

    var savingExpensesModel = SavingExpensesModel();
    savingExpensesModel.trainForSavingExpenses(predictionHelperList);
    double predictedSavingExpenses = savingExpensesModel
        .predictSavingExpenses((predictionHelperList.length + 1));
    print('Upcoming Months Saving Expenses: $predictedSavingExpenses');

    var remainingBalanceModel = RemainingBalanceModel();
    remainingBalanceModel.trainForRemainingBalance(predictionHelperList);
    double predictedRemainingBalance = remainingBalanceModel
        .predictRemainingBalance((predictionHelperList.length + 1));
    print('Upcoming Months Remaining Balance: $predictedRemainingBalance');

    Navigator.of(context).push(
      FadeSlideTransitionRoute(
          page: PredictionPage(
        predictionHelperList: predictionHelperList,
        predictionHelperData: PredictionHelper(
            totalIncome: predictedIncome.toInt(),
            totalExpenses: predictedExpenses.toInt(),
            needExpenses: predictedNeedExpenses.toInt(),
            wantsExpenses: predictedWantExpenses.toInt(),
            savingExpenses: predictedSavingExpenses.toInt(),
            remaininBalance: predictedRemainingBalance.toInt()),
      )),
    );
  }

  // Future<void> createAndSaveExcel(Map<String, PredictionHelper> data) async {
  //   // Create an Excel workbook and add a worksheet
  //   var excel = Excel.createExcel();
  //   var sheet = excel['Sheet1'];

  //   sheet.appendRow([
  //     'No',
  //     'Months',
  //     'Income',
  //     'Expenses',
  //     "Needs",
  //     "Wants",
  //     "Saving",
  //     "Balance"
  //   ]);

  //   int rowIndex = 1;
  //   int listLen = predictionHelperList.length;
  //   for (Map<String, PredictionHelper> map in predictionHelperList) {
  //     for (String key in map.keys) {
  //       var rowData = [
  //         rowIndex,
  //         key,
  //         map[key]!.totalIncome,
  //         map[key]!.totalExpenses,
  //         map[key]!.needExpenses,
  //         map[key]!.wantsExpenses,
  //         map[key]!.savingExpenses,
  //         map[key]!.remaininBalance,
  //       ];
  //       sheet.appendRow(rowData);
  //       rowIndex++;
  //     }
  //   }
  //   // print("Len: ${listLen}");
  //   sheet.appendRow([rowIndex]);
  //   String formulaForPrediction = "FORECAST.LINEAR(A${listLen+2},C2:C${listLen+1},A2:A${listLen+1})";
  //   CellIndex cellIndex= CellIndex.indexByColumnRow(columnIndex: 2,rowIndex: (listLen+1));
  //   var cellValue = sheet.cell(CellIndex.indexByString('C6')).value;
  //   print("Cell Value : $cellValue");
  //   sheet.cell(cellIndex).setFormula("${formulaForPrediction.toUpperCase()}");
  //   final directory =
  //       (await getExternalStorageDirectories(type: StorageDirectory.downloads))!
  //           .first;
  //   String filePath = '${directory.path}/example.xlsx';
  //   await File(filePath).writeAsBytes(excel.encode()!);

  //   print('Excel file saved to: $filePath');
  //   OpenFile.open(filePath);
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  void signOutFunction(context) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('userId', "");
    await sharedPreferences.setBool('sync', false);
    await googleSignIn.signOut();
    Navigator.of(context).pushReplacement(
      FadeSlideTransitionRoute(page: const UserDetail()),
    );
  }

  void showCustomDialog(String titleText, String warningText, int id) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          var mediaQuery = MediaQuery.of(context);
          return ZoomInOutDialogWrapper(builder: (context) {
            return AnimatedContainer(
              padding: mediaQuery.padding,
              duration: const Duration(milliseconds: 300),
              child: AlertDialog(
                scrollable: true,
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.secondary),
                    borderRadius: BorderRadius.circular(8)),
                title: CustomTextStyle(
                  customTextStyleText: titleText,
                  customTextColor: Theme.of(context).colorScheme.secondary,
                  customTextFontWeight: FontWeight.normal,
                  customTextSize: MediaQuery.sizeOf(context).height * 0.022,
                  customTextStyle: null,
                ),
                content: SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.7 / 3,
                  child: Form(
                    autovalidateMode: AutovalidateMode.always,
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Important',
                              style: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          warningText,
                          style: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontWeight: FontWeight.w400,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.015),
                          overflow: TextOverflow.visible,
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.length < 8) {
                              return "Please enter at least 8 character";
                            }
                            return null;
                          },
                          maxLength: 8,
                          controller: masterPasswordController,
                          cursorColor: Theme.of(context).colorScheme.onPrimary,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                              ),
                              labelText: "Master Password",
                              labelStyle: const TextStyle(
                                color:
                                    Colors.grey, // Change color based on focus
                                fontSize: 16,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                              hintText: "8 digit password"),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  GestureDetector(
                      onTap: () {
                        masterPasswordController.clear();
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: PrimaryColor.colorRed),
                      )),
                  horizontalSpacer(7),
                  GestureDetector(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          if (id == 0) {
                            masterPassword = masterPasswordController.text;
                            masterPassword =
                                (masterPassword! + UserData.currentUserEmail!);
                            masterPassword = encryptMasterKey(masterPassword!,
                                "5a7b3c1eab9fd67032b164fae0c9d8b2");
                            masterPassword = masterPassword!.substring(0, 24);
                            masterPasswordController.clear();
                            Navigator.pop(context);
                            setState(() {
                              isLoading = true;
                            });
                            Box<LocalTransaction> transactionBox =
                                Hive.box<LocalTransaction>(
                                    'local_transactions');
                            List<Map<String, dynamic>> jsonData =
                                transactionBox.values.map((e) {
                              return {
                                'Transaction Id': e.tID,
                                'User Id': e.userId,
                                'Transaction Category': e.tCategory,
                                'Transaction Subcategory': e.tSubcategory,
                                'Transaction Subcategory Index':
                                    e.tSubcategoryIndex,
                                'Transaction Amount': e.tAmount,
                                'Transaction Note': e.tNote,
                                'Transaction Time': e.tDateTime.toString(),
                                'Transaction PaymentMode': e.tPaymentMode,
                                'Transaction Created At':
                                    e.tCreatedAt.toString(),
                              };
                            }).toList();

                            createFile(jsonData, masterPassword!);
                          } else {
                            masterPassword = masterPasswordController.text;
                            masterPassword =
                                (masterPassword! + UserData.currentUserEmail!);
                            masterPassword = encryptMasterKey(masterPassword!,
                                "5a7b3c1eab9fd67032b164fae0c9d8b2");
                            masterPassword = masterPassword!.substring(0, 24);
                            Navigator.pop(context);
                            masterPasswordController.clear();
                            importDatabase(masterPassword!);
                          }
                        } else {
                          masterPasswordController.clear();
                        }
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                      )),
                ],
              ),
            );
          });
        });
  }

  Future<void> createFile(
      List<Map<String, dynamic>> jsonData, String masterKeyOfFile) async {
    String fileName = DateFormat.yMMMd().format(DateTime.now());
    googleSignIn = GoogleSignIn(
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
          'name': 'Vyaya backup ($fileName).txt',
          'mimeType': 'application/json',
        }),
      );

      if (response.statusCode == 200) {
        final fileId = convert.jsonDecode(response.body)['id'];
        await writeFileContent(fileId, jsonData, masterKeyOfFile);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to create file'),
        ));
      }
    } catch (e) {
      dev.log("issue $e");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Upload failed'),
      ));
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> writeTextToFile(String fileId,
      List<Map<String, dynamic>> jsonData, String masterKeyOfFile) async {
    String fileContent;
    googleSignIn = GoogleSignIn(
      scopes: ['https://www.googleapis.com/auth/drive.file'],
    );
    googleDrive.DriveApi(http.Client());

    try {
      final encryptedData =
          await encryptData(jsonData, encryptionDecryptionKey);

      final googleSignInAccount = await googleSignIn.signIn();
      final googleSignInAuth = await googleSignInAccount!.authentication;
      fileContent = "$masterKeyOfFile${convert.jsonEncode(encryptedData)}";
      final response = await http.patch(
        Uri.parse(
          'https://www.googleapis.com/upload/drive/v3/files/$fileId?uploadType=media',
        ),
        headers: {
          'Authorization': 'Bearer ${googleSignInAuth.accessToken}',
          'Content-Type': 'text/plain',
        },
        body: fileContent,
      );

      if (response.statusCode == 200) {
        String fileName = DateFormat.yMMMd().format(DateTime.now());
        final renameResponse = await http.patch(
          Uri.parse(
            'https://www.googleapis.com/drive/v3/files/$fileId',
          ),
          headers: {
            'Authorization': 'Bearer ${googleSignInAuth.accessToken}',
            'Content-Type': 'application/json',
          },
          body: convert.jsonEncode({
            'name': 'Vyaya backup ($fileName).txt',
          }),
        );
        dev.log("Response : $renameResponse");
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green),
              horizontalSpacer(10),
              const Text(
                'Backup Uploaded successfully',
                style: TextStyle(color: Colors.green),
              ),
            ],
          ),
        ));
        String lastBackup = DateFormat.yMMMd().format(DateTime.now());
        final sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.setBool('sync', true);
        await sharedPreferences.setString('masterPassword', masterKeyOfFile);
        await sharedPreferences.setString('fileId', fileId);
        await sharedPreferences.setString('lastUpdated', lastBackup);
      } else if (response.statusCode == 404) {
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning, color: Colors.orange),
              horizontalSpacer(10),
              const Text(
                'Failed to update',
                style: TextStyle(color: Colors.orange),
              ),
            ],
          ),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.red),
            horizontalSpacer(10),
            const Text(
              'Sync failed',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ));
    }
  }

  Future<void> removeTextFromFile(String fileId,
      List<Map<String, dynamic>> jsonData, String masterKeyOfFile) async {
    googleSignIn = GoogleSignIn(
      scopes: ['https://www.googleapis.com/auth/drive.file'],
    );
    googleDrive.DriveApi(http.Client());

    try {
      final googleSignInAccount = await googleSignIn.signIn();
      final googleSignInAuth = await googleSignInAccount!.authentication;

      final response = await http.patch(
        Uri.parse(
          'https://www.googleapis.com/upload/drive/v3/files/$fileId?uploadType=media',
        ),
        headers: {
          'Authorization': 'Bearer ${googleSignInAuth.accessToken}',
          'Content-Type': 'text/plain',
        },
        body: '',
      );

      if (response.statusCode == 200) {
        writeTextToFile(fileId, jsonData, masterKeyOfFile);
      } else if (response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.red),
              horizontalSpacer(10),
              const Text(
                'File Does not Exist',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ));
        createFile(jsonData, masterKeyOfFile);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning, color: Colors.orange),
              horizontalSpacer(10),
              const Text(
                'Failed to Sync Data',
                style: TextStyle(color: Colors.orange),
              ),
            ],
          ),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.red),
            horizontalSpacer(10),
            const Text(
              'Failed to Data Sync',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ));
    }
    setState(() {
      isLoading = false;
    });
  }

  String encryptMasterKey(String data, String key) {
    final plainText = utf8.encode(data);
    final encryptionKey = encrypt.Key.fromUtf8(key);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(encryptionKey));
    final encrypted = encrypter.encryptBytes(plainText, iv: iv);

    return base64Encode(encrypted.bytes);
  }

  String decryptMasterKey(String encryptedData, String key) {
    final encryptedBytes = base64Decode(encryptedData);
    final encryptionKey = encrypt.Key.fromUtf8(key);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(encryptionKey));
    final decrypted = encrypter.decryptBytes(Encrypted(encryptedBytes), iv: iv);
    final decryptedData = utf8.decode(decrypted);
    return decryptedData;
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

  void startLoading() {
    setState(() {
      isLoading = true;
    });
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        isLoading = false;
      });
    });
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

  Future<void> writeFileContent(String fileId,
      List<Map<String, dynamic>> jsonData, String masterKeyOfFile) async {
    String fileContent;
    googleSignIn = GoogleSignIn(
      scopes: ['https://www.googleapis.com/auth/drive.file'],
    );
    googleDrive.DriveApi(http.Client());
    try {
      final encryptedData =
          await encryptData(jsonData, encryptionDecryptionKey);
      final googleSignInAccount = await googleSignIn.signIn();
      final googleSignInAuth = await googleSignInAccount!.authentication;
      fileContent = "$masterKeyOfFile${convert.jsonEncode(encryptedData)}";
      final response = await http.patch(
        Uri.parse(
            'https://www.googleapis.com/upload/drive/v3/files/$fileId?uploadType=media'),
        headers: {
          'Authorization': 'Bearer ${googleSignInAuth.accessToken}',
          'Content-Type': 'application/json',
        },
        body: fileContent,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green),
              horizontalSpacer(10),
              const Text(
                'File Uploaded successfully',
                style: TextStyle(color: Colors.green),
              ),
            ],
          ),
        ));
        String lastBackup = DateFormat.yMMMd().format(DateTime.now());
        final sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.setBool('sync', true);
        await sharedPreferences.setString('masterPassword', masterKeyOfFile);
        await sharedPreferences.setString('fileId', fileId);
        await sharedPreferences.setString('lastUpdated', lastBackup);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning, color: Colors.orange),
              horizontalSpacer(10),
              const Text(
                'Empty File is Created',
                style: TextStyle(color: Colors.orange),
              ),
            ],
          ),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.red),
            horizontalSpacer(10),
            const Text(
              'Upload failed',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ));
    }
  }

  Future<ServiceAccountCredentials> obtainCredentials() async {
    return ServiceAccountCredentials.fromJson({
      "type": "service_account",
      "private_key_id": "dad84515f328ab52287029feb1bedc9295b7ad65",
      "client_id": "106102519109678367429",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCm8A1grDLc4z7+\npoH3ovZvpywwt9zx/JPOgQZFPz4RcMyL/i0XQGDLYddpcejk47lGLjtKdCzvioPV\nFORnCYpS1Bva6K3/E+jK3dcAj/CEEoaHxYUXfvFrl00T9KMi42AbQUzT1+dB1W4Y\nuAKw3KA06cX9eZQrf+qcJOxs3zQ2vYOTpaQiQxANNj+6FLTOrLGp11A+XMT7mFqJ\nmgx81Xa+qYxeCNzSRS3eQ9AnjsH09x73KSmAf2/r+1FxikXpplMIPJUGt5Cza7V5\nCqXGwjBjZWR1qYzfuTK0aEaUMOz0lB4H3fqaAOMRr0udHPN34C0bmOz5vLHm8fCR\njhLlmD5XAgMBAAECggEALQHJSYgDioQF5tfzcFVSRZX3lwbrHZ6wJtuoWiEL1d3o\nd9HGTF+B+TNexUH9vUAcImyydYdO2iIpGtiwH4t17JDdFa7nwj6W46LdpXwpJyJr\nfM1m7Ye/BPfcwwWQugY9UfvP/8lUwu4M6cMqjo5c7wcb5xPRO80X7pMR3uRqilss\nUeFJ6ycx4rMVfh8b5vr1hoqQJY8UdLCsxxFUCqjymSHGGJa0FKYRMlc6MgQ/K0Yv\npiL5j4k11yz2gBFTMZmTkgV1+RAGPI2lAVoSbUO/k9TI/YyWqQCUiwd04j9I81zW\n0Gymr2bBJsvpeOzp0q3cPCjdJIJLSSPAwpni4k/0yQKBgQDSmRhlrAT2fvNqJgsD\nXMq0h/OCbt9fGn7j/s/vtdkJlJJLtJc+mDBhx/HkWYglOddxi7pRp3YLlE5ixudJ\nho6nc6NYWMOdtzkbGqLHKUe3pEiGk45T7n1CHeD4+ifa+AkdDOZiA3Iel85CTdCB\nm6vlpqqSXuk31wkJOTLS/1mPRQKBgQDK7VgASOCAqJKp+pvatQ3eGtyQa5oOaiVO\n2NLnyt6A7QBUByjJ1SaxZKds5ShlpuvhsKaV2+xZ62eYI87LuIVYzFJM+L5Ozkyh\nimvQT1phr8sCKHC7PqS+KJ4cClHuSqPOS5NGaGBAOuzIY3Jdfrpfcx5ZtzBD3kkc\nG5EyxRFy6wKBgCPM/NXD4XAZ8r1XzEV9D8SS2/WPbY+YTHvrxGOGsWeshxYxlAiD\nDK6Cs/9SrQ9O/u4Bh+H7qtibFJw8HfNk2Xlj8h/Brzdvf1i5NXTP8q4oUl/2U5q3\nDzofJDCPLhlOUxZKLBv7Y/oJannhCpIN6bH3nEWXtuPUPWgA/j/aQtpVAoGBAKCq\nKfKPwLAcx4ItGRigIMqpGdh+WQrwn3k90j4TMPeCra/Zu0GRsYDh4G0nQkS5VCjs\nY/hil07aQrsCHsjM30be/opSptpeG+4KWjIjobuWI3Uh759Qib7FCenJgfTYw7ih\nvYkROqOgA7jkg7fijkzkKDOABoa1h8zpRpybyqThAoGAM5vKF5R0bRZeXVEfC5/y\nvHkSzezSKRmrUVfunkAWeOFilATDVBmIGX5n3HIScR3Tnc+or5PqXJeXIbETVvts\nAlNsxQLZp6PZ5JpXv6B6EQcIzpCNtJ7Cqs44KjR8aBmZrteOwGsGBfhGKfpC2dWV\n76zkBvCQJmNKd5M1naNGNWg=\n-----END PRIVATE KEY-----\n",
      "client_email": "support-vyaya@vyayatracker.iam.gserviceaccount.com",
    });
  }

  Future<void> importDatabase(String masterKeyToCheck) async {
    final filePath = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );

    if (filePath == null) {
      return;
    }
    final file = File(filePath.files.single.path!);
    final fileContentWithMasterKey = await file.readAsString();
    String masterKeyFromFile = fileContentWithMasterKey.substring(0, 24);
    final fileContent = fileContentWithMasterKey.substring(24);
    setState(() {
      isLoading = true;
    });

    if (masterKeyToCheck == masterKeyFromFile) {
      final fileDecryptedData =
          decryptData(fileContent, encryptionDecryptionKey);
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Your Master Password for Restoring backup is Wrong'),
      ));
    }
    setState(() {
      isLoading = false;
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

// class LinearRegressionModel {
//   late double slopeIncome;
//   late double interceptIncome;

//   void trainForIncome(List<Map<String, PredictionHelper>> data) {
//     final int n = data.length;
//     double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;

//     for (var i = 0; i < n; i++) {
//       var helper = data[i].values.first;
//       var order = i + 1;

//       sumX += order;
//       sumY += helper.totalIncome!;
//       sumXY += order * helper.totalIncome!;
//       sumX2 += order * order;
//     }

//     slopeIncome = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
//     interceptIncome = (sumY - slopeIncome * sumX) / n;
//   }

//   double predictIncome(double order) {
//     return slopeIncome * order + interceptIncome;
//   }
// }
