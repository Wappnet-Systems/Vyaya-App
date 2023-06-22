import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_tracker/widgets/custom_no_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../model/localtransaction.dart';
import '../model/transaction.dart';
import '../utils/const.dart';

import '../widgets/custom_transaction.dart';

class TransactionOfMonth extends StatefulWidget {
  final int id;
  const TransactionOfMonth({super.key, required this.id});

  @override
  State<TransactionOfMonth> createState() => _TransactionOfMonthState();
}

class _TransactionOfMonthState extends State<TransactionOfMonth> {
  bool isLoading = false;
  static List<AllTransactionDetails> currentMonthTransactions = [];
  static List<LocalTransaction> transactionOfMonth = [];
  String? uid;

  Future<void> getAllTransaction() async {
    // DateTime startDate = DateTime(
    //     CurrentValues.getCurrentYear(), CurrentValues.getCurrentMonth(), 1);
    // DateTime endDate = DateTime(
    //     CurrentValues.getCurrentYear(), CurrentValues.getCurrentMonth() + 1, 1);

    setState(() {
      isLoading = true;
    });
    try {
      final tempTransactionDatatempTransactionData = getTransactionsThisMonth();
      transactionOfMonth = await tempTransactionDatatempTransactionData;
      setState(() {
        currentMonthTransactions = transactionOfMonth
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
        isLoading = false;
      });
      // final snapshot = await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(uid)
      //     .collection('transaction')
      //     .orderBy('transactionDate', descending: true)
      //     .where('transactionDate', isGreaterThanOrEqualTo: startDate)
      //     .where('transactionDate', isLessThanOrEqualTo: endDate)
      //     .get();

      // final transactionData = snapshot.docs
      //     .map((doc) => AllTransactionDetails(
      //         uId: doc["uId"],
      //         tID: doc['tID'],
      //         transactionSubcategoryIndex: doc['transactionSubcategoryIndex'],
      //         transactionAmount: doc['transactionAmount'],
      //         transactionCategory: doc['transactionCategory'],
      //         transactionDate: doc['transactionDate'],
      //         transactionNote: doc['transactionNote'],
      //         transactionPaymentMode: doc['transactionPaymentMode'],
      //         transactionSubcategory: doc['transactionSubcategory'],
      //         transactionCreatedAt: doc['transactionCreatedAt']))
      //     .toList();

      // setState(() {
      //   currentMonthTransactions = transactionData;

      //   isLoading = false;
      // });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
    getAllTransaction();
  }

  @override
  Widget build(BuildContext context) {
    Color iconColor = PrimaryColor.colorBottleGreen;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.secondary),
        title: widget.id==1 ?Text(
          'Monthly Transaction',
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        )
        : widget.id==3 ? Text(
          'Monthly Expenses',
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ):Text(
          'Monthly Income',
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        elevation: 5,
        backgroundColor: Theme.of(context).bottomAppBarTheme.color,
      ),
      body: isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : currentMonthTransactions.isEmpty
              ? const Center(child: CustomNoData())
              : Container(
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: currentMonthTransactions.length,
                        itemBuilder: (BuildContext context, int index) {
                          DateTime transactionDateTime =
                              currentMonthTransactions[index]
                                  .transactionDate!
                                  .toDate();
                          String datestamp =
                              DateFormat.yMMMd().format(transactionDateTime);
                          String timestamp =
                              DateFormat.jm().format(transactionDateTime);
                          int? subCateId = currentMonthTransactions[index]
                              .transactionSubcategoryIndex;
                          int? categoryId = currentMonthTransactions[index]
                              .transactionCategory;
                          if (categoryId == 0) {
                            iconColor = PrimaryColor.colorBottleGreen;
                          }
                          if (categoryId == 1) {
                            iconColor = PrimaryColor.colorRed;
                          }
                          if (categoryId == 2) {
                            iconColor = PrimaryColor.colorBottleGreen;
                          }
                          return currentMonthTransactions.isEmpty
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
                              : CustomTransaction(
                                  themeColor:
                                      Theme.of(context).colorScheme.primary,
                                  textTheme:
                                      Theme.of(context).colorScheme.secondary,
                                  iconColor: iconColor,
                                  categoryId: categoryId,
                                  subCateId: subCateId,
                                  transactionAmount:
                                      currentMonthTransactions[index]
                                          .transactionAmount,
                                  transactionNote:
                                      currentMonthTransactions[index]
                                          .transactionNote,
                                  dateStamp: datestamp,
                                  timeStamp: timestamp);
                        }),
                  ),
                ),
    );
  }

  Future<List<LocalTransaction>> getAllLocalTransactions() async {
    final box = await Hive.openBox<LocalTransaction>('local_transactions');
    final transactions = box.values.toList();
    return transactions;
  }

  Future<List<LocalTransaction>> getTransactionsThisMonth() async {
    final transactions = await getAllLocalTransactions();

    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;

    final transactionsThisMonth = transactions.where((transaction) {
      final transactionDate = transaction.tDateTime;
      if (widget.id == 2) {
        return transactionDate.month == currentMonth &&
            transactionDate.year == currentYear &&
            UserData.currentUserId == transaction.userId &&
            transaction.tCategory == 3 || transaction.tCategory == 0;
      }
      else if(widget.id == 3){
        return transactionDate.month == currentMonth &&
            transactionDate.year == currentYear &&
            UserData.currentUserId == transaction.userId &&
            transaction.tCategory == 1;

      }
       else {
        return transactionDate.month == currentMonth &&
            transactionDate.year == currentYear &&
            UserData.currentUserId == transaction.userId;
      }
    }).toList();

    transactionsThisMonth.sort((a, b) => b.tDateTime.compareTo(a.tDateTime));

    return transactionsThisMonth;
  }
}
