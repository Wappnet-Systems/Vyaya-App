import 'dart:io';
// import 'dart:developer';
import 'package:expenses_tracker/screens/file_view.dart';
import 'package:expenses_tracker/screens/transactions_of_month.dart';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../api/pdf_transaction_api.dart';
import '../model/localtransaction.dart';
import '../model/transaction.dart';
import '../utils/const.dart';
import '../utils/functions.dart';
import '../widgets/custom_balance_card.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_circular_chart.dart';
import '../widgets/fade_transition.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int value = 0;
  DateTime? startDate;
  DateTime? endDate;
  String? uid;

  DateTime? analyticsYearly = DateTime.now();
  DateTime? analyticsMonthly = DateTime.now();
  DateTime? analyticsWeekly = DateTime.now();

  String? analyticsMonthlyText;
  String? analyticsStartWeekText;
  String? analyticsYearlyText;

  static List<LocalTransaction> recentTransaction = [];
  static List<AllTransactionDetails> currentPageTransactions = [];

  static List<AllTransactionDetails> currentPageIncomeTransactions = [];
  static List<AllTransactionDetails> currentPageSpendingTransactions = [];

  static List<int> incomeOfTheCurrentPageTransactions = [];
  static List<int> spendingOfTheCurrentPageTransactions = [];

  static int? incomeOfTheCurrentPageTransactionsValue = 00;
  static double? averageIncome = 00;
  static double? averageSpending = 00;
  static int? spendingOfCurrentPageTransactionsValue = 00;
  static int? balanceOfCurrentPageTransactionsValue = 00;

  @override
  void initState() {
    super.initState();
    uid = UserData.currentUserId;
    analyticsMonthlyText = DateFormat.yMMM().format(analyticsMonthly!);
    analyticsYearlyText = DateFormat.y().format(analyticsYearly!);
    getWeekDates();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      value = 0;
                      getWeekDates();
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    side: BorderSide(
                        color: (value == 0)
                            ? PrimaryColor.colorBottleGreen
                            : Theme.of(context).colorScheme.secondary),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 1.0, vertical: 3.0),
                    child: Text("Weekly\nAnalysis",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 15.0,
                              color: value == 0
                                  ? PrimaryColor.colorBottleGreen
                                  : Theme.of(context).colorScheme.secondary,
                            )),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      value = 1;
                      getCurrentMonth();
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    side: BorderSide(
                        color: (value == 1)
                            ? PrimaryColor.colorBottleGreen
                            : Theme.of(context).colorScheme.secondary),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 1.0, vertical: 3.0),
                    child: Text("Monthly\nAnalysis",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 15.0,
                              color: value == 1
                                  ? PrimaryColor.colorBottleGreen
                                  : Theme.of(context).colorScheme.secondary,
                            )),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      value = 2;
                      getCurrentYear();
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    side: BorderSide(
                        color: (value == 2)
                            ? PrimaryColor.colorBottleGreen
                            : Theme.of(context).colorScheme.secondary),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 1.0, vertical: 3.0),
                    child: Text("Yearly\nAnalysis",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 15.0,
                              color: value == 2
                                  ? PrimaryColor.colorBottleGreen
                                  : Theme.of(context).colorScheme.secondary,
                            )),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      value == 0
                          ? updateWeek(0)
                          : value == 1
                              ? updateMonth(0)
                              : updateYear(0);
                    });
                  },
                  icon: Icon(
                    Icons.chevron_left,
                    size: MediaQuery.of(context).size.height * 0.05,
                  ),
                  color: PrimaryColor.colorBottleGreen,
                ),
                value == 0
                    ? Text("$analyticsStartWeekText",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                                color: Theme.of(context).colorScheme.secondary))
                    : Container(
                        child: value == 1
                            ? Text("$analyticsMonthlyText",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary))
                            : Text("$analyticsYearlyText",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary))),
                IconButton(
                  onPressed: () {
                    setState(() {
                      value == 0
                          ? updateWeek(1)
                          : value == 1
                              ? updateMonth(1)
                              : updateYear(1);
                    });
                  },
                  icon: Icon(
                    Icons.chevron_right,
                    size: MediaQuery.of(context).size.height * 0.05,
                  ),
                  color: PrimaryColor.colorBottleGreen,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      FadeSlideTransitionRouteForList(
                          page: TransactionOfMonth(
                        id: 4,
                        titleText: value == 0
                            ? 'Weekly Expenses Analysis'
                            : value == 1
                                ? "Monthly Expenses Analysis"
                                : "Yearly Expenses Analysis",
                        amount: incomeOfTheCurrentPageTransactionsValue!,
                        subtitleText: value == 0
                            ? '$analyticsStartWeekText'
                            : value == 1
                                ? "$analyticsMonthlyText"
                                : "$analyticsYearlyText",
                        currentPageTransaction: currentPageSpendingTransactions,
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
                      speOrIncMonthValue:
                          spendingOfCurrentPageTransactionsValue,
                      title: "Spending"),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      FadeSlideTransitionRouteForList(
                          page: TransactionOfMonth(
                        id: 5,
                        titleText: value == 0
                            ? 'Weekly Income Analysis'
                            : value == 1
                                ? "Monthly Income Analysis"
                                : "Yearly Income Analysis",
                        amount: incomeOfTheCurrentPageTransactionsValue!,
                        subtitleText: value == 0
                            ? '$analyticsStartWeekText'
                            : value == 1
                                ? "$analyticsMonthlyText"
                                : "$analyticsYearlyText",
                        currentPageTransaction: currentPageIncomeTransactions,
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
                      speOrIncMonthValue:
                          incomeOfTheCurrentPageTransactionsValue,
                      title: "Income"),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            CustomBalanceCard(
                balanceOfTheMonthValue: balanceOfCurrentPageTransactionsValue!,
                themeColor: Theme.of(context).cardColor,
                textThemeColor: Theme.of(context).colorScheme.secondary),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Text('Category-wise Spending',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(
                              color: Theme.of(context).colorScheme.secondary)),
                ],
              ),
            ),
            CustomCircularChart(
              currentPageTransactions: currentPageSpendingTransactions,
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Text('Category-wise Income',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(
                              color: Theme.of(context).colorScheme.secondary)),
                ],
              ),
            ),
            CustomCircularChart(
              currentPageTransactions: currentPageIncomeTransactions,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('Stats',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(
                              color: Theme.of(context).colorScheme.secondary)),
                ),
              ],
            ),
            Card(
                color: Theme.of(context).cardColor,
                elevation: 5,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("Total Number\nof Transaction",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                      color: Theme.of(context).hintColor,
                                    )),
                            const SizedBox(
                              height: 12,
                            ),
                            Text("${currentPageTransactions.length}",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 22.0,
                                      color: PrimaryColor.colorBlue,
                                    ))
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width: screenWidth / 2.201,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Number of\nIncome Transactions",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        color: Theme.of(context).hintColor,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                averageIncome!.isNaN
                                    ? Text("₹0.0",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge!
                                            .copyWith(
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  PrimaryColor.colorBottleGreen,
                                            ))
                                    : Text(
                                        "${incomeOfTheCurrentPageTransactions.length}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge!
                                            .copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 22.0,
                                              color:
                                                  PrimaryColor.colorBottleGreen,
                                            ))
                              ],
                            )),
                        SizedBox(
                            width: screenWidth / 2.20,
                            child: Column(children: [
                              Text(
                                "Number of\nSpending Transactions",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                      color: Theme.of(context).hintColor,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              averageSpending!.isNaN
                                  ? Text("0",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge!
                                          .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 22.0,
                                            color: PrimaryColor.colorRed,
                                          ))
                                  : Text(
                                      "${spendingOfTheCurrentPageTransactions.length}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge!
                                          .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 22.0,
                                            color: PrimaryColor.colorRed,
                                          )),
                            ]))
                      ],
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width: screenWidth / 2.201,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("Average Income",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                          color: Theme.of(context).hintColor,
                                        )),
                                const SizedBox(
                                  height: 12,
                                ),
                                averageIncome!.isNaN
                                    ? Text("₹0.0",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge!
                                            .copyWith(
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  PrimaryColor.colorBottleGreen,
                                            ))
                                    : Text("₹$averageIncome",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge!
                                            .copyWith(
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  PrimaryColor.colorBottleGreen,
                                            ))
                              ],
                            )),
                        SizedBox(
                            width: screenWidth / 2.201,
                            child: Column(children: [
                              Text('Average Spending',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        color: Theme.of(context).hintColor,
                                      )),
                              const SizedBox(
                                height: 12,
                              ),
                              averageSpending!.isNaN
                                  ? Text("₹0.0",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge!
                                          .copyWith(
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w500,
                                            color: PrimaryColor.colorRed,
                                          ))
                                  : Text("₹$averageSpending",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge!
                                          .copyWith(
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w500,
                                            color: PrimaryColor.colorRed,
                                          )),
                            ]))
                      ],
                    ),
                  ]),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () async {
                    if (currentPageTransactions.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.warning, color: Colors.orange),
                            const SizedBox(width: 05),
                            Text(
                              'No Transactions between this time duration',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(color: Colors.orange),
                            ),
                          ],
                        ),
                      ));
                    } else {
                      // log("File Saved");
                      final File pdfFile;
                      String? pdfFileName;
                      value ==0 ?pdfFileName= "Weekly Analysis" :value == 1 ?pdfFileName= "Monthly Analysis" : pdfFileName="Yearly Analysis";
                      value == 0
                          ? pdfFile = await PdfInvoiceApi.generate(
                              currentPageTransactions,
                              analyticsStartWeekText!,
                              "Weekly Analysis",
                              incomeOfTheCurrentPageTransactionsValue!,
                              spendingOfCurrentPageTransactionsValue!,
                              balanceOfCurrentPageTransactionsValue!)
                          : value == 1
                              ? pdfFile = await PdfInvoiceApi.generate(
                                  currentPageTransactions,
                                  analyticsMonthlyText!,
                                  "Monthly Analysis",
                                  incomeOfTheCurrentPageTransactionsValue!,
                                  spendingOfCurrentPageTransactionsValue!,
                                  balanceOfCurrentPageTransactionsValue!)
                              : pdfFile = await PdfInvoiceApi.generate(
                                  currentPageTransactions,
                                  analyticsYearlyText!,
                                  "Yearly Analysis",
                                  incomeOfTheCurrentPageTransactionsValue!,
                                  spendingOfCurrentPageTransactionsValue!,
                                  balanceOfCurrentPageTransactionsValue!);
                      inAppPdfView(pdfFile.path,pdfFileName);
                      // PdfApi.openFile(pdfFile);
                    }
                  },
                  child: Card(
                    color: PrimaryColor.colorBottleGreen,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.file_download,
                            color: PrimaryColor.colorWhite,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Download stats',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                  color: PrimaryColor.colorWhite,
                                ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  inAppPdfView(String path, String selectedPdfName) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FileViewWidget(
                  path: path,
                  filename: selectedPdfName,
                )));
  }

  Future<List<LocalTransaction>> getAllLocalTransactions() async {
    final box = await Hive.openBox<LocalTransaction>('local_transactions');
    final transactions = box.values.toList();
    return transactions;
  }

  Future<List<LocalTransaction>> getTransactionsBetweenDates() async {
    startDate = DateTime(startDate!.year, startDate!.month, startDate!.day);
    endDate = DateTime(endDate!.year, endDate!.month, endDate!.day, 23, 59, 59);
    final transactions = await getAllLocalTransactions();

    final filteredTransactions = transactions
        .where((transaction) =>
            transaction.tDateTime.isAfter(startDate!) &&
            transaction.tDateTime.isBefore(endDate!) &&
            UserData.currentUserId == transaction.userId)
        .toList();

    filteredTransactions.sort((a, b) => a.tDateTime.compareTo(b.tDateTime));
    return filteredTransactions;
  }

  Future<void> getAllTransaction() async {
    currentPageIncomeTransactions.clear();
    currentPageSpendingTransactions.clear();
    incomeOfTheCurrentPageTransactions.clear();
    spendingOfTheCurrentPageTransactions.clear();
    incomeOfTheCurrentPageTransactionsValue = 00;
    spendingOfCurrentPageTransactionsValue = 00;
    balanceOfCurrentPageTransactionsValue = 00;
    averageIncome = 00;
    averageSpending = 00;

    try {
      recentTransaction = await getTransactionsBetweenDates();
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
            .toList();
        findIncomeSpending();
      });
      // ignore: empty_catches
    } catch (e) {}
  }

  static void findIncomeSpending() {
    for (int i = 0, j = 0, k = 0; i < currentPageTransactions.length; i++) {
      if (currentPageTransactions[i].transactionCategory == 0 ||
          currentPageTransactions[i].transactionCategory == 3) {
        incomeOfTheCurrentPageTransactions
            .add(currentPageTransactions[i].transactionAmount!);
        currentPageIncomeTransactions.insert(
            j,
            AllTransactionDetails(
                uId: currentPageTransactions[i].uId,
                tID: currentPageTransactions[i].tID,
                transactionDate: currentPageTransactions[i].transactionDate,
                transactionAmount: currentPageTransactions[i].transactionAmount,
                transactionCategory:
                    currentPageTransactions[i].transactionCategory,
                transactionSubcategory:
                    currentPageTransactions[i].transactionSubcategory,
                transactionSubcategoryIndex:
                    currentPageTransactions[i].transactionSubcategoryIndex,
                transactionNote: currentPageTransactions[i].transactionNote,
                transactionPaymentMode:
                    currentPageTransactions[i].transactionPaymentMode,
                transactionCreatedAt:
                    currentPageTransactions[i].transactionCreatedAt));
        j++;
      } else if (currentPageTransactions[i].transactionCategory == 1) {
        spendingOfTheCurrentPageTransactions
            .add(currentPageTransactions[i].transactionAmount!);
        currentPageSpendingTransactions.insert(
            k,
            AllTransactionDetails(
                uId: currentPageTransactions[i].uId,
                tID: currentPageTransactions[i].tID,
                transactionDate: currentPageTransactions[i].transactionDate,
                transactionAmount: currentPageTransactions[i].transactionAmount,
                transactionCategory:
                    currentPageTransactions[i].transactionCategory,
                transactionSubcategory:
                    currentPageTransactions[i].transactionSubcategory,
                transactionSubcategoryIndex:
                    currentPageTransactions[i].transactionSubcategoryIndex,
                transactionNote: currentPageTransactions[i].transactionNote,
                transactionPaymentMode:
                    currentPageTransactions[i].transactionPaymentMode,
                transactionCreatedAt:
                    currentPageTransactions[i].transactionCreatedAt));
        k++;
      }
    }
    totalIncomeOfTheMonth();
    totalExpensesOfTheMonth();
    getBalance();
  }

  static void totalIncomeOfTheMonth() {
    for (int i = 0; i < incomeOfTheCurrentPageTransactions.length; i++) {
      incomeOfTheCurrentPageTransactionsValue =
          incomeOfTheCurrentPageTransactions[i] +
              incomeOfTheCurrentPageTransactionsValue!;
    }
  }

  static void totalExpensesOfTheMonth() {
    for (int i = 0; i < spendingOfTheCurrentPageTransactions.length; i++) {
      spendingOfCurrentPageTransactionsValue =
          spendingOfTheCurrentPageTransactions[i] +
              spendingOfCurrentPageTransactionsValue!;
    }
  }

  static getBalance() {
    balanceOfCurrentPageTransactionsValue =
        (incomeOfTheCurrentPageTransactionsValue! -
            spendingOfCurrentPageTransactionsValue!);

    averageIncome = (incomeOfTheCurrentPageTransactionsValue! /
        incomeOfTheCurrentPageTransactions.length);
    averageSpending = (spendingOfCurrentPageTransactionsValue! /
        spendingOfTheCurrentPageTransactions.length);

    averageIncome = double.parse((averageIncome)!.toStringAsFixed(2));
    averageSpending = double.parse((averageSpending)!.toStringAsFixed(2));
  }

  void getWeekDates() {
    String currentWeekRange = _getWeekRange(DateTime.now());
    analyticsStartWeekText = currentWeekRange;
    getAllTransaction();
  }

  String _getWeekRange(DateTime date) {
    DateTime startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
    String startOfWeekStr =
        '${CurrentValues.getMonthName(startOfWeek.month)} ${startOfWeek.day}';
    String endOfWeekStr =
        '${CurrentValues.getMonthName(endOfWeek.month)} ${endOfWeek.day}';
    String year = startOfWeek.year != endOfWeek.year
        ? '${startOfWeek.year} - ${endOfWeek.year}'
        : '${startOfWeek.year}';
    startDate = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    endDate = DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day + 1);
    return '$startOfWeekStr - $endOfWeekStr, $year';
  }

  void updateWeek(int id) {
    DateTime currentWeek = analyticsWeekly ??
        DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
    DateTime nextWeek = id == 1
        ? currentWeek.add(const Duration(days: 7))
        : currentWeek.subtract(const Duration(days: 7));
    analyticsWeekly = nextWeek;
    analyticsStartWeekText = _getWeekRange(nextWeek);
    getAllTransaction();
  }

  void updateMonth(int id) {
    DateTime currentMonth = analyticsMonthly!;
    int nextMonth = id == 0 ? currentMonth.month - 1 : currentMonth.month + 1;
    int nextYear = currentMonth.year;
    if (nextMonth < 1) {
      nextMonth = 12;
      nextYear--;
    } else if (nextMonth > 12) {
      nextMonth = 1;
      nextYear++;
    }
    analyticsMonthlyText = '${CurrentValues.getMonthName(nextMonth)} $nextYear';
    analyticsMonthly = DateTime(nextYear, nextMonth, 1);
    startDate = DateTime(nextYear, nextMonth, 1);
    endDate = DateTime(nextYear, nextMonth + 1, 1);
    getAllTransaction();
  }

  void getCurrentYear() {
    DateTime currentTime = DateTime.now();
    startDate = DateTime(currentTime.year, 1, 1);
    endDate = DateTime(currentTime.year + 1, 1, 1);
    getAllTransaction();
  }

  void getCurrentMonth() {
    DateTime currentTime = DateTime.now();
    startDate = DateTime(currentTime.year, currentTime.month, 1);
    endDate = DateTime(currentTime.year, currentTime.month + 1, 1);
    getAllTransaction();
  }

  void updateYear(int id) {
    DateTime currentYear = analyticsYearly!;
    int nextYear = id == 0 ? currentYear.year - 1 : currentYear.year + 1;
    analyticsYearlyText = nextYear.toString();
    analyticsYearly = DateTime(nextYear, 1, 1);
    startDate = DateTime(nextYear, 1, 1);
    endDate = DateTime(nextYear + 1, 1, 1);
    getAllTransaction();
  }
}
