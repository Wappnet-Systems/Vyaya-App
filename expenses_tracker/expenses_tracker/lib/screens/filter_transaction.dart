import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/transaction.dart';
import '../utils/const.dart';
import '../utils/validation.dart';
import '../widgets/custom_textstyle.dart';
import '../widgets/custom_transaction.dart';

class FilterTransaction extends StatefulWidget {
  const FilterTransaction({super.key});

  @override
  State<FilterTransaction> createState() => _FilterTransactionState();
}

class _FilterTransactionState extends State<FilterTransaction> {
  int value = 0;
  DateTime? startDate;
  DateTime? endDate;
  String? uid;
  bool _isloading = false;
  Color iconcolor = PrimaryColor.color_bottle_green;
  static List<AllTransactionDetails> curentpagetransactions = [];
  TextEditingController _startdateController = TextEditingController();
  TextEditingController _enddateController = TextEditingController();
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
    curentpagetransactions.clear();
    _startdateController.text =
        DateFormat('MMM dd, yyyy').format(DateTime.now()).toString();
    _enddateController.text =
        DateFormat('MMM dd, yyyy').format(DateTime.now()).toString();
    startDate =
        DateFormat('MMM d, yyyy').parse(_startdateController.text.toString());
    endDate =
        DateFormat('MMM d, yyyy').parse(_enddateController.text.toString());
    getFilterTransaction();
  }

  Future<void> getFilterTransaction() async {
    curentpagetransactions.clear();
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
        curentpagetransactions = transactionData;
        _isloading = false;
      });
    } catch (e) {
      setState(() {
        _isloading = false;
      });
      print(e);
    }
  }

  Future<void> _selectDateTime(BuildContext context, String option) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2023),
        lastDate: DateTime.now(),
        
        builder: (context, child) {
          return Theme(
              
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                
                primary: Theme.of(context).colorScheme.onPrimary,
                onPrimary: Theme.of(context).colorScheme.primary,
                onSurface: PrimaryColor.color_black,
              ),
              primaryTextTheme: TextTheme(),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: PrimaryColor.color_bottle_green,
                ),
              ),
              hintColor: Colors.black38
            ),
            child: child!,
          );
        });
    if (picked != null) {
      if (option == "start") {
        _dateTime = DateTime(picked.year, picked.month, picked.day, 00, 00);
        _startdateController.text =
            DateFormat('MMM dd, yyyy').format(_dateTime).toString();
      } else {
        _dateTime = DateTime(picked.year, picked.month, picked.day, 23, 59);
        _enddateController.text =
            DateFormat('MMM dd, yyyy').format(_dateTime).toString();
      }
      print("_dateTime $_dateTime");
    }
  }

  void FilterTransaction() {
    print("log");
    String s_date = _startdateController.text;
    String e_date = _enddateController.text;
    startDate = DateFormat('MMM d, yyyy').parse(s_date);
    endDate = DateFormat('MMM d, yyyy').parse(e_date);
    if (endDate!.isBefore(startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('End date must be after startDate'),
      ));
    }
    getFilterTransaction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Column(
          children: [
            Text(
              'Transaction History',
              style: TextStyle(
                  decorationColor: Theme.of(context).colorScheme.onPrimary,
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: MediaQuery.of(context).size.height * 0.027),
            ),
            SizedBox(
              height: 05,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.17,
              width: MediaQuery.of(context).size.width,
              child: Form(
                  child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 2,
                          child: TextFormField(
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: MediaQuery.of(context).size.height*0.018,
                            ),
                            readOnly: true,
                            onTap: () {
                              _selectDateTime(context, "start");
                            },
                            controller: _startdateController,
                            validator: textFormFieldValidator,
                            decoration: InputDecoration(
                                labelText: "Satrt Date",
                                labelStyle: TextStyle(
                                    fontSize: 13,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary), //label style

                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                                prefixIcon: Icon(
                                  Icons.calendar_month,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                hintText: "Select Start Date",
                                hintStyle: TextStyle(
                                    color: Theme.of(context).hintColor),
                                prefixIconConstraints: BoxConstraints.tightFor(
                                    height: 25, width: 50)),
                                    
                          ),
                        ),
                        SizedBox(
                          width: 07,
                        ),
                        Flexible(
                          flex: 2,
                          child: TextFormField(
                            cursorColor:
                                Theme.of(context).colorScheme.secondary,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,                              
                                fontSize: MediaQuery.of(context).size.height*0.018,
),
                            readOnly: true,
                            onTap: () {
                              _selectDateTime(context, "end");
                            },
                            controller: _enddateController,
                            validator: textFormFieldValidator,
                            decoration: InputDecoration(
                                labelText: "End Date",
                                labelStyle: TextStyle(
                                    fontSize: 13,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary), //label style

                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                                prefixIcon: Icon(Icons.calendar_month,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                                hintText: "Select End Date",
                                hintStyle: TextStyle(
                                    color: Theme.of(context).hintColor),
                                prefixIconConstraints: BoxConstraints.tightFor(
                                    height: 25, width: 50)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  TextButton(
                      onPressed: () {
                        FilterTransaction();
                      },
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width * 0.99,
                          child: Card(
                              color: PrimaryColor.color_bottle_green,
                              child: Center(
                                  child: Text(
                                "Display Transactions",
                                style: TextStyle(
                                    color: PrimaryColor.color_white,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.018),
                              )))))
                ],
              )),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal : 8.0),
                  child: Text(
                    'Transactions',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: MediaQuery.of(context).size.height * 0.020),
                  ),
                )
              ],
            ),
            Flexible(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: curentpagetransactions.length == 0
                    ? Center(
                        child: Text(
                        "No Data",
                        style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.height * 0.03,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).hintColor,
                        ),
                      ))
                    : SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              primary: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: curentpagetransactions.length,
                              itemBuilder:
                                  (BuildContext context, int index) {
                                int? subcateid =
                                    curentpagetransactions[index]
                                        .transactionsubcategoryindex;
                                int? categoryid =
                                    curentpagetransactions[index]
                                        .transactioncategory;
                                if (categoryid == 0) {
                                  iconcolor =
                                      PrimaryColor.color_bottle_green;
                                }
                                if (categoryid == 1) {
                                  iconcolor = PrimaryColor.color_red;
                                }
                                if (categoryid == 2) {
                                  iconcolor =
                                      PrimaryColor.color_bottle_green;
                                }

                                String datetimeformat =
                                    "${curentpagetransactions[index].transactionDate?.toDate().toString()}";
                                DateTime transaction_datetime =
                                    curentpagetransactions[index]
                                        .transactionDate!
                                        .toDate();

                                String datestamp = DateFormat.yMMMd()
                                    .format(transaction_datetime);
                                String timestamp = DateFormat.jm()
                                    .format(transaction_datetime);
                                String transaction_date_string =
                                    "$datestamp $timestamp";
                                return CustomTransaction(
                                    theme_color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                    icon_color: iconcolor,
                                    categoryid: categoryid,
                                    subcateid: subcateid,
                                    text_theme: Theme.of(context)
                                        .colorScheme
                                        .secondary,
                                    transaction_amount:
                                        curentpagetransactions[index]
                                            .transactionAmount,
                                    transactionnote:
                                        curentpagetransactions[index]
                                            .transactionnote,
                                    datestamp: datestamp,
                                    timestamp: timestamp);
                              }),
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
