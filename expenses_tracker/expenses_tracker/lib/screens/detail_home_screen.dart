import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_tracker/screens/pf_screen.dart';
import 'package:expenses_tracker/screens/transaction_screen.dart';
import 'package:expenses_tracker/screens/transactions_of_month.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../model/localtransaction.dart';
import '../model/localuser.dart';
import '../model/transaction.dart';
import '../model/users.dart';
import '../utils/const.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import '../utils/functions.dart';
import '../widgets/build_skeleton.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_header.dart';
import '../widgets/custom_no_data.dart';
import '../widgets/custom_pf_row.dart';
import '../widgets/custom_text_style.dart';
import '../widgets/custom_transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/fade_transition.dart';
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
  final personalFinanceGlobalKey = GlobalKey<FormState>();

  bool isLoading = false;

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

  static bool? balanceHintText = false;

  List<Users> listOfUsers = [];
  Color iconColor = PrimaryColor.colorBottleGreen;
  static String? username, initialOfName;

  static List<AllTransactionDetails> currentMonthTransactions = [];
  static List<AllTransactionDetails> currentMonthIncomeTransactions = [];
  static List<AllTransactionDetails> currentMonthSpendingTransactions = [];
  static List<AllTransactionDetails> currentMonthNeedsTransaction = [];
  static List<AllTransactionDetails> currentMonthWantsTransaction = [];
  static List<AllTransactionDetails> currentMonthSavingTransaction = [];

  static List<AllTransactionDetails> previousTransactionsList = [];
  static List<AllTransactionDetails> previousMonthIncomeTransactions = [];
  static List<AllTransactionDetails> previousMonthSpendingTransactions = [];
  static List<AllTransactionDetails> previousMonthNeedsTransaction = [];
  static List<AllTransactionDetails> previousMonthWantsTransaction = [];
  static List<AllTransactionDetails> previousMonthSavingTransaction = [];

  static List<LocalTransaction> recentTransaction = [];
  static List<LocalTransaction> beforeMonthTransactionsList = [];

  static List<int> incomeOfTheMonthPf = [];
  static List<int> incomdeBeforeMonthPf = [];

  static int? incomeOfTheMonthValue = 00;
  static int? incomeForPersonalFinance = 00;
  static int? spendingOfTheMonthValue = 00;
  static int? balanceOfTheMonthValue = 00;
  static int? balanceOfTheMonthPfValue = 00;

  static int? incomeBeforeMonth = 00;
  static int? incomeForBeforeMonthPersonalFinance = 00;
  static int? spendingBeforeMonth = 00;
  static int? balanceBeforeMonth = 00;
  static int? balanceBeforeMonthPfValue = 00;

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
    getBalanceBeforeMonth();
    getBalanceOfMonth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: isLoading == true
          ? const HomeSkeleton()
          : SingleChildScrollView(
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
                            Navigator.of(context).push(
                              FadeSlideTransitionRouteForList(
                                  page: TransactionOfMonth(
                                id: 3,
                                amount: spendingOfTheMonthValue!,
                              )),
                            );
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
                            Navigator.of(context).push(
                              FadeSlideTransitionRouteForList(
                                  page: TransactionOfMonth(
                                id: 2,
                                amount: incomeOfTheMonthValue!,
                              )),
                            );
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
                    Center(
                      child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.60,
                          child: Card(
                            color: Theme.of(context).cardColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: PrimaryColor.colorWhite),
                            ),
                            child: Center(
                                child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    child: Text(
                                      balanceOfTheMonthValue! > 0
                                          ? "Balance: ₹$balanceOfTheMonthValue"
                                          : "Balance: -₹${balanceOfTheMonthValue!.abs()}",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontWeight: FontWeight.normal,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              25),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        balanceHintText = !balanceHintText!;
                                      });
                                    },
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02,
                                      child: Icon(Icons.info_outline_rounded,
                                          color: Theme.of(context).hintColor,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.025),
                                    ),
                                  )
                                ],
                              ),
                            )),
                          )),
                    ),
                    balanceHintText == false
                        ? const SizedBox.shrink()
                        : Center(
                            child: Text(
                            "Balance: Remaining balance of Previous months + current month balance",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.012),
                          )),
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
                              personalFinanceDialog(screenHeight, screenWidth);
                            },
                            child: CustomTextStyle(
                                customTextStyleText: "Set Manually",
                                customTextColor: Colors.blueAccent,
                                customTextFontWeight: FontWeight.w400,
                                customtextstyle: null,
                                customTextSize: 14),
                          ),
                        ],
                      ),
                    ),
                    buildCustomPersonalFinance(screenHeight, screenWidth),
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
                              Navigator.of(context).push(
                                FadeSlideTransitionRouteForList(
                                    page: TransactionOfMonth(
                                  id: 1,
                                  amount: balanceOfTheMonthValue!,
                                )),
                              );
                            },
                            child: CustomTextStyle(
                                customTextStyleText: "View all",
                                customTextColor: Colors.blueAccent,
                                customTextFontWeight: FontWeight.w400,
                                customtextstyle: null,
                                customTextSize: 14),
                          ),
                        ],
                      ),
                    ),
                    buildRecentTransactionList(screenHeight, screenWidth)
                  ]),
            ),
    );
  }

  Widget buildRecentTransactionList(double screenHeight, double screenWidth) {
    return Container(
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
                if (transactions[index].transactionCategory == 0) {
                  iconColor = PrimaryColor.colorBottleGreen;
                }
                if (transactions[index].transactionCategory == 1) {
                  iconColor = PrimaryColor.colorRed;
                }
                if (transactions[index].transactionCategory == 2) {
                  iconColor = PrimaryColor.colorBottleGreen;
                }
                return transactions.isEmpty
                    ? const Center(child: CustomNoData())
                    : GestureDetector(
                        onTap: () {
                          // TransactionScreen(
                          //               id: 2,
                          //               transactionPaymentMode:
                          //                   transactions[index]
                          //                       .transactionPaymentMode,
                          //               transactionId: transactions[index].tID,
                          //               transactionNote:
                          //                   transactions[index].transactionNote,
                          //               transactionAmount: transactions[index]
                          //                   .transactionAmount,
                          //               transactionSubcategoryIndex:
                          //                   transactions[index]
                          //                       .transactionSubcategoryIndex,
                          //               transactionDate:
                          //                   "${DateFormat.yMMMd().format(transactions[index].transactionDate!.toDate())} ${DateFormat.jm().format(transactions[index].transactionDate!.toDate())}",
                          //               transactionSubcategory:
                          //                   transactions[index]
                          //                       .transactionSubcategory,
                          //               transactionCategory: transactions[index]
                          //                   .transactionCategory,
                          //             );
                          Navigator.of(context).push(
                            FadeSlideTransitionRoute(
                                page: TransactionScreen(
                              id: 2,
                              transactionPaymentMode:
                                  transactions[index].transactionPaymentMode,
                              transactionId: transactions[index].tID,
                              transactionNote:
                                  transactions[index].transactionNote,
                              transactionAmount:
                                  transactions[index].transactionAmount,
                              transactionSubcategoryIndex: transactions[index]
                                  .transactionSubcategoryIndex,
                              transactionDate:
                                  "${DateFormat.yMMMd().format(transactions[index].transactionDate!.toDate())} ${DateFormat.jm().format(transactions[index].transactionDate!.toDate())}",
                              transactionSubcategory:
                                  transactions[index].transactionSubcategory,
                              transactionCategory:
                                  transactions[index].transactionCategory,
                            )),
                          );
                        },
                        child: CustomTransaction(
                            themeColor: Theme.of(context).cardColor,
                            textTheme: Theme.of(context).colorScheme.secondary,
                            iconColor: iconColor,
                            categoryId: transactions[index].transactionCategory,
                            subCateId:
                                transactions[index].transactionSubcategoryIndex,
                            transactionAmount:
                                transactions[index].transactionAmount,
                            transactionNote:
                                transactions[index].transactionNote,
                            dateStamp: DateFormat.yMMMd().format(
                                transactions[index].transactionDate!.toDate()),
                            timeStamp: DateFormat.jm().format(
                                transactions[index]
                                    .transactionDate!
                                    .toDate())));
              }),
    );
  }

  Widget buildCustomPersonalFinance(double screenHeight, double screenWidth) {
    return SizedBox(
      height: screenHeight * 0.43,
      width: screenWidth,
      child: Card(
        elevation: 5,
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: incomeForPersonalFinance! <= 0
            ? const Center(
                child: CustomNoData(),
              )
            : Column(
                children: [
                  const SizedBox(
                    height: 07,
                  ),
                  Row(
                    children: [
                      SizedBox(
                          width: screenWidth / 2.201,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Amount Left",
                                style: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: screenHeight * 0.016,
                                ),
                              ),
                              Text(
                                formatCurrencyForBalance(
                                    balanceOfTheMonthPfValue),
                                style: TextStyle(
                                  color: pfScore == 'Excellent'
                                      ? PrimaryColor.colorBottleGreen
                                      : pfScore == 'Good'
                                          ? PrimaryColor.colorBlue
                                          : PrimaryColor.colorRed,
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenHeight * 0.022,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                              ),
                            ],
                          )),
                      SizedBox(
                          width: screenWidth / 2.201,
                          child: Column(children: [
                            Text(
                              'Performance',
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontWeight: FontWeight.w400,
                                fontSize: screenHeight * 0.016,
                              ),
                            ),
                            Text(
                              '$pfScore',
                              style: TextStyle(
                                color: pfScore == 'Excellent'
                                    ? PrimaryColor.colorBottleGreen
                                    : pfScore == 'Good'
                                        ? PrimaryColor.colorBlue
                                        : PrimaryColor.colorRed,
                                fontWeight: FontWeight.w500,
                                fontSize: screenHeight * 0.022,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                            ),
                          ]))
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        width: screenWidth / 4,
                        height: screenHeight / 10,
                        child: SleekCircularSlider(
                          appearance: CircularSliderAppearance(
                            startAngle: 0,
                            angleRange: 360,
                            customColors: CustomSliderColors(
                              trackColor: Theme.of(context).hintColor,
                              progressBarColor: PrimaryColor.colorBottleGreen,
                              dotColor: PrimaryColor.colorBottleGreen,
                            ),
                            customWidths: CustomSliderWidths(
                              trackWidth: 1.5,
                              progressBarWidth: 2.5,
                              handlerSize: 4,
                            ),
                            infoProperties: InfoProperties(
                              modifier: (double value) {
                                final roundedValue =
                                    value.ceil().toInt().toString();
                                return '$roundedValue%';
                              },
                              mainLabelStyle: TextStyle(
                                  fontSize: 13.0,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: screenWidth / 1.7,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Needs',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: screenHeight / 45),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                            width: screenWidth / 1.7,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              '${formatCurrency(expenseNeedsOfTheValue)} / ${formatCurrency(needsOfTheMonthValue)}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: screenHeight / 55,
                              ),
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              FadeSlideTransitionRoute(
                                  page: PfScreen(
                                id: 0,
                                transactions: currentMonthNeedsTransaction,
                              )),
                            );
                          },
                          child: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Theme.of(context).colorScheme.secondary,
                            size: screenWidth / 20,
                          )),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(color: Colors.grey[400]),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        width: screenWidth / 4,
                        height: screenHeight / 10,
                        child: SleekCircularSlider(
                          appearance: CircularSliderAppearance(
                            startAngle: 0,
                            angleRange: 360,
                            customColors: CustomSliderColors(
                              trackColor: Theme.of(context).hintColor,
                              progressBarColor: PrimaryColor.colorRed,
                              dotColor: PrimaryColor.colorRed,
                            ),
                            customWidths: CustomSliderWidths(
                              trackWidth: 1.5,
                              progressBarWidth: 2.5,
                              handlerSize: 4,
                            ),
                            infoProperties: InfoProperties(
                              modifier: (double value) {
                                final roundedValue =
                                    value.ceil().toInt().toString();
                                return '$roundedValue%';
                              },
                              mainLabelStyle: TextStyle(
                                  fontSize: 13.0,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: screenWidth / 1.7,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Wants',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: screenHeight / 45),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                            width: screenWidth / 1.7,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              '${formatCurrency(expenseWantsOfTheValue)} / ${formatCurrency(wantsOfTheMonthValue)}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: screenHeight / 55,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              FadeSlideTransitionRoute(
                                  page: PfScreen(
                                id: 1,
                                transactions: currentMonthWantsTransaction,
                              )),
                            );
                          },
                          child: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Theme.of(context).colorScheme.secondary,
                            size: screenWidth / 20,
                          )),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(color: Colors.grey[400]),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        width: screenWidth / 4,
                        height: screenHeight / 10,
                        child: SleekCircularSlider(
                          appearance: CircularSliderAppearance(
                            startAngle: 0,
                            angleRange: 360,
                            customColors: CustomSliderColors(
                              trackColor: Theme.of(context).hintColor,
                              progressBarColor: PrimaryColor.colorBlue,
                              dotColor: PrimaryColor.colorBlue,
                            ),
                            customWidths: CustomSliderWidths(
                              trackWidth: 1.5,
                              progressBarWidth: 2.5,
                              handlerSize: 4,
                            ),
                            infoProperties: InfoProperties(
                              modifier: (double value) {
                                final roundedValue =
                                    value.ceil().toInt().toString();
                                return '$roundedValue%';
                              },
                              mainLabelStyle: TextStyle(
                                  fontSize: 13.0,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: screenWidth / 1.7,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Saving',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: screenHeight / 45),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                            width: screenWidth / 1.7,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              '${formatCurrency(expenseSavingOfTheValue)} / ${formatCurrency(savingOfTheMonthValue)}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: screenHeight / 55,
                              ),
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              FadeSlideTransitionRoute(
                                  page: PfScreen(
                                id: 2,
                                transactions: currentMonthSavingTransaction,
                              )),
                            );
                          },
                          child: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Theme.of(context).colorScheme.secondary,
                            size: screenWidth / 20,
                          )),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  void scheduleWeeklyNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'high_importance_channel',
        title: 'Vyaya App',
        body: 'Check your Expenses of the Week!',
        notificationLayout: NotificationLayout.BigText,
      ),
      schedule: NotificationCalendar(
          weekday: DateTime.monday,
          hour: 9,
          minute: 0,
          second: 0,
          millisecond: 0,
          repeats: true),
    );
  }

  void scheduleNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 2,
        channelKey: 'high_importance_channel',
        title: 'Vyaya App',
        body: "Don't forget to enter your daily Expenses!",
        notificationLayout: NotificationLayout.BigText,
      ),
      schedule: NotificationCalendar(
          hour: 21, minute: 0, second: 0, millisecond: 0, repeats: true),
    );
  }

  Future<void> getBalanceBeforeMonth() async {
    previousTransactionsList.clear();
    previousMonthIncomeTransactions.clear();
    previousMonthSpendingTransactions.clear();
    previousMonthNeedsTransaction.clear();
    previousMonthWantsTransaction.clear();
    previousMonthSavingTransaction.clear();

    incomeBeforeMonth = 00;
    spendingBeforeMonth = 00;
    balanceBeforeMonth = 00;

    setState(() {
      isLoading = true;
    });
    try {
      final beforeTimeTransactionData = getBeforeMonthTransaction();
      beforeMonthTransactionsList = await beforeTimeTransactionData;

      setState(() {
        previousTransactionsList = beforeMonthTransactionsList
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
        findIncomeSpendingBeforeMonth();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }

    balanceBeforeMonth = (incomeBeforeMonth! - spendingBeforeMonth!);
  }

  Future<void> getBalanceOfMonth() async {
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

  static void findIncomeSpendingBeforeMonth() {
    for (int i = 0, j = 0, k = 0; i < previousTransactionsList.length; i++) {
      if (previousTransactionsList[i].transactionCategory == 0 ||
          previousTransactionsList[i].transactionCategory == 3) {
        if (previousTransactionsList[i].transactionCategory == 0) {
          incomeBeforeMonth = (incomeBeforeMonth! +
              previousTransactionsList[i].transactionAmount!);
        } else {
          incomeBeforeMonth = (incomeBeforeMonth! +
              previousTransactionsList[i].transactionAmount!);
          previousMonthIncomeTransactions.insert(
              j,
              AllTransactionDetails(
                  uId: previousTransactionsList[i].uId,
                  tID: previousTransactionsList[i].tID,
                  transactionDate: previousTransactionsList[i].transactionDate,
                  transactionAmount:
                      previousTransactionsList[i].transactionAmount,
                  transactionCategory:
                      previousTransactionsList[i].transactionCategory,
                  transactionSubcategory:
                      previousTransactionsList[i].transactionSubcategory,
                  transactionSubcategoryIndex:
                      previousTransactionsList[i].transactionSubcategoryIndex,
                  transactionNote: previousTransactionsList[i].transactionNote,
                  transactionPaymentMode:
                      previousTransactionsList[i].transactionPaymentMode,
                  transactionCreatedAt:
                      previousTransactionsList[i].transactionCreatedAt));
          j++;
        }
      } else if (previousTransactionsList[i].transactionCategory == 1) {
        spendingBeforeMonth = (spendingBeforeMonth! +
            previousTransactionsList[i].transactionAmount!);

        previousMonthSpendingTransactions.insert(
            k,
            AllTransactionDetails(
                uId: previousTransactionsList[i].uId,
                tID: previousTransactionsList[i].tID,
                transactionDate: previousTransactionsList[i].transactionDate,
                transactionAmount:
                    previousTransactionsList[i].transactionAmount,
                transactionCategory:
                    previousTransactionsList[i].transactionCategory,
                transactionSubcategory:
                    previousTransactionsList[i].transactionSubcategory,
                transactionSubcategoryIndex:
                    previousTransactionsList[i].transactionSubcategoryIndex,
                transactionNote: previousTransactionsList[i].transactionNote,
                transactionPaymentMode:
                    previousTransactionsList[i].transactionPaymentMode,
                transactionCreatedAt:
                    previousTransactionsList[i].transactionCreatedAt));
        k++;
      }
    }
  }

  static void findIncomeSpending() {
    for (int i = 0, j = 0, k = 0; i < currentMonthTransactions.length; i++) {
      if (currentMonthTransactions[i].transactionCategory == 0 ||
          currentMonthTransactions[i].transactionCategory == 3) {
        if (currentMonthTransactions[i].transactionCategory == 0) {
          incomeOfTheMonthValue = (incomeOfTheMonthValue! +
              currentMonthTransactions[i].transactionAmount!);
        } else {
          incomeOfTheMonthValue = (incomeOfTheMonthValue! +
              currentMonthTransactions[i].transactionAmount!);
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
        spendingOfTheMonthValue = (spendingOfTheMonthValue! +
            currentMonthTransactions[i].transactionAmount!);

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
    getBalance();
  }

  static void totalIncomeOfTheMonth() {
    for (int i = 0; i < incomeOfTheMonthPf.length; i++) {
      incomeForPersonalFinance =
          incomeOfTheMonthPf[i] + incomeForPersonalFinance!;
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
        (incomeOfTheMonthValue! - spendingOfTheMonthValue!) +
            balanceBeforeMonth!;

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

  Future<LocalUser> getSingleUser(String currentUserID) async {
    final box = await Hive.openBox<LocalUser>('local_user');
    final users = box.values.firstWhere((user) => user.userId == currentUserID);
    UserData.currentUserId = users.userId;
    UserData.currentUserName = users.userName;
    UserData.currentUserEmail = users.userEmail;
    username = UserData.currentUserName;
    uId = UserData.currentUserId;
    initialOfName = username!.substring(0, 1).toUpperCase();
    return users;
  }

  void personalFinanceDialog(double screenHeight, double screenWidth) {
    needsController.text = needsPercentage.toString();
    wantsController.text = wantsPercentage.toString();
    savingController.text = savingPercentage.toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        int needs = int.tryParse(needsController.text) ?? 0;
        int wants = int.tryParse(wantsController.text) ?? 0;
        int saving = int.tryParse(savingController.text) ?? 0;
        int? finalTotal = needs + wants + saving;
        return AlertDialog(
          scrollable: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Theme.of(context).colorScheme.secondary),
            borderRadius: BorderRadius.circular(8),
          ),
          title: CustomTextStyle(
            customTextStyleText: "Set Personal Finance",
            customTextColor: Theme.of(context).colorScheme.secondary,
            customTextFontWeight: FontWeight.normal,
            customtextstyle: null,
            customTextSize: screenHeight * 0.022,
          ),
          content: SizedBox(
            height: screenHeight * 1 / 3,
            child: SingleChildScrollView(
              child: Form(
                autovalidateMode: AutovalidateMode.always,
                key: personalFinanceGlobalKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Important',
                      style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.left,
                    ),
                    Row(
                      children: [
                        Text(
                          '• ',
                          style: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.015),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          "Values can't be zero.",
                          style: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontWeight: FontWeight.w400,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.015),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '• ',
                          style: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.015),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          'Values counted as Percentage.',
                          style: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontWeight: FontWeight.w400,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.015),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '• ',
                          style: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.015),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          'Total of all Three Values must be 100.',
                          style: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontWeight: FontWeight.w400,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.015),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomPfRow(
                      labelText: "Needs",
                      hintText: "Set Needs Percentage",
                      textEditingController: needsController,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomPfRow(
                      labelText: "Wants",
                      hintText: "Set Wants Percentage",
                      textEditingController: wantsController,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomPfRow(
                      labelText: "Saving",
                      hintText: "Set Saving Percentage",
                      textEditingController: savingController,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(
                      height: 07,
                    ),
                    finalTotal == 100
                        ? const Text('')
                        : Row(
                            children: [
                              Text(
                                "Please Enter possible values",
                                style: TextStyle(color: PrimaryColor.colorRed),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: PrimaryColor.colorRed),
              ),
            ),
            const SizedBox(
              width: 07,
            ),
            GestureDetector(
              onTap: () {
                int needsValue = int.tryParse(needsController.text) ?? 0;
                int wantsValue = int.tryParse(wantsController.text) ?? 0;
                int savingValue = int.tryParse(savingController.text) ?? 0;
                finalTotal = needsValue + wantsValue + savingValue;

                if (finalTotal == 100) {
                  pfManager(
                    wantsValue,
                    "wants_percent",
                    needsValue,
                    "needs_percent",
                    savingValue,
                    "saving_percent",
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                } else {}
              },
              child: Text(
                "Save",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
          ],
        );
      },
    );
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

  Future<List<LocalTransaction>> getBeforeMonthTransaction() async {
    final transactions = await getAllLocalTransactions();
    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;

    final previousTimeTransactions = transactions.where((transaction) {
      final transactionDate = transaction.tDateTime;
      return transactionDate.isBefore(DateTime(currentYear, currentMonth, 1)) &&
          UserData.currentUserId == transaction.userId;
    }).toList();
    previousTimeTransactions.sort((a, b) => b.tDateTime.compareTo(a.tDateTime));
    return previousTimeTransactions;
  }

  Future<List<LocalTransaction>> getTransactionsThisMonth() async {
    final transactions = await getAllLocalTransactions();
    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;

    final previousTimeTransactions = transactions.where((transaction) {
      final transactionDate = transaction.tDateTime;
      return transactionDate.isBefore(DateTime(currentYear, currentMonth, 1)) &&
          UserData.currentUserId == transaction.userId;
    }).toList();

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
