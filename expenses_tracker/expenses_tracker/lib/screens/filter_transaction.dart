import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_tracker/utils/validation.dart';
import 'package:expenses_tracker/widgets/custom_no_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../model/localtransaction.dart';
import '../model/transaction.dart';
import '../utils/const.dart';
import '../widgets/transaction_list.dart';

class FilterTransaction extends StatefulWidget {
  const FilterTransaction({super.key});

  @override
  State<FilterTransaction> createState() => _FilterTransactionState();
}

class _FilterTransactionState extends State<FilterTransaction> {
  int value = 0;
  DateTime? _startDate;
  DateTime? _endDate;
  String? uid;
  bool isLoading = false;
  Color iconColor = PrimaryColor.colorBottleGreen;
  static List<AllTransactionDetails> currentPageTransactions = [];
  static List<LocalTransaction> betweenDatesTransaction=[];
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final transactionFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    uid = UserData.currentUserId;
    currentPageTransactions.clear();
    startDateController.text =
        DateFormat('MMM dd, yyyy').format(DateTime.now()).toString();
    endDateController.text =
        DateFormat('MMM dd, yyyy').format(DateTime.now()).toString();
    _startDate =
        DateFormat('MMM d, yyyy').parse(startDateController.text.toString());
    _endDate =
        DateFormat('MMM d, yyyy').parse(endDateController.text.toString());
    final tempTransaction= getTransactionsBetweenDates();
    getDateFormat(tempTransaction);
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Transaction History',
              style: TextStyle(
                  decorationColor: Theme.of(context).colorScheme.onPrimary,
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: MediaQuery.sizeOf(context).height * 0.027),
                  textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 05,
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.19,
              width: MediaQuery.of(context).size.width,
              child: Form(
                key: transactionFormKey,
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
                              _selectDateTime(context,true);
                            },
                            controller: startDateController,
                            validator: textFormFieldValidator,
                            decoration: InputDecoration(
                                labelText: "Start Date",
                                labelStyle: TextStyle(
                                    fontSize: ScreenUtil().setSp(13),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                
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
                              _selectDateTime(context,false);
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
                        if(_endDate!.isAfter(_startDate!)){
                          final tempTransaction= getTransactionsBetweenDates();
                          getDateFormat(tempTransaction);
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 10),
            Text(
              'Please Select Start Date Before end Date',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ));
                        }
                        
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal : 8.0),
              child: Row(
                children: [
                  Text(
                    'Transactions',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: MediaQuery.sizeOf(context).height * 0.020),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.of(context).size.width,
                child: currentPageTransactions.isEmpty
                    ? const Center(child: CustomNoData())
                    : SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child:
                          TransactionList(
                transactionList: currentPageTransactions,
              ),                           
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
  
  void getDateFormat(Future<List<LocalTransaction>> tempTransaction) async{
    betweenDatesTransaction= await tempTransaction;
    setState(() {
      currentPageTransactions=betweenDatesTransaction.map((e) => AllTransactionDetails(uId: e.userId, tID: e.tID, transactionDate: Timestamp.fromDate(e.tDateTime), transactionAmount: e.tAmount, transactionCategory: e.tCategory, transactionSubcategory: e.tSubcategory, transactionSubcategoryIndex: e.tSubcategoryIndex, transactionNote: e.tNote, transactionPaymentMode: e.tPaymentMode, transactionCreatedAt: Timestamp.fromDate(e.tCreatedAt))).toList();  
      isLoading = false;
    });
  }

  Future<List<LocalTransaction>> getAllLocalTransactions() async {
    final box = await Hive.openBox<LocalTransaction>('local_transactions');
    final transactions = box.values.toList();
    return transactions;
  }

  Future<List<LocalTransaction>> getTransactionsBetweenDates() async {
      String sDate = startDateController.text;
    String eDate = endDateController.text;
    _startDate = DateFormat('MMM d, yyyy').parse(sDate);
    _endDate = DateFormat('MMM d, yyyy').parse(eDate);
    _startDate= DateTime(_startDate!.year, _startDate!.month, _startDate!.day);
    _endDate= DateTime(_endDate!.year, _endDate!.month, _endDate!.day, 23, 59, 59);
  final transactions = await getAllLocalTransactions();
  
  final filteredTransactions = transactions.where((transaction) {
    final transactionDate = transaction.tDateTime;
    return transactionDate.isAfter(_startDate!) && transactionDate.isBefore(_endDate!) && UserData.currentUserId == transaction.userId;
  }).toList();

  filteredTransactions.sort((a, b) => a.tDateTime.compareTo(b.tDateTime));

  return filteredTransactions;
}
  
  Future<void> _selectDateTime(BuildContext context, bool isStartDate) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: isStartDate ?DateTime(2023) :_startDate!,
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
      setState((){
        if (isStartDate) {
        _startDate = DateTime(picked.year, picked.month, picked.day, 00, 00);
        startDateController.text =
            DateFormat('MMM dd, yyyy').format(_startDate!).toString();
      } else {
        _endDate = DateTime(picked.year, picked.month, picked.day, 23, 59);
        endDateController.text =
            DateFormat('MMM dd, yyyy').format(_endDate!).toString();
      }

      });
      
    }
  }  
}
