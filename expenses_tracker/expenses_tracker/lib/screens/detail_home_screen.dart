import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_tracker/screens/pf_screen.dart';
import 'package:expenses_tracker/screens/transaction_screen.dart';
import 'package:expenses_tracker/screens/transactions_of_month.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../model/localtransaction.dart';
import '../model/transaction.dart';
import '../model/userlogin.dart';
import '../model/users.dart';
import '../utils/const.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import '../utils/functions.dart';
import '../widgets/build_skeleton.dart';
import '../widgets/custom_balance_card.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_header.dart';
import '../widgets/custom_no_data.dart';
import '../widgets/custom_pf_row.dart';
import '../widgets/custom_text_style.dart';
import '../widgets/custom_transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class DetailHomeScreen extends StatefulWidget {
  const DetailHomeScreen({super.key});

  @override
  State<DetailHomeScreen> createState() => _DetailHomeScreenState();
}

class _DetailHomeScreenState extends State<DetailHomeScreen> {
  static int needsPercentage = 50;
  static int wantsPercentage = 30;
  static int savingPercentage = 20;

  bool isLoading = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? wishingText, currentMonth;
  List<AllTransactionDetails> transactions = [];

  final TextEditingController needsController = TextEditingController();
  final TextEditingController wantsController = TextEditingController();
  final TextEditingController savingController = TextEditingController();

  static double? userScore = 0.0;
  static String? pfScore;
  static double? needProgressValue = 0.0;
  static double? wantProgressValue = 0.0;
  static double? savingProgressValue = 0.0;

  List<Users> listOfUsers = [];
  Color iconColor = PrimaryColor.colorBottleGreen;
  static String? username, initialOfName;

  static List<AllTransactionDetails> currentMonthTransactions = [];
  static List<AllTransactionDetails> currentMonthIncomeTransactions = [];
  static List<AllTransactionDetails> currentMonthSpendingTransactions = [];
  static List<AllTransactionDetails> currentMonthNeedsTransaction = [];
  static List<AllTransactionDetails> currentMonthWantsTransaction = [];
  static List<AllTransactionDetails> currentMonthSavingTransaction = [];

  static List<LocalTransaction> recentTransaction = [];

  static List<int> incomeOfTheMonth = [];
  static List<int> incomeOfTheMonthPf = [];
  static List<int> spendingOfTheMonth = [];
  static int? incomeOfTheMonthValue = 00;
  static int? incomeForPersonalFinance = 00;
  static int? spendingOfTheMonthValue = 00;
  static int? balanceOfTheMonthValue = 00;
  static int? balanceOfTheMonthPfValue = 00;
  static double? needsOfTheMonthValue = 00;
  static double? wantsOfTheMonthValue = 00;
  static double? savingOfTheMonthValue = 00;

  static double? expenseNeedsOfTheValue = 00;
  static double? expenseWantsOfTheValue = 00;
  static double? expenseSavingOfTheValue = 00;

  String? uId;

  @override
  void initState() {
    wishingText = getCurrentHour();
    currentMonth = DateFormat.yMMM().format(DateTime.now());
    getSingleUserData();
    loadVariableFromSharedPreferences();
    getAllTransaction();
    scheduleNotification();
    scheduleWeeklyNotification();
    getBalanceOfMonth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double sliderWidth = screenWidth / 4;
    double sliderHeight = screenHeight / 10;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: isLoading == true
          ? const HomeSkeleton()
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomHeader(
                          initialOfName: initialOfName,
                          username: username,
                          wishingText: wishingText,
                          textColor: Theme.of(context).colorScheme.secondary),
                      const SizedBox(
                        height: 25,
                      ),
                      CustomTextStyle(
                          customTextStyleText: "$currentMonth",
                          customTextColor:
                              Theme.of(context).colorScheme.secondary,
                          customTextFontWeight: FontWeight.normal,
                          customtextstyle: null,
                          customTextSize: 25.0),
                      const SizedBox(
                        height: 7,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const TransactionOfMonth(
                                            id: 3,
                                          )));
                            },
                            child: CustomCard(
                                color: PrimaryColor.colorRed,
                                icon: Icon(
                                  Icons.arrow_upward,
                                  color: PrimaryColor.colorRed,
                                  size: 32,
                                ),
                                themeColor: PrimaryColor.colorWhite,
                                speOrIncMonthValue: spendingOfTheMonthValue,
                                title: "Spending"),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const TransactionOfMonth(
                                            id: 2,
                                          )));
                            },
                            child: CustomCard(
                                color: PrimaryColor.colorBottleGreen,
                                icon: Icon(
                                  Icons.arrow_downward,
                                  color: PrimaryColor.colorBottleGreen,
                                  size: 32,
                                ),
                                themeColor: PrimaryColor.colorWhite,
                                speOrIncMonthValue: incomeOfTheMonthValue,
                                title: "Income"),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomBalanceCard(
                          balanceOfTheMonthValue: balanceOfTheMonthValue!,
                          themeColor: Theme.of(context).cardColor,
                          textThemeColor:
                              Theme.of(context).colorScheme.secondary),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextStyle(
                                customTextStyleText: "Personal Finance",
                                customTextColor:
                                    Theme.of(context).colorScheme.secondary,
                                customTextFontWeight: FontWeight.w400,
                                customtextstyle: null,
                                customTextSize: 20),
                            GestureDetector(
                              onTap: () {
                                needsController.text = "$needsPercentage";
                                wantsController.text = "$wantsPercentage";
                                savingController.text = "$savingPercentage";

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    int needs = int.parse(needsController.text);
                                    int wants = int.parse(wantsController.text);
                                    int saving =
                                        int.parse(savingController.text);
                                    int? finalTotal;
                                    finalTotal = needs + wants + saving;
                                    return AlertDialog(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      title: CustomTextStyle(
                                          customTextStyleText:
                                              "Set Personal Finance",
                                          customTextColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          customTextFontWeight:
                                              FontWeight.normal,
                                          customtextstyle: null,
                                          customTextSize: screenHeight * 0.025),
                                      content: SizedBox(
                                        height: screenHeight * 0.23,
                                        child: Column(
                                          children: [
                                            CustomPfRow(
                                                labelText: "Needs:",
                                                hintText:
                                                    "Set Needs Percentage",
                                                textEditingController:
                                                    needsController,
                                                maskTextInputFormatter:
                                                    maskFormatter),
                                            CustomPfRow(
                                                labelText: "Wants:",
                                                hintText:
                                                    "Set Wants Percentage",
                                                textEditingController:
                                                    wantsController,
                                                maskTextInputFormatter:
                                                    maskFormatter),
                                            CustomPfRow(
                                                labelText: "Saving:",
                                                hintText:
                                                    "Set Saving Percentage",
                                                textEditingController:
                                                    savingController,
                                                maskTextInputFormatter:
                                                    maskFormatter),
                                            const SizedBox(
                                              height: 07,
                                            ),
                                            finalTotal == 100
                                                ? const Text('')
                                                : Row(
                                                    children: [
                                                      Text(
                                                        "Please Enter possible values",
                                                        style: TextStyle(
                                                            color: PrimaryColor
                                                                .colorRed),
                                                      ),
                                                    ],
                                                  ),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                  color: PrimaryColor.colorRed),
                                            )),
                                        const SizedBox(
                                          width: 07,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              finalTotal = int.parse(
                                                      needsController.text) +
                                                  int.parse(
                                                      wantsController.text) +
                                                  int.parse(
                                                      savingController.text);

                                              if (finalTotal == 100) {
                                                pfManager(
                                                    int.parse(
                                                        wantsController.text),
                                                    "wants_percent",
                                                    int.parse(
                                                        needsController.text),
                                                    "needs_percent",
                                                    int.parse(
                                                        savingController.text),
                                                    "saving_percent");
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const HomeScreen()));
                                              } else {}
                                            },
                                            child: Text(
                                              "Save",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary),
                                            )),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const CustomTextStyle(
                                  customTextStyleText: "Set Manually",
                                  customTextColor: Colors.blueAccent,
                                  customTextFontWeight: FontWeight.w400,
                                  customtextstyle: null,
                                  customTextSize: 14),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.44,
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          elevation: 5,
                          color: Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                            
                          ),
                          child: incomeForPersonalFinance! <= 0
                              ? const Center(
                                  child: CustomNoData(),
                                )
                              : Column(
                                  children: [
                                    const SizedBox(height: 07,),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: screenWidth/2.201, child: Column(
                                          children: [
                                            Text("Amount Left",style: TextStyle(
                                              color: Theme.of(context).hintColor,
                                              fontWeight: FontWeight.w400,
                                              fontSize: screenHeight * 0.022,
                                            ),),
                                          Text(
                                            formatCurrencyForBalance(balanceOfTheMonthPfValue),
                                            style: TextStyle(
                                              color: pfScore=='Excellent' ?PrimaryColor.colorBottleGreen :pfScore=='Good' ?PrimaryColor.colorBlue :PrimaryColor.colorRed,
                                              fontWeight: FontWeight.w400,
                                              fontSize: screenHeight * 0.022,
                                            ),
                                          ),
                                          ],
                                        )),
                                        SizedBox(
                                          width: screenWidth/2.201, child: Column(
                                          children : [
                                            Text(
                                            'Performance',
                                            style: TextStyle(
                                              color: Theme.of(context).hintColor,
                                              fontWeight: FontWeight.w400,
                                              fontSize: screenHeight * 0.022,
                                            ),),
                                          Text(
                                            '$pfScore',
                                            style: TextStyle(
                                              color: pfScore=='Excellent' ?PrimaryColor.colorBottleGreen :pfScore=='Good' ?PrimaryColor.colorBlue :PrimaryColor.colorRed,
                                              fontWeight: FontWeight.w400,
                                              fontSize: screenHeight * 0.022,
                                            ),
                                          ),
                                          ]
                                          
                                        ))                                        
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          width: sliderWidth,
                                          height: sliderHeight,
                                          child: SleekCircularSlider(
                                            appearance:
                                                CircularSliderAppearance(
                                              startAngle: 0,
                                              angleRange: 360,
                                              customColors: CustomSliderColors(
                                                trackColor:
                                                    Theme.of(context).hintColor,
                                                progressBarColor: PrimaryColor
                                                    .colorBottleGreen,
                                                dotColor: PrimaryColor
                                                    .colorBottleGreen,
                                              ),
                                              customWidths: CustomSliderWidths(
                                                trackWidth: 1.5,
                                                progressBarWidth: 2.5,
                                                handlerSize: 4,
                                              ),
                                              infoProperties: InfoProperties(
                                                modifier: (double value) {
                                                  final roundedValue = value
                                                      .ceil()
                                                      .toInt()
                                                      .toString();
                                                  return '$roundedValue%';
                                                },
                                                mainLabelStyle: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary),
                                              ),
                                            ),
                                            min: 0,
                                            max: 100,
                                            initialValue: (expenseNeedsOfTheValue! *
                                                        100 /
                                                        needsOfTheMonthValue!) <=
                                                    0
                                                ? 0
                                                : (expenseNeedsOfTheValue! *
                                                            100 /
                                                            needsOfTheMonthValue!) >=
                                                        100
                                                    ? 100
                                                    : (expenseNeedsOfTheValue! *
                                                        100 /
                                                        needsOfTheMonthValue!),
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: screenWidth / 1.7,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Text(
                                                'Needs',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    fontSize:
                                                        screenHeight / 45),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                            Container(
                                              width: screenWidth / 1.7,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    '${formatCurrency(expenseNeedsOfTheValue)} / ${formatCurrency(needsOfTheMonthValue)}',
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                      fontSize:
                                                          screenHeight / 55,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PfScreen(
                                                            id: 0,
                                                            transactions:
                                                                currentMonthNeedsTransaction,
                                                          )));
                                            },
                                            child: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              size: screenWidth / 20,
                                            )),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Divider(color: Colors.grey[400]),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          width: sliderWidth,
                                          height: sliderHeight,
                                          child: SleekCircularSlider(
                                            appearance:
                                                CircularSliderAppearance(
                                              startAngle: 0,
                                              angleRange: 360,
                                              customColors: CustomSliderColors(
                                                trackColor:
                                                    Theme.of(context).hintColor,
                                                progressBarColor:
                                                    PrimaryColor.colorRed,
                                                dotColor: PrimaryColor.colorRed,
                                              ),
                                              customWidths: CustomSliderWidths(
                                                trackWidth: 1.5,
                                                progressBarWidth: 2.5,
                                                handlerSize: 4,
                                              ),
                                              infoProperties: InfoProperties(
                                                modifier: (double value) {
                                                  final roundedValue = value
                                                      .ceil()
                                                      .toInt()
                                                      .toString();
                                                  return '$roundedValue%';
                                                },
                                                mainLabelStyle: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary),
                                              ),
                                            ),
                                            min: 0,
                                            max: 100,
                                            initialValue: (expenseWantsOfTheValue! *
                                                        100 /
                                                        wantsOfTheMonthValue!) <=
                                                    0
                                                ? 0
                                                : (expenseWantsOfTheValue! *
                                                            100 /
                                                            wantsOfTheMonthValue!) >=
                                                        100
                                                    ? 100
                                                    : (expenseWantsOfTheValue! *
                                                        100 /
                                                        wantsOfTheMonthValue!),
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: screenWidth / 1.7,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Text(
                                                'Wants',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    fontSize:
                                                        screenHeight / 45),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                            Container(
                                              width: screenWidth / 1.7,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Text(
                                                    '${formatCurrency(expenseWantsOfTheValue)} / ${formatCurrency(wantsOfTheMonthValue)}',
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                      fontSize:
                                                          screenHeight / 55,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PfScreen(
                                                            id: 1,
                                                            transactions:
                                                                currentMonthWantsTransaction,
                                                          )));
                                            },
                                            child: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              size: screenWidth / 20,
                                            )),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Divider(color: Colors.grey[400]),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          width: sliderWidth,
                                          height: sliderHeight,
                                          child: SleekCircularSlider(
                                            appearance:
                                                CircularSliderAppearance(
                                              startAngle: 0,
                                              angleRange: 360,
                                              customColors: CustomSliderColors(
                                                trackColor:
                                                    Theme.of(context).hintColor,
                                                progressBarColor:
                                                    PrimaryColor.colorBlue,
                                                dotColor:
                                                    PrimaryColor.colorBlue,
                                              ),
                                              customWidths: CustomSliderWidths(
                                                trackWidth: 1.5,
                                                progressBarWidth: 2.5,
                                                handlerSize: 4,
                                              ),
                                              infoProperties: InfoProperties(
                                                modifier: (double value) {
                                                  final roundedValue = value
                                                      .ceil()
                                                      .toInt()
                                                      .toString();
                                                  return '$roundedValue%';
                                                },
                                                mainLabelStyle: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary),
                                              ),
                                            ),
                                            min: 0,
                                            max: 100,
                                            initialValue: (expenseSavingOfTheValue! *
                                                        100 /
                                                        savingOfTheMonthValue!) <=
                                                    0
                                                ? 0
                                                : (expenseSavingOfTheValue! *
                                                            100 /
                                                            savingOfTheMonthValue!) >=
                                                        100
                                                    ? 100
                                                    : (expenseSavingOfTheValue! *
                                                        100 /
                                                        savingOfTheMonthValue!),
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: screenWidth / 1.7,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Text(
                                                'Saving',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    fontSize:
                                                        screenHeight / 45),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                            Container(
                                              width: screenWidth / 1.7,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child:
                                              Text(
                                                    '${formatCurrency(expenseSavingOfTheValue)} / ${formatCurrency(savingOfTheMonthValue)}',
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                      fontSize:
                                                          screenHeight / 55,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ), 
                                              
                                            ),
                                          ],
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PfScreen(
                                                            id: 2,
                                                            transactions:
                                                                currentMonthSavingTransaction,
                                                          )));
                                            },
                                            child: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              size: screenWidth / 20,
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextStyle(
                                customTextStyleText: "Recent Transaction",
                                customTextColor:
                                    Theme.of(context).colorScheme.secondary,
                                customTextFontWeight: FontWeight.w400,
                                customtextstyle: null,
                                customTextSize: 20),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const TransactionOfMonth(
                                              id: 1,
                                            )));
                              },
                              child: const CustomTextStyle(
                                  customTextStyleText: "View all",
                                  customTextColor: Colors.blueAccent,
                                  customTextFontWeight: FontWeight.w400,
                                  customtextstyle: null,
                                  customTextSize: 14),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Theme.of(context).colorScheme.primary,
                        height: transactions.length == 4
                            ? screenHeight * 0.450
                            : transactions.length == 3
                                ? screenHeight * 0.340
                                : transactions.length == 2
                                    ? screenHeight * 0.225
                                    : transactions.length == 1
                                        ? screenHeight * 0.115
                                        : screenHeight * 0.225,
                        width: MediaQuery.of(context).size.width,
                        child: transactions.isEmpty
                            ? const Center(child: CustomNoData())
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: transactions.length,
                                itemBuilder: (BuildContext context, int index) {
                                  if (transactions[index].transactionCategory ==
                                      0) {
                                    iconColor = PrimaryColor.colorBottleGreen;
                                  }
                                  if (transactions[index].transactionCategory ==
                                      1) {
                                    iconColor = PrimaryColor.colorRed;
                                  }
                                  if (transactions[index].transactionCategory ==
                                      2) {
                                    iconColor = PrimaryColor.colorBottleGreen;
                                  }
                                  return transactions.isEmpty
                                      ? const Center(child: CustomNoData())
                                      : GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        TransactionScreen(
                                                          id: 2,
                                                          transactionId:
                                                              transactions[
                                                                      index]
                                                                  .tID,
                                                          transactionNote:
                                                              transactions[
                                                                      index]
                                                                  .transactionNote,
                                                          transactionAmount:
                                                              transactions[
                                                                      index]
                                                                  .transactionAmount,
                                                          transactionSubcategoryIndex:
                                                              transactions[
                                                                      index]
                                                                  .transactionSubcategoryIndex,
                                                          transactionDate:
                                                              "${DateFormat.yMMMd().format(transactions[index].transactionDate!.toDate())} ${DateFormat.jm().format(transactions[index].transactionDate!.toDate())}",
                                                          transactionSubcategory:
                                                              transactions[
                                                                      index]
                                                                  .transactionSubcategory,
                                                          transactionCategory:
                                                              transactions[
                                                                      index]
                                                                  .transactionCategory,
                                                        )));
                                          },
                                          child: CustomTransaction(
                                              themeColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              textTheme: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              iconColor: iconColor,
                                              categoryId: transactions[index]
                                                  .transactionCategory,
                                              subCateId: transactions[index]
                                                  .transactionSubcategoryIndex,
                                              transactionAmount:
                                                  transactions[index]
                                                      .transactionAmount,
                                              transactionNote:
                                                  transactions[index]
                                                      .transactionNote,
                                              dateStamp: DateFormat.yMMMd()
                                                  .format(transactions[index]
                                                      .transactionDate!
                                                      .toDate()),
                                              timeStamp: DateFormat.jm().format(
                                                  transactions[index]
                                                      .transactionDate!
                                                      .toDate())));
                                }),
                      ),
                    ]),
              ),
            ),
    );
  }

  void scheduleWeeklyNotification() async {
    DateTime now = DateTime.now();
    int timestamp = now.millisecondsSinceEpoch ~/ 1000;
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: timestamp,
        channelKey: 'high_importance_channel',
        title: 'Vyaya App',
        body: 'Check your Expenses of the Week!',
        notificationLayout: NotificationLayout.BigText,
      ),
      schedule: NotificationCalendar(
        weekday: DateTime.monday,
        hour: 09,
        minute: 00,
        second: 00,
        millisecond: 0,
        repeats: true,
        allowWhileIdle: true,
      ),
    );
  }

  void scheduleNotification() async {
    DateTime now = DateTime.now();
    int timestamp = now.millisecondsSinceEpoch ~/ 1000;
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: timestamp,
        channelKey: 'high_importance_channel',
        title: 'Vyaya App',
        body: 'Don\'t forget to enter your daily Expenses!',
        notificationLayout: NotificationLayout.BigText,
      ),
      schedule: NotificationCalendar(
        hour: 19,
        minute: 00,
        second: 00,
        millisecond: 0,
        repeats: true,
        allowWhileIdle: true,
      ),
    );
  }

  Future<void> getBalanceOfMonth() async {
    incomeOfTheMonth.clear();
    spendingOfTheMonth.clear();
    incomeOfTheMonthPf.clear();
    currentMonthSpendingTransactions.clear();
    currentMonthSavingTransaction.clear();
    currentMonthIncomeTransactions.clear();
    currentMonthWantsTransaction.clear();
    currentMonthNeedsTransaction.clear();

    incomeOfTheMonthValue = 00;
    balanceOfTheMonthPfValue = 00;
    incomeForPersonalFinance = 00;
    spendingOfTheMonthValue = 00;
    balanceOfTheMonthValue = 00;

    needsOfTheMonthValue = 00;
    wantsOfTheMonthValue = 00;
    savingOfTheMonthValue = 00;

    expenseNeedsOfTheValue = 00;
    expenseWantsOfTheValue = 00;
    expenseSavingOfTheValue = 00;

    setState(() {
      isLoading = true;
    });
    try {
      final tempTransactionData = getTransactionsThisMonth();
      recentTransaction = await tempTransactionData;
      setState(() {
        currentMonthTransactions = recentTransaction
            .map((e) => AllTransactionDetails(
                uId: e.userId,
                tID: e.tID,
                transactionDate: Timestamp.fromDate(e.tDateTime),
                transactionAmount: e.tAmount,
                transactionCategory: e.tCategory,
                transactionSubcategory: e.tSubcategory,
                transactionSubcategoryIndex: e.tSubcategoryIndex,
                transactionNote: e.tNote,
                transactionPaymentMode: e.tPaymentMode,
                transactionCreatedAt: Timestamp.fromDate(e.tCreatedAt)))
            .toList();
        findIncomeSpending();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  static void findIncomeSpending() {
    for (int i = 0, j = 0, k = 0; i < currentMonthTransactions.length; i++) {
      if (currentMonthTransactions[i].transactionCategory == 0 ||
          currentMonthTransactions[i].transactionCategory == 3) {
        if (currentMonthTransactions[i].transactionCategory == 0) {
          // incomeOfTheMonthValue = (incomeOfTheMonthValue! + currentMonthTransactions[i].transactionAmount!);
          incomeOfTheMonth.add(currentMonthTransactions[i].transactionAmount!);
        } else {
          // incomeOfTheMonthValue = (incomeOfTheMonthValue! + currentMonthTransactions[i].transactionAmount!);
          incomeOfTheMonth.add(currentMonthTransactions[i].transactionAmount!);
          incomeOfTheMonthPf
              .add(currentMonthTransactions[i].transactionAmount!);
          currentMonthIncomeTransactions.insert(
              j,
              AllTransactionDetails(
                  uId: currentMonthTransactions[i].uId,
                  tID: currentMonthTransactions[i].tID,
                  transactionDate: currentMonthTransactions[i].transactionDate,
                  transactionAmount:
                      currentMonthTransactions[i].transactionAmount,
                  transactionCategory:
                      currentMonthTransactions[i].transactionCategory,
                  transactionSubcategory:
                      currentMonthTransactions[i].transactionSubcategory,
                  transactionSubcategoryIndex:
                      currentMonthTransactions[i].transactionSubcategoryIndex,
                  transactionNote: currentMonthTransactions[i].transactionNote,
                  transactionPaymentMode:
                      currentMonthTransactions[i].transactionPaymentMode,
                  transactionCreatedAt:
                      currentMonthTransactions[i].transactionCreatedAt));
          j++;
        }
      } else if (currentMonthTransactions[i].transactionCategory == 1) {
        // spendingOfTheMonthValue = (spendingOfTheMonthValue! +
        //     currentMonthTransactions[i].transactionAmount!);
        spendingOfTheMonth.add(currentMonthTransactions[i].transactionAmount!);
        currentMonthSpendingTransactions.insert(
            k,
            AllTransactionDetails(
                uId: currentMonthTransactions[i].uId,
                tID: currentMonthTransactions[i].tID,
                transactionDate: currentMonthTransactions[i].transactionDate,
                transactionAmount:
                    currentMonthTransactions[i].transactionAmount,
                transactionCategory:
                    currentMonthTransactions[i].transactionCategory,
                transactionSubcategory:
                    currentMonthTransactions[i].transactionSubcategory,
                transactionSubcategoryIndex:
                    currentMonthTransactions[i].transactionSubcategoryIndex,
                transactionNote: currentMonthTransactions[i].transactionNote,
                transactionPaymentMode:
                    currentMonthTransactions[i].transactionPaymentMode,
                transactionCreatedAt:
                    currentMonthTransactions[i].transactionCreatedAt));
        k++;
      }
    }
    totalIncomeOfTheMonth();
    totalExpensesOfTheMonth();
    getBalance();
  }

  static void totalIncomeOfTheMonth() {
    for (int i = 0; i < incomeOfTheMonth.length; i++) {
      incomeOfTheMonthValue = incomeOfTheMonth[i] + incomeOfTheMonthValue!;
    }
    for (int i = 0; i < incomeOfTheMonthPf.length; i++) {
      incomeForPersonalFinance =
          incomeOfTheMonthPf[i] + incomeForPersonalFinance!;
    }
  }

  static void totalExpensesOfTheMonth() {
    for (int i = 0; i < spendingOfTheMonth.length; i++) {
      spendingOfTheMonthValue =
          spendingOfTheMonth[i] + spendingOfTheMonthValue!;
    }
  }

  String formatCurrencyForBalance(int? value) {
    NumberFormat currencyFormat = NumberFormat.currency(
      symbol: '₹',
      locale: "HI",
      decimalDigits: 0,
    );
    return currencyFormat.format(value);
  }


  String formatCurrency(double? value) {
    NumberFormat currencyFormat = NumberFormat.currency(
      symbol: '₹',
      locale: "HI",
      decimalDigits: 0,
    );
    return currencyFormat.format(value);
  }

  static void getBalance() {
    balanceOfTheMonthValue =
        (incomeOfTheMonthValue! - spendingOfTheMonthValue!);

    balanceOfTheMonthPfValue =
        (incomeForPersonalFinance! - spendingOfTheMonthValue!);

    needsOfTheMonthValue = (incomeForPersonalFinance! * needsPercentage / 100);
    wantsOfTheMonthValue = (incomeForPersonalFinance! * wantsPercentage / 100);
    savingOfTheMonthValue =
        (incomeForPersonalFinance! * savingPercentage / 100);

    getPersonalFinance();
  }

  static getPersonalFinance() {
    for (int i = 0, j = 0, k = 0, x = 0;
        i < currentMonthSpendingTransactions.length;
        i++) {
      if (currentMonthSpendingTransactions[i].transactionSubcategory == 0) {
        currentMonthNeedsTransaction.insert(
            j,
            AllTransactionDetails(
                uId: currentMonthSpendingTransactions[i].uId,
                tID: currentMonthSpendingTransactions[i].tID,
                transactionDate:
                    currentMonthSpendingTransactions[i].transactionDate,
                transactionAmount:
                    currentMonthSpendingTransactions[i].transactionAmount,
                transactionCategory:
                    currentMonthSpendingTransactions[i].transactionCategory,
                transactionSubcategory:
                    currentMonthSpendingTransactions[i].transactionSubcategory,
                transactionSubcategoryIndex: currentMonthSpendingTransactions[i]
                    .transactionSubcategoryIndex,
                transactionNote:
                    currentMonthSpendingTransactions[i].transactionNote,
                transactionPaymentMode:
                    currentMonthSpendingTransactions[i].transactionPaymentMode,
                transactionCreatedAt:
                    currentMonthSpendingTransactions[i].transactionCreatedAt));
        j++;
      } else if (currentMonthSpendingTransactions[i].transactionSubcategory ==
          1) {
        currentMonthWantsTransaction.insert(
            k,
            AllTransactionDetails(
                uId: currentMonthSpendingTransactions[i].uId,
                tID: currentMonthSpendingTransactions[i].tID,
                transactionDate:
                    currentMonthSpendingTransactions[i].transactionDate,
                transactionAmount:
                    currentMonthSpendingTransactions[i].transactionAmount,
                transactionCategory:
                    currentMonthSpendingTransactions[i].transactionCategory,
                transactionSubcategory:
                    currentMonthSpendingTransactions[i].transactionSubcategory,
                transactionSubcategoryIndex: currentMonthSpendingTransactions[i]
                    .transactionSubcategoryIndex,
                transactionNote:
                    currentMonthSpendingTransactions[i].transactionNote,
                transactionPaymentMode:
                    currentMonthSpendingTransactions[i].transactionPaymentMode,
                transactionCreatedAt:
                    currentMonthSpendingTransactions[i].transactionCreatedAt));
        k++;
      } else if (currentMonthSpendingTransactions[i].transactionSubcategory ==
          2) {
        currentMonthSavingTransaction.insert(
            x,
            AllTransactionDetails(
                uId: currentMonthSpendingTransactions[i].uId,
                tID: currentMonthSpendingTransactions[i].tID,
                transactionDate:
                    currentMonthSpendingTransactions[i].transactionDate,
                transactionAmount:
                    currentMonthSpendingTransactions[i].transactionAmount,
                transactionCategory:
                    currentMonthSpendingTransactions[i].transactionCategory,
                transactionSubcategory:
                    currentMonthSpendingTransactions[i].transactionSubcategory,
                transactionSubcategoryIndex: currentMonthSpendingTransactions[i]
                    .transactionSubcategoryIndex,
                transactionNote:
                    currentMonthSpendingTransactions[i].transactionNote,
                transactionPaymentMode:
                    currentMonthSpendingTransactions[i].transactionPaymentMode,
                transactionCreatedAt:
                    currentMonthSpendingTransactions[i].transactionCreatedAt));
        x++;
      } else {}
    }
    getAmountOfPersonalFinance();
  }

  static void getAmountOfPersonalFinance() {
    expenseNeedsOfTheValue = currentMonthNeedsTransaction
        .map((transaction) => transaction.transactionAmount!)
        .fold(0, (sum, amount) => sum! + amount);

    expenseWantsOfTheValue = currentMonthWantsTransaction
        .map((transaction) => transaction.transactionAmount!)
        .fold(0, (sum, amount) => sum! + amount);

    expenseSavingOfTheValue = currentMonthSavingTransaction
        .map((transaction) => transaction.transactionAmount!)
        .fold(0, (sum, amount) => sum! + amount);

    savingProgressValue = (expenseSavingOfTheValue!) / savingOfTheMonthValue!;
    needProgressValue = (expenseNeedsOfTheValue!) / needsOfTheMonthValue!;
    wantProgressValue = (expenseWantsOfTheValue!) / wantsOfTheMonthValue!;

    userScore =
        (savingProgressValue! + needProgressValue! + wantProgressValue!) / 3;
    userScore = (userScore! * 100);
    userScore = 100.00 - userScore!;
    userScore = userScore! < 0 ? 0.00 : userScore!;

    if (userScore! < 0) {
      userScore = 0.00;
    }
    if (userScore! <= 0) {
      pfScore = "Bad";
    } else if (userScore! >= 1 && userScore! <= 60) {
      pfScore = "Good";
    } else if (userScore! >= 61 && userScore! <= 100) {
      pfScore = "Excellent";
    }
  }

  void loadVariableFromSharedPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      needsPercentage =
          sharedPreferences.getInt('needs_percent') ?? needsPercentage;
      wantsPercentage =
          sharedPreferences.getInt('wants_percent') ?? wantsPercentage;
      savingPercentage =
          sharedPreferences.getInt('saving_percent') ?? savingPercentage;
      needsController.text = "$needsOfTheMonthValue";
      wantsController.text = "$wantsOfTheMonthValue";
      savingController.text = "$savingOfTheMonthValue";
    });
  }

  void pfManager(
      int wantsPfManagerValue,
      String wantsPfName,
      int needsPfManagerValue,
      String needsPfName,
      int savingPfManagerValue,
      String savingPfName) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt(wantsPfName, wantsPfManagerValue);
    await sharedPreferences.setInt(needsPfName, needsPfManagerValue);
    await sharedPreferences.setInt(savingPfName, savingPfManagerValue);
  }

  var maskFormatter = MaskTextInputFormatter(
    mask: '##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  Future<UserLogin> getSingleUser(String currentUserID) async {
    final box = await Hive.openBox<UserLogin>('userlogin');
    final users = box.values.firstWhere((user) => user.userId == currentUserID);
    UserData.currentUserId = users.userId;
    UserData.currentUserName = users.userName;
    UserData.currentUserEmail = users.userEmail;
    UserData.currentUserPhone = users.userPhone;
    username = UserData.currentUserName;
    uId = UserData.currentUserId;
    initialOfName = username!.substring(0, 1).toUpperCase();
    return users;
  }

  Future<void> getSingleUserData() async {
    setState(() {
      isLoading = true;
    });
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      UserData.currentUserId = sharedPreferences.getString('userId');
      getSingleUser("${UserData.currentUserId}");
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<LocalTransaction>> getLatestTransactions() async {
    final transactions = await getAllLocalTransactions();
    final currentUserTransactions = transactions.where((transaction) {
      return UserData.currentUserId == transaction.userId;
    }).toList();
    currentUserTransactions.sort((a, b) => b.tDateTime.compareTo(a.tDateTime));
    final latestTransactions = currentUserTransactions.take(4).toList();
    return latestTransactions;
  }

  Future<void> getAllTransaction() async {
    final tempTransactions = getLatestTransactions();
    recentTransaction = await tempTransactions;
    transactions = recentTransaction
        .map((e) => AllTransactionDetails(
            uId: e.userId,
            tID: e.tID,
            transactionDate: Timestamp.fromDate(e.tDateTime),
            transactionAmount: e.tAmount,
            transactionCategory: e.tCategory,
            transactionSubcategory: e.tSubcategory,
            transactionSubcategoryIndex: e.tSubcategoryIndex,
            transactionNote: e.tNote,
            transactionPaymentMode: e.tPaymentMode,
            transactionCreatedAt: Timestamp.fromDate(e.tCreatedAt)))
        .toList();
  }

  Future<List<LocalTransaction>> getTransactionsThisMonth() async {
    final transactions = await getAllLocalTransactions();
    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;
    final transactionsThisMonth = transactions.where((transaction) {
      final transactionDate = transaction.tDateTime;
      return transactionDate.month == currentMonth &&
          transactionDate.year == currentYear &&
          UserData.currentUserId == transaction.userId;
    }).toList();
    transactionsThisMonth.sort((a, b) => b.tDateTime.compareTo(a.tDateTime));
    return transactionsThisMonth;
  }
}
