import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/transaction.dart';
import '../utils/const.dart';
import '../utils/functions.dart';
import '../widgets/build_skeleton.dart';
import '../widgets/custom_transaction.dart';

class TransactonOfMonth extends StatefulWidget {
  const TransactonOfMonth({super.key});

  @override
  State<TransactonOfMonth> createState() => _TransactonOfMonthState();
}

class _TransactonOfMonthState extends State<TransactonOfMonth> {
  bool _isloading = false;
  static List<AllTransactionDetails> curentmonthtransactions = [];
  String? uid;

  Future<void> getAllTransaction() async {
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
        _isloading = false;
      });
    } catch (e) {
      setState(() {
        _isloading = false;
      });
      print(e);
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
    final brightness = MediaQuery.of(context).platformBrightness;
    Color iconcolor = PrimaryColor.color_bottle_green;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.secondary),
        title: Text(
          'Monthly Transaction',
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        elevation: 5,
        backgroundColor: Theme.of(context).bottomAppBarColor,
      ),
      body: _isloading == true
          ? const Center(child: CircularProgressIndicator())
          : curentmonthtransactions.length <= 0
              ? Center(
                  child: Text(
                    'No Data',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.height * 0.025,
                        color: Colors.black38),
                  ),
                )
              : Container(
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: curentmonthtransactions.length,
                        itemBuilder: (BuildContext context, int index) {
                          DateTime transaction_datetime =
                              curentmonthtransactions[index]
                                  .transactionDate!
                                  .toDate();
                          String datestamp =
                              DateFormat.yMMMd().format(transaction_datetime);
                          String timestamp =
                              DateFormat.jm().format(transaction_datetime);
                          int? subcateid = curentmonthtransactions[index]
                              .transactionsubcategoryindex;
                          int? categoryid = curentmonthtransactions[index]
                              .transactioncategory;
                          if (categoryid == 0) {
                            iconcolor = PrimaryColor.color_bottle_green;
                          }
                          if (categoryid == 1) {
                            iconcolor = PrimaryColor.color_red;
                          }
                          if (categoryid == 2) {
                            iconcolor = PrimaryColor.color_bottle_green;
                          }
                          return curentmonthtransactions.length == 0
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
                                  theme_color: Theme.of(context).colorScheme.primary,
                                  text_theme: Theme.of(context).colorScheme.secondary,
                                  icon_color: iconcolor,
                                  categoryid: categoryid,
                                  subcateid: subcateid,
                                  transaction_amount:
                                      curentmonthtransactions[index]
                                          .transactionAmount,
                                  transactionnote:
                                      curentmonthtransactions[index]
                                          .transactionnote,
                                  datestamp: datestamp,
                                  timestamp: timestamp);
                        }),
                  ),
                ),
    );
  }
}
