import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../api/pdf_api.dart';
import '../api/pdf_transaction_api.dart';
import '../model/transaction.dart';
import '../utils/const.dart';
import '../widgets/custom_textstyle.dart';

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

  DateTime? analytics_yearly = DateTime.now();
  DateTime? analytics_monthly = DateTime.now();
  DateTime? analytics_weekly = DateTime.now();

  String? analytics_monthly_text;
  String? analytics_start_week_text, analytics_end_week_text;
  String? analytics_yearly_text;

  static List<AllTransactionDetails> curentpagetransactions = [];
  static List<AllTransactionDetails> curentpageIncometransactions = [];
  static List<AllTransactionDetails> curentpagespendingtransactions = [];

  static List<int> income_of_the_curentpagetransactions = [];
  static List<int> spending_of_the_curentpagetransactions = [];
  static int? len_of_all_transactions,
      len_of_all_income_transactions,
      len_of_all_spending_transactions;
  static int? income_of_the_curentpagetransactions_value = 00;
  static double? average_income = 00;
  static double? average_spending_per_day = 00;
  static double? average_income_per_day = 00;
  static double? average_spending = 00;
  static int? spending_of_the_curentpagetransactions_value = 00;
  static int? balance_of_the_curentpagetransactions_value = 00;
  bool _isloading = false;

  

  Future<void> getAllTransaction() async {
    curentpageIncometransactions.clear();
    curentpagespendingtransactions.clear();
    income_of_the_curentpagetransactions.clear();
    spending_of_the_curentpagetransactions.clear();
    income_of_the_curentpagetransactions_value = 00;
    spending_of_the_curentpagetransactions_value = 00;
    balance_of_the_curentpagetransactions_value = 00;
    average_spending_per_day = 00;
    average_income_per_day = 00;
    average_income = 00;
    average_spending = 00;
    setState(() {
      _isloading = true;
    });
    print("Satrt Date: $startDate");
    print("End Date: $endDate");
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('transaction')
          .orderBy('transactionDate', descending: true)
          .where('transactionDate', isGreaterThanOrEqualTo: startDate)
          .where('transactionDate', isLessThanOrEqualTo: endDate)
          .get();

      final transactionData = snapshot.docs
          .map((doc) => AllTransactionDetails(
              uId: doc["uId"],
              tID: doc['tID'],
              transactionsubcategoryindex: doc['transactionsubcategoryindex'],
              transactionAmount: doc['transactionAmount'],
              transactioncategory: doc['transactionCategory'],
              transactionDate: doc['transactionDate'],
              transactionnote: doc['transactionnote'],
              transactionpaymentmode: doc['transactionpaymentmode'],
              transactionsubcategory: doc['transactionsubcategory'],
              transactionCreatedAt: doc['transactionCreatedAt']))
          .toList();

      setState(() {
        curentpagetransactions = transactionData;
        print(transactionData.length);
        len_of_all_transactions = curentpagetransactions.length;
        _isloading = false;
        findIncomeSpending();
      });
    } catch (e) {
      setState(() {
        _isloading = false;
      });
      print(e);
    }
  }

  static void findIncomeSpending() {
    for (int i = 0, j = 0, k = 0; i < curentpagetransactions.length; i++) {
      if (curentpagetransactions[i].transactioncategory == 0 || curentpagetransactions[i].transactioncategory == 3) {
        income_of_the_curentpagetransactions
            .add(curentpagetransactions[i].transactionAmount!);

        curentpageIncometransactions.insert(
            j,
            AllTransactionDetails(
                uId: curentpagetransactions[i].uId,
                tID: curentpagetransactions[i].tID,
                transactionDate: curentpagetransactions[i].transactionDate,
                transactionAmount: curentpagetransactions[i].transactionAmount,
                transactioncategory:
                    curentpagetransactions[i].transactioncategory,
                transactionsubcategory:
                    curentpagetransactions[i].transactionsubcategory,
                transactionsubcategoryindex:
                    curentpagetransactions[i].transactionsubcategoryindex,
                transactionnote: curentpagetransactions[i].transactionnote,
                transactionpaymentmode:
                    curentpagetransactions[i].transactionpaymentmode,
                transactionCreatedAt:
                    curentpagetransactions[i].transactionCreatedAt));
        j++;
        print(
            "curentpageIncometransactions ${curentpageIncometransactions.length}");
      } else if (curentpagetransactions[i].transactioncategory == 1) {
        spending_of_the_curentpagetransactions
            .add(curentpagetransactions[i].transactionAmount!);
        curentpagespendingtransactions.insert(
            k,
            AllTransactionDetails(
                uId: curentpagetransactions[i].uId,
                tID: curentpagetransactions[i].tID,
                transactionDate: curentpagetransactions[i].transactionDate,
                transactionAmount: curentpagetransactions[i].transactionAmount,
                transactioncategory:
                    curentpagetransactions[i].transactioncategory,
                transactionsubcategory:
                    curentpagetransactions[i].transactionsubcategory,
                transactionsubcategoryindex:
                    curentpagetransactions[i].transactionsubcategoryindex,
                transactionnote: curentpagetransactions[i].transactionnote,
                transactionpaymentmode:
                    curentpagetransactions[i].transactionpaymentmode,
                transactionCreatedAt:
                    curentpagetransactions[i].transactionCreatedAt));
                    k++;
      } else {}
    }
    print(
        "spending_of_the_month.length ${spending_of_the_curentpagetransactions.length}");
    print(
        "income_of_the_month.length ${income_of_the_curentpagetransactions.length}");
    len_of_all_income_transactions =
        income_of_the_curentpagetransactions.length;
    len_of_all_spending_transactions =
        spending_of_the_curentpagetransactions.length;
    totlaIncomOfTheMonth();
    totlaExpensesOfTheMonth();
    getBalance();
  }

  static void totlaIncomOfTheMonth() {
    for (int i = 0; i < income_of_the_curentpagetransactions.length; i++) {
      income_of_the_curentpagetransactions_value =
          income_of_the_curentpagetransactions[i] +
              income_of_the_curentpagetransactions_value!;
    }
  }

  static void totlaExpensesOfTheMonth() {
    for (int i = 0; i < spending_of_the_curentpagetransactions.length; i++) {
      spending_of_the_curentpagetransactions_value =
          spending_of_the_curentpagetransactions[i] +
              spending_of_the_curentpagetransactions_value!;
    }
    print(
        "income_of_the_month_value : $income_of_the_curentpagetransactions_value");
    print(
        "expenses_of_the_month_value : $spending_of_the_curentpagetransactions_value");
  }

  static getBalance() {
    balance_of_the_curentpagetransactions_value =
        (income_of_the_curentpagetransactions_value! -
            spending_of_the_curentpagetransactions_value!);

    average_income = (income_of_the_curentpagetransactions_value! /
        len_of_all_income_transactions!) as double?;
    average_spending = (spending_of_the_curentpagetransactions_value! /
        len_of_all_spending_transactions!) as double?;

    average_income = double.parse((average_income)!.toStringAsFixed(2));
    average_spending = double.parse((average_spending)!.toStringAsFixed(2));

    print(balance_of_the_curentpagetransactions_value);
  }

  void getWeekDates() {
    String currentWeekRange = _getWeekRange(DateTime.now());
    print('$currentWeekRange');
    analytics_start_week_text = currentWeekRange;
    getAllTransaction();
  }

  String _getWeekRange(DateTime date) {
    DateTime startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
    String startOfWeekStr =
        '${_getMonthName(startOfWeek.month)} ${startOfWeek.day}';
    String endOfWeekStr = '${_getMonthName(endOfWeek.month)} ${endOfWeek.day}';
    String year = '${startOfWeek.year}';
    if (startOfWeek.year != endOfWeek.year) {
      year = '${startOfWeek.year} - ${endOfWeek.year}';
    }
    startDate = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    endDate = DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day + 1);
    return '$startOfWeekStr - $endOfWeekStr, $year';
  }

  void updateWeek(int id) {
    if (id == 1) {
      DateTime currentWeek = analytics_weekly ??
          DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
      DateTime nextWeek = currentWeek.add(Duration(days: 7));
      print('Current week: ${_getWeekRange(currentWeek)}');
      print('Next week: ${_getWeekRange(nextWeek)}');

      analytics_weekly = nextWeek;
      analytics_start_week_text = _getWeekRange(nextWeek);
      getAllTransaction();
    } else {
      DateTime currentWeek = analytics_weekly ??
          DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
      DateTime prevWeek = currentWeek.subtract(Duration(days: 7));
      print('Current week: ${_getWeekRange(currentWeek)}');
      analytics_weekly = prevWeek;
      analytics_start_week_text = _getWeekRange(prevWeek);
      getAllTransaction();
    }
  }

  void updateMonth(int id) {
    if (id == 0) {
      DateTime currentMonth = analytics_monthly!;
      print(currentMonth);
      int nextMonth = currentMonth.month - 1;
      int nextYear = currentMonth.year;
      if (nextMonth < 1) {
        nextMonth = 12;
        nextYear--;
      }
      print(nextMonth);
      // startDate=DateTime(nextMonth.year,,);
      analytics_monthly_text = '${_getMonthName(nextMonth)} $nextYear';
      startDate = DateTime(nextYear, nextMonth, 1);
      endDate = DateTime(nextYear, nextMonth + 1, 1);
      analytics_monthly = DateTime(nextYear, nextMonth, 1);
      getAllTransaction();
    } else {
      DateTime currentMonth = analytics_monthly!;
      print(currentMonth);
      int nextMonth = currentMonth.month + 1;
      int nextYear = currentMonth.year;
      if (nextMonth > 12) {
        nextMonth = 1;
        nextYear++;
      }
      print(nextMonth);
      analytics_monthly_text = '${_getMonthName(nextMonth)} $nextYear';
      analytics_monthly = DateTime(nextYear, nextMonth, 1);
      startDate = DateTime(nextYear, nextMonth, 1);
      endDate = DateTime(nextYear, nextMonth + 1, 1);
      getAllTransaction();
    }
  }

  String _getMonthName(int monthNumber) {
    switch (monthNumber) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }

  void getCurrentYear() {
    DateTime currenttime = DateTime.now();
    startDate = DateTime(currenttime.year, 1, 1);
    endDate = DateTime(currenttime.year + 1, 1, 1);
    getAllTransaction();
  }

  void getCurrentMonth() {
    DateTime currenttime = DateTime.now();
    startDate = DateTime(currenttime.year, currenttime.month, 1);
    endDate = DateTime(currenttime.year, currenttime.month + 1, 1);
    getAllTransaction();
  }

  void updateYear(int id) {
    if (id == 0) {
      DateTime currentyear = analytics_yearly!;

      int nextyear = currentyear.year - 1;

      analytics_yearly_text = nextyear.toString();
      analytics_yearly = DateTime(nextyear, 1, 1);
      startDate = DateTime(nextyear, 1, 1);
      endDate = DateTime(nextyear + 1, 1, 1);
      getAllTransaction();
    } else {
      DateTime currentyear = analytics_yearly!;
      print(currentyear);
      int nextyear = currentyear.year + 1;
      print(nextyear);
      analytics_yearly_text = nextyear.toString();
      analytics_yearly = DateTime(nextyear, 1, 1);
      startDate = DateTime(nextyear, 1, 1);
      endDate = DateTime(nextyear + 1, 1, 1);
      getAllTransaction();
    }
  }

  @override
  void initState() {
    super.initState();
        uid = FirebaseAuth.instance.currentUser!.uid;
    analytics_monthly_text = DateFormat.yMMM().format(analytics_monthly!);
    analytics_yearly_text = DateFormat.y().format(analytics_yearly!);
    getWeekDates();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
                          padding: EdgeInsets.only(left: 10,right: 10,top: 15),

          child: Column(
            children: [
              // Text('Transaction Analysis',style: TextStyle(color: PrimaryColor.color_bottle_green,fontSize: MediaQuery.of(context).size.height*0.03),),
              SizedBox(
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
                              ? PrimaryColor.color_bottle_green
                              : Colors.black),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 1.0, vertical: 3.0),
                      child: Column(
                        children: [
                          Text(
                            "Weekly",
                            style: TextStyle(
                              color: (value == 0)
                                  ? PrimaryColor.color_bottle_green
                                  : Colors.black,
                            ),
                          ),
                          Text(
                            "Analysis",
                            style: TextStyle(
                              color: (value == 0)
                                  ? PrimaryColor.color_bottle_green
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
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
                              ? PrimaryColor.color_bottle_green
                              : Colors.black),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 1.0, vertical: 3.0),
                      child: Column(
                        children: [
                          Text(
                            "Monthly",
                            style: TextStyle(
                              color: (value == 1)
                                  ? PrimaryColor.color_bottle_green
                                  : Colors.black,
                            ),
                          ),
                          Text(
                            "Analysis",
                            style: TextStyle(
                              color: (value == 1)
                                  ? PrimaryColor.color_bottle_green
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
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
                              ? PrimaryColor.color_bottle_green
                              : Colors.black),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 1.0, vertical: 3.0),
                      child: Column(
                        children: [
                          Text(
                            "Yearly",
                            style: TextStyle(
                              color: (value == 2)
                                  ? PrimaryColor.color_bottle_green
                                  : Colors.black,
                            ),
                          ),
                          Text(
                            "Analysis",
                            style: TextStyle(
                              color: (value == 2)
                                  ? PrimaryColor.color_bottle_green
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
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
                    color: PrimaryColor.color_bottle_green,
                  ),
                  value == 0
                      ? Text(
                          "$analytics_start_week_text",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.023),
                        )
                      : Container(
                          child: value == 1
                              ? Text(
                                  '$analytics_monthly_text',
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.023),
                                )
                              : Text(
                                  '$analytics_yearly_text',
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.023),
                                )),
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
                    color: PrimaryColor.color_bottle_green,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: PrimaryColor.color_red,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.43,
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60)),
                                color: PrimaryColor.color_white,
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.14,
                                  height: MediaQuery.of(context).size.height,
                                  child: Icon(
                                    Icons.arrow_upward,
                                    color: PrimaryColor.color_red,
                                    size: 32,
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextStyle(
                                    customtextstyletext: "Spending",
                                    customtextcolor: PrimaryColor.color_white,
                                    customtextfontweight: FontWeight.normal,
                                    customtextstyle: null,
                                    customtextsize: 16.0),
                                CustomTextStyle(
                                    customtextstyletext:
                                        "₹${spending_of_the_curentpagetransactions_value}",
                                    customtextcolor: PrimaryColor.color_white,
                                    customtextfontweight: FontWeight.bold,
                                    customtextstyle: null,
                                    customtextsize: 14.5),
                              ],
                            )
                          ],
                        ),
                      )),
                  Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: PrimaryColor.color_bottle_green,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.43,
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60)),
                                color: PrimaryColor.color_white,
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.14,
                                  height: MediaQuery.of(context).size.height,
                                  child: Icon(
                                    Icons.arrow_downward,
                                    color: PrimaryColor.color_bottle_green,
                                    size: 32,
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextStyle(
                                    customtextstyletext: "Income",
                                    customtextcolor: PrimaryColor.color_white,
                                    customtextfontweight: FontWeight.normal,
                                    customtextstyle: null,
                                    customtextsize: 16.0),
                                CustomTextStyle(
                                    customtextstyletext:
                                        "₹${income_of_the_curentpagetransactions_value}",
                                    customtextcolor: PrimaryColor.color_white,
                                    customtextfontweight: FontWeight.bold,
                                    customtextstyle: null,
                                    customtextsize: 14.5),
                              ],
                            )
                          ],
                        ),
                      )),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                          child: balance_of_the_curentpagetransactions_value! > 0 ?CustomTextStyle(
                                      customtextstyletext:
                                          "Balance: ₹${balance_of_the_curentpagetransactions_value}",
                                      customtextcolor: PrimaryColor.color_black,
                                      customtextfontweight: FontWeight.normal,
                                      customtextstyle: null,
                                      customtextsize: 15.0)
                                  :CustomTextStyle(
                                      customtextstyletext:
                                          "Balance: - ₹${balance_of_the_curentpagetransactions_value?.abs()}",
                                      customtextcolor: PrimaryColor.color_black,
                                      customtextfontweight: FontWeight.normal,
                                      customtextstyle: null,
                                      customtextsize: 15.0)),
                    )),
              ),
              const SizedBox(
                height: 10,
              ),
        
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Text(
                      'Category-wise Spending',
                      style: TextStyle(
                          color: PrimaryColor.color_black,
                          fontSize: MediaQuery.of(context).size.height * 0.024,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Card(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.30,
                  child: 
                  curentpagespendingtransactions.length==0 ?Center(child: Text('No Data',style: TextStyle(fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.height*0.025,color: Colors.black38),),)
                      :SfCircularChart(series: <CircularSeries>[
                    PieSeries<AllTransactionDetails, String>(
                        dataSource: curentpagespendingtransactions,
                        xValueMapper: (AllTransactionDetails data, _) =>
                            data.transactionnote as String,
                        yValueMapper: (AllTransactionDetails data, _) =>
                            data.transactionAmount,
                        dataLabelMapper: (AllTransactionDetails data, _) =>
                            data.transactionnote!+ '\n' + (data.transactionAmount).toString() as String,
                        radius: '55%',
                        dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            margin: EdgeInsets.zero,
                            labelIntersectAction: LabelIntersectAction.none,
                            overflowMode: OverflowMode.shift,
                            // groupMode: CircularChartGroupMode.value,
                            showZeroValue: true,
                            labelPosition: ChartDataLabelPosition.outside,
                            connectorLineSettings: ConnectorLineSettings(
                                length: '20%', type: ConnectorType.line)))
                  ]),
                ),
              ),
        
              const SizedBox(height: 10,),
        
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Text(
                      'Category-wise Income',
                      style: TextStyle(
                          color: PrimaryColor.color_black,
                          fontSize: MediaQuery.of(context).size.height * 0.024,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Card(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.30,
                  child: 
                      curentpageIncometransactions.length==0 ?Center(child: Text('No Data',style: TextStyle(fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.height*0.025,color: Colors.black38),),)
                      :SfCircularChart(series: <CircularSeries>[
                        PieSeries<AllTransactionDetails, String>(
                            dataSource: curentpageIncometransactions,
                            xValueMapper: (AllTransactionDetails data, _) =>
                                data.transactionnote,
                            yValueMapper: (AllTransactionDetails data, _) =>
                                data.transactionAmount,
                            dataLabelMapper: (AllTransactionDetails data, _) =>
                            data.transactionnote!+ '\n' + (data.transactionAmount).toString() as String,
                            radius: '55%',
                            dataLabelSettings: DataLabelSettings(
                                isVisible: true,
                                margin: EdgeInsets.zero,
                                labelIntersectAction: LabelIntersectAction.none,
                                overflowMode: OverflowMode.shift,
                                // groupMode: CircularChartGroupMode.value,
                                showZeroValue: true,
                                labelPosition: ChartDataLabelPosition.outside,
                                connectorLineSettings: ConnectorLineSettings(
                                    length: '20%', type: ConnectorType.line)))
                      ]),
                    
                ),
              ),
        
              
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Text(
                      'Stats',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.024,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
        
              Container(
                height: MediaQuery.of(context).size.height * 0.205,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Number of Transaction',
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.022,color: Colors.black45),
                            ),
                            Text(
                              '$len_of_all_transactions',
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.022,color: Colors.black45),
                            )
                          ],
                        ),
                        // SizedBox(
                        //   height: ,
                        // ),
                        Row(
                          children: [
                            Text(
                              'Average Income',
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.022,color: Colors.black45),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Per Transaction',
                                style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.height *
                                        0.020,color: Colors.black45),
                              ),
                              average_income!.isNaN
                                  ? Text(
                                      '₹0.0',
                                      style: TextStyle(
                                          fontSize:
                                              MediaQuery.of(context).size.height *
                                                  0.020,color: Colors.black45),
                                    )
                                  : Text(
                                      '₹$average_income',
                                      style: TextStyle(
                                          fontSize:
                                              MediaQuery.of(context).size.height *
                                                  0.020,color: Colors.black45),
                                    ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Average Spending',
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.022,color: Colors.black45),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Per Transaction',
                                style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.height *
                                        0.020,color: Colors.black45),
                              ),
                              average_spending!.isNaN
                                  ? Text(
                                      '₹0.0',
                                      style: TextStyle(
                                          fontSize:
                                              MediaQuery.of(context).size.height *
                                                  0.020),
                                    )
                                  : Text(
                                      '₹$average_spending',
                                      style: TextStyle(
                                          fontSize:
                                              MediaQuery.of(context).size.height *
                                                  0.020,color: Colors.black45),
                                    )
                            ],
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: ()async{
                      final pdfFile;
                      value==0 ?pdfFile = await PdfInvoiceApi.generate(curentpagetransactions,analytics_start_week_text!,"Weekly Analysis",income_of_the_curentpagetransactions_value!,spending_of_the_curentpagetransactions_value!,balance_of_the_curentpagetransactions_value!) 
                      :value==1 ?pdfFile = await PdfInvoiceApi.generate(curentpagetransactions,analytics_monthly_text!,"Monthly Analysis",income_of_the_curentpagetransactions_value!,spending_of_the_curentpagetransactions_value!,balance_of_the_curentpagetransactions_value!) 
                      :pdfFile = await PdfInvoiceApi.generate(curentpagetransactions,analytics_yearly_text!,"Yearly Analysis",income_of_the_curentpagetransactions_value!,spending_of_the_curentpagetransactions_value!,balance_of_the_curentpagetransactions_value!);
                      
                              PdfApi.openFile(pdfFile);
                    },
                    child: Card(
                                          color: PrimaryColor.color_bottle_green,
                    
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Row(
                          children: [
                            Icon(Icons.file_download,color: PrimaryColor.color_white,),
                            Text(
                              "Download stats",
                              style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.02, color: PrimaryColor.color_white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
