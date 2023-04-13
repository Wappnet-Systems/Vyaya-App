import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_tracker/screens/transaction_screen.dart';
import 'package:expenses_tracker/screens/transactions_of_month.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/transaction.dart';
import '../model/users.dart';
import '../utils/const.dart';
import '../utils/functions.dart';
import '../widgets/build_skeleton.dart';
import '../widgets/custom_balance_card.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_header.dart';
import '../widgets/custom_linear_process_indicator.dart';
import '../widgets/custom_textstyle.dart';
import '../widgets/custom_transaction.dart';


class DetailHomeScreen extends StatefulWidget {
  const DetailHomeScreen({super.key});

  @override
  State<DetailHomeScreen> createState() => _DetailHomeScreenState();
}

class _DetailHomeScreenState extends State<DetailHomeScreen> {
  bool _isloading = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? wishingtext, curentmonth;
  List<AllTransactionDetails> transactions = [];
  List<AllTransactionDetails> currentMonthtransactions = [];

  static double? _userScore = 0.0;
  static String? pf_score;
  static double? _needprogressValue = 0.0;
  static double? _wantprogressValue = 0.0;
  static double? _savingprogressValue = 0.0;

  List<Users> listofUsers = [];
  int _selectedIndex = 0;
  Color iconcolor = PrimaryColor.color_bottle_green;
  static String? username, initial_of_name, userId;

  static List<AllTransactionDetails> curentmonthtransactions = [];

  static List<AllTransactionDetails> curentmonthincometransactions = [];
  static List<AllTransactionDetails> curentmonthspendingtransactions = [];

  static List<AllTransactionDetails> currentmonthneedstransaction = [];
  static List<AllTransactionDetails> currentmonthwantstransaction = [];
  static List<AllTransactionDetails> currentmonthsavingtransaction = [];

  static List<int> income_of_the_month = [];
  static List<int> income_of_the_month_pf = [];
  static List<int> spending_of_the_month = [];
  static int? income_of_the_month_value = 00;
  static int? income_for_personal_finance = 00;
  static int? spending_of_the_month_value = 00;
  static int? balance_of_the_month_value = 00;
  static int? balance_of_the_month_pf_value = 00;
  static double? needs_of_the_month_value = 00;
  static double? wants_of_the_month_value = 00;
  static double? saving_of_the_month_value = 00;

  static double? expense_needs_of_the_value = 00;
  static double? expense_wants_of_the_value = 00;
  static double? expense_saving_of_the_value = 00;

  String? uid;

  Future<void> getBlanceOfMonth() async {
    income_of_the_month.clear();
    spending_of_the_month.clear();
    income_of_the_month_pf.clear();
    curentmonthspendingtransactions.clear();
    currentmonthsavingtransaction.clear();
    curentmonthincometransactions.clear();
    currentmonthwantstransaction.clear();
    currentmonthneedstransaction.clear();

    income_of_the_month_value = 00;
    balance_of_the_month_pf_value = 00;
    income_for_personal_finance = 00;
    spending_of_the_month_value = 00;
    balance_of_the_month_value = 00;

    needs_of_the_month_value = 00;
    wants_of_the_month_value = 00;
    saving_of_the_month_value = 00;

    expense_needs_of_the_value = 00;
    expense_wants_of_the_value = 00;
    expense_saving_of_the_value = 00;

    DateTime startDate = DateTime(
        CurrentValues.getCurrentYear(), CurrentValues.getCurrentMonth(), 1);
    DateTime endDate = DateTime(
        CurrentValues.getCurrentYear(), CurrentValues.getCurrentMonth() + 1, 1);

    setState(() {
      _isloading = true;
    });
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
        curentmonthtransactions = transactionData;
        print(curentmonthtransactions.length);
        print(transactionData.length);
        findIncomeSpending();
        _isloading = false;
      });
    } catch (e) {
      setState(() {
        _isloading = false;
      });
      print(e);
    }
  }

  static void findIncomeSpending() {
    for (int i = 0, j = 0, k = 0; i < curentmonthtransactions.length; i++) {
      if (curentmonthtransactions[i].transactioncategory == 0 ||
          curentmonthtransactions[i].transactioncategory == 3) {
        if (curentmonthtransactions[i].transactioncategory == 0) {
          income_of_the_month
              .add(curentmonthtransactions[i].transactionAmount!);
        } else {
          print('Not to add in Personal Finance');
          income_of_the_month
              .add(curentmonthtransactions[i].transactionAmount!);
          income_of_the_month_pf
              .add(curentmonthtransactions[i].transactionAmount!);
          curentmonthincometransactions.insert(
              j,
              AllTransactionDetails(
                  uId: curentmonthtransactions[i].uId,
                  tID: curentmonthtransactions[i].tID,
                  transactionDate: curentmonthtransactions[i].transactionDate,
                  transactionAmount:
                      curentmonthtransactions[i].transactionAmount,
                  transactioncategory:
                      curentmonthtransactions[i].transactioncategory,
                  transactionsubcategory:
                      curentmonthtransactions[i].transactionsubcategory,
                  transactionsubcategoryindex:
                      curentmonthtransactions[i].transactionsubcategoryindex,
                  transactionnote: curentmonthtransactions[i].transactionnote,
                  transactionpaymentmode:
                      curentmonthtransactions[i].transactionpaymentmode,
                  transactionCreatedAt:
                      curentmonthtransactions[i].transactionCreatedAt));
          j++;
        }
      } else if (curentmonthtransactions[i].transactioncategory == 1) {
        spending_of_the_month
            .add(curentmonthtransactions[i].transactionAmount!);
        curentmonthspendingtransactions.insert(
            k,
            AllTransactionDetails(
                uId: curentmonthtransactions[i].uId,
                tID: curentmonthtransactions[i].tID,
                transactionDate: curentmonthtransactions[i].transactionDate,
                transactionAmount: curentmonthtransactions[i].transactionAmount,
                transactioncategory:
                    curentmonthtransactions[i].transactioncategory,
                transactionsubcategory:
                    curentmonthtransactions[i].transactionsubcategory,
                transactionsubcategoryindex:
                    curentmonthtransactions[i].transactionsubcategoryindex,
                transactionnote: curentmonthtransactions[i].transactionnote,
                transactionpaymentmode:
                    curentmonthtransactions[i].transactionpaymentmode,
                transactionCreatedAt:
                    curentmonthtransactions[i].transactionCreatedAt));

        k++;
      } else {}
    }
    print(
        "spending_of_the_month.length ${curentmonthspendingtransactions.length}");
    print("income_of_the_month.length ${income_of_the_month.length}");

    totlaIncomOfTheMonth();
    totlaExpensesOfTheMonth();
    getBalance();
  }

  static void totlaIncomOfTheMonth() {
    for (int i = 0; i < income_of_the_month.length; i++) {
      income_of_the_month_value =
          income_of_the_month[i] + income_of_the_month_value!;
    }
    for (int i = 0; i < income_of_the_month_pf.length; i++) {
      income_for_personal_finance =
          income_of_the_month_pf[i] + income_for_personal_finance!;
    }
  }

  static void totlaExpensesOfTheMonth() {
    for (int i = 0; i < spending_of_the_month.length; i++) {
      spending_of_the_month_value =
          spending_of_the_month[i] + spending_of_the_month_value!;
    }
  }

  static getBalance() {
    balance_of_the_month_value =
        (income_of_the_month_value! - spending_of_the_month_value!);
    print(balance_of_the_month_value);

    balance_of_the_month_pf_value =
        (income_for_personal_finance! - spending_of_the_month_value!);

    // curentmonthincometransactions[]
    needs_of_the_month_value =
        (income_for_personal_finance! * 50 / 100) as double?;
    wants_of_the_month_value =
        (income_for_personal_finance! * 30 / 100) as double?;
    saving_of_the_month_value =
        (income_for_personal_finance! * 20 / 100) as double?;

    getPersonalFinance();
  }

  static getPersonalFinance() {
    for (int i = 0, j = 0, k = 0, x = 0;
        i < curentmonthspendingtransactions.length;
        i++) {
      if (curentmonthspendingtransactions[i].transactionsubcategory == 0) {
        currentmonthneedstransaction.insert(
            j,
            AllTransactionDetails(
                uId: curentmonthspendingtransactions[i].uId,
                tID: curentmonthspendingtransactions[i].tID,
                transactionDate:
                    curentmonthspendingtransactions[i].transactionDate,
                transactionAmount:
                    curentmonthspendingtransactions[i].transactionAmount,
                transactioncategory:
                    curentmonthspendingtransactions[i].transactioncategory,
                transactionsubcategory:
                    curentmonthspendingtransactions[i].transactionsubcategory,
                transactionsubcategoryindex: curentmonthspendingtransactions[i]
                    .transactionsubcategoryindex,
                transactionnote:
                    curentmonthspendingtransactions[i].transactionnote,
                transactionpaymentmode:
                    curentmonthspendingtransactions[i].transactionpaymentmode,
                transactionCreatedAt:
                    curentmonthspendingtransactions[i].transactionCreatedAt));
        j++;
      } else if (curentmonthspendingtransactions[i].transactionsubcategory ==
          1) {
        currentmonthwantstransaction.insert(
            k,
            AllTransactionDetails(
                uId: curentmonthspendingtransactions[i].uId,
                tID: curentmonthspendingtransactions[i].tID,
                transactionDate:
                    curentmonthspendingtransactions[i].transactionDate,
                transactionAmount:
                    curentmonthspendingtransactions[i].transactionAmount,
                transactioncategory:
                    curentmonthspendingtransactions[i].transactioncategory,
                transactionsubcategory:
                    curentmonthspendingtransactions[i].transactionsubcategory,
                transactionsubcategoryindex: curentmonthspendingtransactions[i]
                    .transactionsubcategoryindex,
                transactionnote:
                    curentmonthspendingtransactions[i].transactionnote,
                transactionpaymentmode:
                    curentmonthspendingtransactions[i].transactionpaymentmode,
                transactionCreatedAt:
                    curentmonthspendingtransactions[i].transactionCreatedAt));
        k++;
      } else if (curentmonthspendingtransactions[i].transactionsubcategory ==
          2) {
        currentmonthsavingtransaction.insert(
            x,
            AllTransactionDetails(
                uId: curentmonthspendingtransactions[i].uId,
                tID: curentmonthspendingtransactions[i].tID,
                transactionDate:
                    curentmonthspendingtransactions[i].transactionDate,
                transactionAmount:
                    curentmonthspendingtransactions[i].transactionAmount,
                transactioncategory:
                    curentmonthspendingtransactions[i].transactioncategory,
                transactionsubcategory:
                    curentmonthspendingtransactions[i].transactionsubcategory,
                transactionsubcategoryindex: curentmonthspendingtransactions[i]
                    .transactionsubcategoryindex,
                transactionnote:
                    curentmonthspendingtransactions[i].transactionnote,
                transactionpaymentmode:
                    curentmonthspendingtransactions[i].transactionpaymentmode,
                transactionCreatedAt:
                    curentmonthspendingtransactions[i].transactionCreatedAt));
        x++;
      } else {}
    }
    getAmountOfPersonalFinaance();
  }

  static void getAmountOfPersonalFinaance() {
    for (int i = 0; i < currentmonthneedstransaction.length; i++) {
      expense_needs_of_the_value =
          (currentmonthneedstransaction[i].transactionAmount! +
              expense_needs_of_the_value!);
    }
    for (int i = 0; i < currentmonthwantstransaction.length; i++) {
      expense_wants_of_the_value =
          (currentmonthwantstransaction[i].transactionAmount! +
              expense_wants_of_the_value!);
    }
    for (int i = 0; i < currentmonthsavingtransaction.length; i++) {
      expense_saving_of_the_value =
          (currentmonthsavingtransaction[i].transactionAmount! +
              expense_saving_of_the_value!);
    }
    _savingprogressValue =
        ((1.0 * expense_saving_of_the_value!) / saving_of_the_month_value!);
    _needprogressValue =
        ((1.0 * expense_needs_of_the_value!) / needs_of_the_month_value!);
    _wantprogressValue =
        ((1.0 * expense_wants_of_the_value!) / wants_of_the_month_value!);

    _userScore =
        (_savingprogressValue! + _needprogressValue! + _wantprogressValue!) / 3;
    _userScore = (_userScore! * 100);
    _userScore = 100.00 - _userScore!;
    if (_userScore! < 0) {
      _userScore = 0.00;
    }

    if(_userScore!<=0){
      pf_score="Bad";
    }
    else if(_userScore!>=1 && _userScore!<=60){
      pf_score="Good";
    }
    else if(_userScore!>=61 && _userScore! <=100){
      pf_score="Excellent";
    }
    // pf_score = _userScore!.toStringAsFixed(2);

    print("Value check: $_savingprogressValue");
    print("Value check: $_needprogressValue");
    print("Value check: $_wantprogressValue");

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String pf_name = DateFormat('MMM yyyy').format(DateTime.now()).toString();;
    
    Timestamp createdAt = Timestamp.now();
    final personal_finance_data = firestore
        .collection('users')
        .doc(userId)
        .collection('personal_finance')
        .doc(pf_name);
    personal_finance_data.set({
      'uId': userId,
      'incomeForPF': income_for_personal_finance,
      'balanceLeftOnPF':balance_of_the_month_pf_value,
      'needAlocatedAmoount': needs_of_the_month_value,
      'wantAlocatedAmoount': wants_of_the_month_value,
      'savingAlocatedAmoount': saving_of_the_month_value,
      'expenseOnNeed':expense_needs_of_the_value,
      'expenseOnWant':expense_wants_of_the_value,
      'expenseOnSaving':expense_saving_of_the_value,
      'pfScore':_userScore,
      'lastUpdated': createdAt
    });
  }

  @override
  void initState() {
    uid = FirebaseAuth.instance.currentUser!.uid;
    wishingtext = getCurrentHour();
    curentmonth = getCurrentMonth();
    getSingleUserData();
    getAllTransaction();
    scheduleNotification(); 
    getBlanceOfMonth();
    super.initState();
  }

  void scheduleNotification() async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 0,
      channelKey: 'scheduled_channel',
      title: 'Vyaya App',
      body: 'Don\'t forget to complete your daily tasks!',
      notificationLayout: NotificationLayout.BigText,
    ),
    schedule: NotificationCalendar(
      weekday: DateTime.thursday,
      hour: 19,
      minute: 47,
      second: 0,
      millisecond: 0,
      allowWhileIdle: true,
    ),
  );
}


  
  Future<void> getSingleUserData() async {
    setState(() {
      _isloading = true;
      print(UserData.CurrentUserId);
    });
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('user_details')
          .get();
      final userData = snapshot.docs
          .map((e) => Users(
              Useremail: e['Useremail'],
              userIdfrommobile: e['userIdfrommobile'],
              userMobile: e['userMobile'],
              userName: e['userName'],
              userToken:e['UserToken']))
          .toList();
      setState(() {
        listofUsers = userData;
        username = listofUsers[0].userName;
        initial_of_name = username!.substring(0, 1).toUpperCase();
        userId = listofUsers[0].userIdfrommobile;
        UserData.CurentUserToken=listofUsers[0].userToken;
        UserData.CurentUserName = listofUsers[0].userName;
        UserData.CurentUserPhone = listofUsers[0].userMobile;
        UserData.CurrentUserEmail = listofUsers[0].Useremail;
        _isloading = false;
      });
    } catch (e) {
      setState(() {
        _isloading = false;
      });
      print(e);
    }

    print(listofUsers.length);
  }

  Future<void> getAllTransaction() async {
    print(UserData.CurrentUserId);
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('transaction')
        .limit(4)
        .orderBy('transactionDate', descending: true)
        .get();

    final transactionData = snapshot.docs
        .map((doc) => AllTransactionDetails(
            uId: doc["uId"],
            tID: doc['tID'],
            transactionAmount: doc['transactionAmount'],
            transactioncategory: doc['transactionCategory'],
            transactionDate: doc['transactionDate'],
            transactionnote: doc['transactionnote'],
            transactionpaymentmode: doc['transactionpaymentmode'],
            transactionsubcategory: doc['transactionsubcategory'],
            transactionsubcategoryindex: doc['transactionsubcategoryindex'],
            transactionCreatedAt: doc['transactionCreatedAt']))
        .toList();

    setState(() {
      transactions = transactionData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isloading == true
          ? HomeSkeleton()
          // ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10, top: 15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomHeader(
                          initial_of_name: initial_of_name,
                          username: username,
                          wishingtext: wishingtext),
                      const SizedBox(
                        height: 25,
                      ),
                      CustomTextStyle(
                          customtextstyletext: "$curentmonth",
                          customtextcolor: PrimaryColor.color_black,
                          customtextfontweight: FontWeight.normal,
                          customtextstyle: null,
                          customtextsize: 25.0),
                      const SizedBox(
                        height: 7,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          CustomCard(
                              color: PrimaryColor.color_red,
                              icon: Icon(
                                Icons.arrow_upward,
                                color: PrimaryColor.color_red,
                                size: 32,
                              ),
                              spe_or_inc_month_value:
                                  spending_of_the_month_value,
                              title: "Spending"),
                          CustomCard(
                              color: PrimaryColor.color_bottle_green,
                              icon: Icon(
                                Icons.arrow_downward,
                                color: PrimaryColor.color_bottle_green,
                                size: 32,
                              ),
                              spe_or_inc_month_value: income_of_the_month_value,
                              title: "Income"),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomBalanceCard(
                          balance_of_the_month_value:
                              balance_of_the_month_value),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextStyle(
                                customtextstyletext: "Personal Finance",
                                customtextcolor: PrimaryColor.color_black,
                                customtextfontweight: FontWeight.bold,
                                customtextstyle: null,
                                customtextsize: 20),
                            GestureDetector(
                              onTap: () {

                              },
                              child: CustomTextStyle(
                                  customtextstyletext: "Set Manually",
                                  customtextcolor: Colors.blueAccent,
                                  customtextfontweight: FontWeight.bold,
                                  customtextstyle: null,
                                  customtextsize: 14),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          height: needs_of_the_month_value! <
                                  expense_needs_of_the_value!
                              ? wants_of_the_month_value! <
                                      expense_wants_of_the_value!
                                  ? saving_of_the_month_value! <
                                          expense_saving_of_the_value!
                                      ? MediaQuery.of(context).size.height *
                                          0.34
                                      : MediaQuery.of(context).size.height *
                                          0.32
                                  : saving_of_the_month_value! <
                                          expense_saving_of_the_value!
                                      ? MediaQuery.of(context).size.height *
                                          0.32
                                      : MediaQuery.of(context).size.height *
                                          0.30
                              : wants_of_the_month_value! <
                                      expense_wants_of_the_value!
                                  ? saving_of_the_month_value! <
                                          expense_saving_of_the_value!
                                      ? MediaQuery.of(context).size.height *
                                          0.30
                                      : MediaQuery.of(context).size.height *
                                          0.30
                                  : MediaQuery.of(context).size.height * 0.30,
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            child: balance_of_the_month_pf_value! <= 0
                                ? Center(
                                    child: CustomTextStyle(
                                        customtextstyletext: "No Data",
                                        customtextcolor: Colors.black38,
                                        customtextfontweight: FontWeight.bold,
                                        customtextstyle: null,
                                        customtextsize:
                                            MediaQuery.of(context).size.height *
                                                0.025))
                                : Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0, vertical: 6),
                                            child: Text(
                                              'Amount Left',
                                              style: TextStyle(
                                                color: Colors.black38,
                                                fontWeight: FontWeight.bold,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.025,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0, vertical: 6),
                                            child: Text(
                                              'Performance',
                                              style: TextStyle(
                                                color: Colors.black38,
                                                fontWeight: FontWeight.bold,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.025,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Text(
                                              '₹$balance_of_the_month_pf_value',
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.bold,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.025,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Text(
                                              '${pf_score}',
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.bold,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.025,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        // height: ,
                                        child: CustomLinearProcessIndicator(
                                            title: "Needs ",
                                            needprogressValue:
                                                _needprogressValue,
                                            expense_needs_of_the_value:
                                                expense_needs_of_the_value,
                                            needs_of_the_month_value:
                                                needs_of_the_month_value,
                                            color_name: PrimaryColor
                                                .color_bottle_green),
                                      ),
                                      CustomLinearProcessIndicator(
                                          title: "Wants ",
                                          needprogressValue: _wantprogressValue,
                                          expense_needs_of_the_value:
                                              expense_wants_of_the_value,
                                          needs_of_the_month_value:
                                              wants_of_the_month_value,
                                          color_name: PrimaryColor.color_red),
                                      CustomLinearProcessIndicator(
                                          title: "Saving",
                                          needprogressValue:
                                              _savingprogressValue,
                                          expense_needs_of_the_value:
                                              expense_saving_of_the_value,
                                          needs_of_the_month_value:
                                              saving_of_the_month_value,
                                          color_name: PrimaryColor.color_blue),
                                    ],
                                  ),
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextStyle(
                                customtextstyletext: "Recent Transaction",
                                customtextcolor: PrimaryColor.color_black,
                                customtextfontweight: FontWeight.bold,
                                customtextstyle: null,
                                customtextsize: 20),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TransactonOfMonth()));
                              },
                              child: CustomTextStyle(
                                  customtextstyletext: "View all",
                                  customtextcolor: Colors.blueAccent,
                                  customtextfontweight: FontWeight.bold,
                                  customtextstyle: null,
                                  customtextsize: 14),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.479,
                        width: MediaQuery.of(context).size.width,
                        child: transactions.length <= 0
                            ? Center(
                                child: Text(
                                  'No Data',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.025,
                                      color: Colors.black38),
                                ),
                              )
                            : ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: transactions.length,
                                itemBuilder: (BuildContext context, int index) {
                                  int? subcateid = transactions[index]
                                      .transactionsubcategoryindex;
                                  int? categoryid =
                                      transactions[index].transactioncategory;
                                  if (categoryid == 0) {
                                    iconcolor = PrimaryColor.color_bottle_green;
                                  }
                                  if (categoryid == 1) {
                                    iconcolor = PrimaryColor.color_red;
                                  }
                                  if (categoryid == 2) {
                                    iconcolor = PrimaryColor.color_mint_green;
                                  }

                                  String datetimeformat =
                                      "${transactions[index].transactionDate?.toDate().toString()}";
                                  DateTime transaction_datetime =
                                      transactions[index]
                                          .transactionDate!
                                          .toDate();

                                  String datestamp = DateFormat.yMMMd()
                                      .format(transaction_datetime);
                                  String timestamp = DateFormat.jm()
                                      .format(transaction_datetime);
                                  String transaction_date_string =
                                      "$datestamp $timestamp";
                                  return transactions.length == 0
                                      ? Center(
                                          child: Text(
                                            'No Data',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.025,
                                                color: Colors.black38),
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            int? amount = transactions[index]
                                                .transactionAmount;
                                            int? category = transactions[index]
                                                .transactioncategory;
                                            int? subcategory =
                                                transactions[index]
                                                    .transactionsubcategory;
                                            int? subcategoryindex =
                                                transactions[index]
                                                    .transactionsubcategoryindex;
                                            String? id =
                                                transactions[index].tID;
                                            String? note = transactions[index]
                                                .transactionnote;
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        TransactionScreen(
                                                          id: 2,
                                                          transactionId: id,
                                                          transactionNote: note,
                                                          transactionAmount:
                                                              amount,
                                                          tranactionsSubCategoryindex:
                                                              subcategoryindex,
                                                          trasactionDate:
                                                              transaction_date_string,
                                                          tranactionsSubCategory:
                                                              subcategory,
                                                          transactionCategory:
                                                              category,
                                                        )));
                                          },
                                          child: CustomTransaction(
                                              icon_color: iconcolor,
                                              categoryid: categoryid,
                                              subcateid: subcateid,
                                              transaction_amount:
                                                  transactions[index]
                                                      .transactionAmount,
                                              transactionnote:
                                                  transactions[index]
                                                      .transactionnote,
                                              datestamp: datestamp,
                                              timestamp: timestamp));
                                }),
                      ),
                    ]),
              ),
            ),
    );
  }
}
