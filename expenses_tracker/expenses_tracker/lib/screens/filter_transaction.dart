import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../model/localtransaction.dart';
import '../model/transaction.dart';
import '../utils/const.dart';
import '../utils/validation.dart';
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
  bool isLoading = false;
  Color iconColor = PrimaryColor.colorBottleGreen;
  static List<AllTransactionDetails> currentPageTransactions = [];
  static List<LocalTransaction> betweenDatesTransaction=[];
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
    currentPageTransactions.clear();
    startDateController.text =
        DateFormat('MMM dd, yyyy').format(DateTime.now()).toString();
    endDateController.text =
        DateFormat('MMM dd, yyyy').format(DateTime.now()).toString();
    startDate =
        DateFormat('MMM d, yyyy').parse(startDateController.text.toString());
    endDate =
        DateFormat('MMM d, yyyy').parse(endDateController.text.toString());
    final tempTransaction= getTransactionsBetweenDates();
    getDataFormated(tempTransaction);
    // getFilterTransaction();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Column(
          children: [
            Text(
              'Transaction History',
              style: TextStyle(
                  decorationColor: Theme.of(context).colorScheme.onPrimary,
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: MediaQuery.sizeOf(context).height * 0.027),
            ),
            const SizedBox(
              height: 05,
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.19,
              width: MediaQuery.of(context).size.width,
              child: Form(
                  child: Column(
                children: [
                  const SizedBox(
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
                              fontSize: ScreenUtil().setSp(15),
                            ),
                            readOnly: true,
                            onTap: () {
                              _selectDateTime(context, "start");
                            },
                            controller: startDateController,
                            validator: textFormFieldValidator,
                            decoration: InputDecoration(
                                labelText: "Start Date",
                                labelStyle: TextStyle(
                                    fontSize: ScreenUtil().setSp(13),
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
                                prefixIconConstraints: const BoxConstraints.tightFor(
                                    height: 25, width: 50)),
                                    
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().screenWidth/25,
                        ),
                        Flexible(
                          flex: 2,
                          child: TextFormField(
                            cursorColor:
                                Theme.of(context).colorScheme.secondary,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,                              
                                fontSize: ScreenUtil().setSp(15)),
                            readOnly: true,
                            onTap: () {
                              _selectDateTime(context, "end");
                            },
                            controller: endDateController,
                            validator: textFormFieldValidator,
                            decoration: InputDecoration(
                                labelText: "End Date",
                                labelStyle: TextStyle(
                                    fontSize: ScreenUtil().setSp(13),
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
                                prefixIconConstraints: const BoxConstraints.tightFor(
                                    height: 25, width: 50)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  TextButton(
                      onPressed: () {
                        final tempTransaction= getTransactionsBetweenDates();
                        getDataFormated(tempTransaction);
                        // filterTransaction();
                      },
                      child: SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.06,
                          width: MediaQuery.of(context).size.width * 0.99,
                          child: Card(
                              color: PrimaryColor.colorBottleGreen,
                              child: Center(
                                  child: Text(
                                "Display Transactions",
                                style: TextStyle(
                                    color: PrimaryColor.colorWhite,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.sizeOf(context).height *
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
                        fontSize: MediaQuery.sizeOf(context).height * 0.020),
                  ),
                )
              ],
            ),
            Flexible(
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.of(context).size.width,
                child: currentPageTransactions.isEmpty
                    ? Center(
                        child: Text(
                        "No Data",
                        style: TextStyle(
                          fontSize:
                              MediaQuery.sizeOf(context).height * 0.03,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).hintColor,
                        ),
                      ))
                    : SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              primary: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: currentPageTransactions.length,
                              itemBuilder:
                                  (BuildContext context, int index) {
                                int? subCateId =
                                    currentPageTransactions[index]
                                        .transactionSubcategoryIndex;
                                int? categoryId =
                                    currentPageTransactions[index]
                                        .transactionCategory;
                                if (categoryId == 0) {
                                  iconColor =
                                      PrimaryColor.colorBottleGreen;
                                }
                                if (categoryId == 1) {
                                  iconColor = PrimaryColor.colorRed;
                                }
                                if (categoryId == 2) {
                                  iconColor =
                                      PrimaryColor.colorBottleGreen;
                                }                              
                                DateTime transactionDateTime =
                                    currentPageTransactions[index]
                                        .transactionDate!
                                        .toDate();

                                String dateStamp = DateFormat.yMMMd()
                                    .format(transactionDateTime);
                                String timeStamp = DateFormat.jm()
                                    .format(transactionDateTime);
                                
                                return CustomTransaction(
                                    themeColor: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                    iconColor: iconColor,
                                    categoryId: categoryId,
                                    subCateId: subCateId,
                                    textTheme: Theme.of(context)
                                        .colorScheme
                                        .secondary,
                                    transactionAmount:
                                        currentPageTransactions[index]
                                            .transactionAmount,
                                    transactionNote:
                                        currentPageTransactions[index]
                                            .transactionNote,
                                    dateStamp: dateStamp,
                                    timeStamp: timeStamp);
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
  void getDataFormated(Future<List<LocalTransaction>> tempTransaction) async{
    betweenDatesTransaction= await tempTransaction;
    setState(() {
      currentPageTransactions=betweenDatesTransaction.map((e) => AllTransactionDetails(uId: e.userId, tID: e.tID, transactionDate: Timestamp.fromDate(e.tDateTime), transactionAmount: e.tAmount, transactionCategory: e.tCategory, transactionSubcategory: e.tSubcategory, transactionSubcategoryIndex: e.tSubcategoryIndex, transactionNote: e.tNote, transactionPaymentMode: e.tPaymentMode, transactionCreatedAt: Timestamp.fromDate(e.tCreatedAt))).toList();  
      isLoading = false;
    });

  }

  Future<List<LocalTransaction>> getAllLocalTransactions() async {
    final box = await Hive.openBox<LocalTransaction>('local_transactions');
    final transactions = box.values.toList();
    for (var transaction in transactions) {
      
    }
    return transactions;
  }

  Future<List<LocalTransaction>> getTransactionsBetweenDates() async {
      String sDate = startDateController.text;
    String eDate = endDateController.text;
    startDate = DateFormat('MMM d, yyyy').parse(sDate);
    endDate = DateFormat('MMM d, yyyy').parse(eDate);
    startDate= DateTime(startDate!.year, startDate!.month, startDate!.day);
    endDate= DateTime(endDate!.year, endDate!.month, endDate!.day, 23, 59, 59);
  final transactions = await getAllLocalTransactions();
  
  final filteredTransactions = transactions.where((transaction) {
    final transactionDate = transaction.tDateTime;
    return transactionDate.isAfter(startDate!) && transactionDate.isBefore(endDate!) && UserData.currentUserId == transaction.userId;
  }).toList();

  filteredTransactions.sort((a, b) => a.tDateTime.compareTo(b.tDateTime));

  return filteredTransactions;
}
  Future<void> getFilterTransaction() async {
    currentPageTransactions.clear();
    setState(() {
      isLoading = true;
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
              transactionSubcategoryIndex: doc['transactionSubcategoryIndex'],
              transactionAmount: doc['transactionAmount'],
              transactionCategory: doc['transactionCategory'],
              transactionDate: doc['transactionDate'],
              transactionNote: doc['transactionNote'],
              transactionPaymentMode: doc['transactionPaymentMode'],
              transactionSubcategory: doc['transactionSubcategory'],
              transactionCreatedAt: doc['transactionCreatedAt']))
          .toList();

      setState(() {
        currentPageTransactions = transactionData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
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
                onSurface: PrimaryColor.colorBlack,
              ),
              primaryTextTheme: const TextTheme(),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: PrimaryColor.colorBottleGreen,
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
        startDateController.text =
            DateFormat('MMM dd, yyyy').format(_dateTime).toString();
      } else {
        _dateTime = DateTime(picked.year, picked.month, picked.day, 23, 59);
        endDateController.text =
            DateFormat('MMM dd, yyyy').format(_dateTime).toString();
      }
    }
  }

  void filterTransaction() {
    String sDate = startDateController.text;
    String eDate = endDateController.text;
    startDate = DateFormat('MMM d, yyyy').parse(sDate);
    endDate = DateFormat('MMM d, yyyy').parse(eDate);
    if (endDate!.isBefore(startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('End date must be after startDate'),
      ));
    }
    getFilterTransaction();
  }

}
