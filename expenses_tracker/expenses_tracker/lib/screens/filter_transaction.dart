import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/localtransaction.dart';
import '../model/transaction.dart';
import '../utils/const.dart';
import '../utils/functions.dart';
import '../utils/validation.dart';
import '../widgets/custom_no_data.dart';
import '../widgets/transaction_list.dart';

enum TransactionCategory { all, income, expenses }

enum TransactionPaymentOption { all, cash, bank, credit, upi }

TransactionPaymentOption selectedPaymentOption = TransactionPaymentOption.all;
TransactionCategory selectedCategory = TransactionCategory.all;

class FilterTransaction extends StatefulWidget {
  const FilterTransaction({super.key});

  @override
  State<FilterTransaction> createState() => _FilterTransactionState();
}

class _FilterTransactionState extends State<FilterTransaction> {
  DateTime? _startDate;
  DateTime? _endDate;
  String? uid;
  bool isLoading = false;
  int? categoryTypeValue;
  static List<AllTransactionDetails> currentPageTransactions = [];
  static List<LocalTransaction> betweenDatesTransaction = [];
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController greaterAmountController =TextEditingController();
  final TextEditingController lesserAmountController =TextEditingController();
  final transactionFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    uid = UserData.currentUserId;
    categoryTypeValue =1;
    currentPageTransactions.clear();
    greaterAmountController.text="0";
    lesserAmountController.text="5000";
    startDateController.text =
        DateFormat('MMM dd, yyyy').format(DateTime.now()).toString();
    endDateController.text =
        DateFormat('MMM dd, yyyy').format(DateTime.now()).toString();
    _startDate =
        DateFormat('MMM d, yyyy').parse(startDateController.text.toString());
    _endDate =
        DateFormat('MMM d, yyyy').parse(endDateController.text.toString());
    final tempTransaction = getTransactionsBetweenDates();
    getDateFormat(tempTransaction);
  }

  Future<void> _selectDateTime(BuildContext context, bool isStartDate) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: isStartDate ? DateTime(2023) : _startDate!,
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
                hintColor: Colors.black38),
            child: child!,
          );
        });

    if (picked != null) {
      setState(() {
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

  void getDateFormat(Future<List<LocalTransaction>> tempTransaction) async {
    betweenDatesTransaction = await tempTransaction;
    setState(() {
      currentPageTransactions = betweenDatesTransaction
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
      isLoading = false;
    });
  }

  Future<List<LocalTransaction>> getTransactionsBetweenDates() async {
    String sDate = startDateController.text;
    String eDate = endDateController.text;
    int greaterAmount= int.parse(greaterAmountController.text);
    int lesserAmount= int.parse(lesserAmountController.text); 
    _startDate = DateFormat('MMM d, yyyy').parse(sDate);
    _endDate = DateFormat('MMM d, yyyy').parse(eDate);
    _startDate = DateTime(_startDate!.year, _startDate!.month, _startDate!.day);
    _endDate =
        DateTime(_endDate!.year, _endDate!.month, _endDate!.day, 23, 59, 59);
    final transactions = await getAllLocalTransactions();

    final filteredTransactions = transactions.where((transaction) {
      // const transactionGreaterAmount=0;
      // const transactionLesserAmount=5000;
      final transactionDate = transaction.tDateTime;
      return transactionDate.isAfter(_startDate!) &&
          transactionDate.isBefore(_endDate!) &&
          greaterAmount<transaction.tAmount &&
          lesserAmount>transaction.tAmount &&
          UserData.currentUserId == transaction.userId;
    }).toList();

    filteredTransactions.sort((a, b) => a.tDateTime.compareTo(b.tDateTime));

    return filteredTransactions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: MediaQuery.of(context).size.width < 600
          ? _buildMobileTabletView()
          : _buildDesktopLargeScreenView(),
    );
  }

  Widget _buildMobileTabletView() {
    return Container(
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
                                fontSize:
                                    MediaQuery.sizeOf(context).height * 0.018,
                              ),
                              readOnly: true,
                              onTap: () {
                                _selectDateTime(context, true);
                              },
                              controller: startDateController,
                              validator: textFormFieldValidator,
                              decoration: InputDecoration(
                                  labelText: "Start Date",
                                  labelStyle: TextStyle(
                                      fontSize:
                                          MediaQuery.sizeOf(context).height *
                                              0.018,
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
                                  prefixIconConstraints:
                                      const BoxConstraints.tightFor(
                                          height: 25, width: 50)),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.01,
                          ),
                          Flexible(
                            flex: 2,
                            child: TextFormField(
                              cursorColor:
                                  Theme.of(context).colorScheme.secondary,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize:
                                    MediaQuery.sizeOf(context).height * 0.018,
                              ),
                              readOnly: true,
                              onTap: () {
                                _selectDateTime(context, false);
                              },
                              controller: endDateController,
                              validator: textFormFieldValidator,
                              decoration: InputDecoration(
                                  labelText: "End Date",
                                  labelStyle: TextStyle(
                                      fontSize:
                                          MediaQuery.sizeOf(context).height *
                                              0.018,
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
                                  prefixIconConstraints:
                                      const BoxConstraints.tightFor(
                                          height: 25, width: 50)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          if (_endDate!.isAfter(_startDate!)) {
                            final tempTransaction =
                                getTransactionsBetweenDates();
                            getDateFormat(tempTransaction);
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
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
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                      child: TransactionList(
                        transactionList: currentPageTransactions,
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDesktopLargeScreenView() {
    // double? amountGreater=0;
    // double? amountLesser=5000;

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Expanded(
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width / 4,
          height: MediaQuery.sizeOf(context).height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.018,
                ),
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
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: Form(
                      key: transactionFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.01,
                          ),
                          Text(
                            "Duration",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.02),
                          TextFormField(
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize:
                                  MediaQuery.sizeOf(context).height * 0.018,
                            ),
                            readOnly: true,
                            onTap: () {
                              _selectDateTime(context, true);
                            },
                            controller: startDateController,
                            validator: textFormFieldValidator,
                            decoration: InputDecoration(
                                labelText: "Start Date",
                                labelStyle: TextStyle(
                                    fontSize:
                                        MediaQuery.sizeOf(context).height *
                                            0.018,
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
                                prefixIconConstraints:
                                    const BoxConstraints.tightFor(
                                        height: 25, width: 50)),
                          ),
                          SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.02),
                          TextFormField(
                            cursorColor:
                                Theme.of(context).colorScheme.secondary,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize:
                                  MediaQuery.sizeOf(context).height * 0.018,
                            ),
                            readOnly: true,
                            onTap: () {
                              _selectDateTime(context, false);
                            },
                            controller: endDateController,
                            validator: textFormFieldValidator,
                            decoration: InputDecoration(
                                labelText: "End Date",
                                labelStyle: TextStyle(
                                    fontSize:
                                        MediaQuery.sizeOf(context).height *
                                            0.018,
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
                                prefixIconConstraints:
                                    const BoxConstraints.tightFor(
                                        height: 25, width: 50)),
                          ),
                          SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.02),
                          Text(
                            "Amount",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.02),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: greaterAmountController,
                            
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize:
                                  MediaQuery.sizeOf(context).height * 0.018,
                            ),
                            onChanged: (value) {
                              if (value.isEmpty) {
                              } else {
                                greaterAmountController.text = value;
                              }
                            },
                            decoration: InputDecoration(
                              labelText: "Amount Greater Than",
                              labelStyle: TextStyle(
                                fontSize:
                                    MediaQuery.sizeOf(context).height * 0.018,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              hintText: "Enter Amount",
                              
                              hintStyle:
                                  TextStyle(color: Theme.of(context).hintColor),
                              prefixIcon: Icon(
                                Icons.filter_list,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              prefixIconConstraints:
                                  const BoxConstraints.tightFor(
                                height: 25,
                                width: 50,
                              ),
                            ),
                          ),
                          SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.02),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: lesserAmountController,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize:
                                  MediaQuery.sizeOf(context).height * 0.018,
                            ),
                            onChanged: (value) {
                              // if (value.isEmpty) {
                              //   amountLesser = null;
                              // } else {
                              //   amountLesser = double.tryParse(value);
                              // }
                            },
                            decoration: InputDecoration(
                              labelText: "Amount Less Than",
                              labelStyle: TextStyle(
                                fontSize:
                                    MediaQuery.sizeOf(context).height * 0.018,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              hintText: "Enter Amount",
                              hintStyle:
                                  TextStyle(color: Theme.of(context).hintColor),
                              prefixIcon: Icon(
                                Icons.filter_list,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              prefixIconConstraints:
                                  const BoxConstraints.tightFor(
                                height: 25,
                                width: 50,
                              ),
                            ),
                          ),
                          SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.02),
                          Text(
                            "Category",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary),
                            textAlign: TextAlign.left,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile<TransactionCategory>(
                                  activeColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                  selectedTileColor:
                                      Theme.of(context).colorScheme.secondary,
                                  title: Text('All',
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary)),
                                  value: TransactionCategory.all,
                                  groupValue: selectedCategory,
                                  onChanged: (TransactionCategory? value) {
                                    setState(() {
                                      selectedCategory = value!;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<TransactionCategory>(
                                  activeColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                  selectedTileColor:
                                      Theme.of(context).colorScheme.secondary,
                                  title: Text('Income',
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary)),
                                  value: TransactionCategory.income,
                                  groupValue: selectedCategory,
                                  onChanged: (TransactionCategory? value) {
                                    setState(() {
                                      selectedCategory = value!;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<TransactionCategory>(
                                  activeColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                  selectedTileColor:
                                      Theme.of(context).colorScheme.secondary,
                                  title: Text('Expenses',
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary)),
                                  value: TransactionCategory.expenses,
                                  groupValue: selectedCategory,
                                  onChanged: (TransactionCategory? value) {
                                    setState(() {
                                      selectedCategory = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.02),
                          Text(
                            "Subcategory",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary),
                            textAlign: TextAlign.left,
                          ),
                          selectedCategory == TransactionCategory.all
                              ? Column(
                                children: [
                                  ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: ListOfAppData.listOfCategory.length,
                                      itemBuilder: (context, index) {
                                        return CheckboxListTile(
                                          activeColor: PrimaryColor.colorBottleGreen,
                                    checkColor:
                                        Theme.of(context).colorScheme.primary,
                                          title: Text('${ListOfAppData.listOfCategory[index].categoryText}'),
                                          value:ListOfAppData.listOfCategory[index].isSelected, 
                                          onChanged: (bool? value) {
                                            setState(() {
                                              ListOfAppData.listOfCategory[index].isSelected= !ListOfAppData.listOfCategory[index].isSelected!;  
                                            });                                            
                                          },
                                        );
                                      }),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: ListOfAppData.listOfIncome.length,
                                      itemBuilder: (context, index) {
                                        return CheckboxListTile(
                                          activeColor: PrimaryColor.colorBottleGreen,
                                    checkColor:
                                        Theme.of(context).colorScheme.primary,
                                          title: Text('${ListOfAppData.listOfIncome[index].categoryText}'),
                                          value:ListOfAppData.listOfIncome[index].isSelected, 
                                          onChanged: (bool? value) {
                                            setState(() {
                                              ListOfAppData.listOfIncome[index].isSelected=!ListOfAppData.listOfIncome[index].isSelected!;  
                                            });                                            
                                          },
                                        );
                                      }),
                                ],
                              )
                              : selectedCategory == TransactionCategory.expenses
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: ListOfAppData.listOfCategory.length,
                                      itemBuilder: (context, index) {
                                        return CheckboxListTile(
                                          activeColor: PrimaryColor.colorBottleGreen,
                                    checkColor:
                                        Theme.of(context).colorScheme.primary,
                                          title: Text('${ListOfAppData.listOfCategory[index].categoryText}'),
                                          value:ListOfAppData.listOfCategory[index].isSelected, 
                                          onChanged: (bool? value) {
                                            setState(() {
                                              ListOfAppData.listOfCategory[index].isSelected= !ListOfAppData.listOfCategory[index].isSelected!;  
                                            });                                            
                                          },
                                        );
                                      })
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: ListOfAppData.listOfIncome.length,
                                      itemBuilder: (context, index) {
                                        return CheckboxListTile(
                                          activeColor: PrimaryColor.colorBottleGreen,
                                    checkColor:
                                        Theme.of(context).colorScheme.primary,
                                          title: Text('${ListOfAppData.listOfIncome[index].categoryText}'),
                                          value:ListOfAppData.listOfIncome[index].isSelected, 
                                          onChanged: (bool? value) {
                                            setState(() {
                                              ListOfAppData.listOfIncome[index].isSelected=!ListOfAppData.listOfIncome[index].isSelected!;  
                                            });                                            
                                          },
                                        );
                                      }),
                          SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.02),
                          Text(
                            "Payment option",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary),
                            textAlign: TextAlign.left,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile<TransactionPaymentOption>(
                                  activeColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                  selectedTileColor:
                                      Theme.of(context).colorScheme.secondary,
                                  title: Text('All',
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary)),
                                  value: TransactionPaymentOption.all,
                                  groupValue: selectedPaymentOption,
                                  onChanged: (TransactionPaymentOption? value) {
                                    setState(() {
                                      selectedPaymentOption = value!;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<TransactionPaymentOption>(
                                  activeColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                  selectedTileColor:
                                      Theme.of(context).colorScheme.secondary,
                                  title: Text('Cash',
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary)),
                                  value: TransactionPaymentOption.cash,
                                  groupValue: selectedPaymentOption,
                                  onChanged: (TransactionPaymentOption? value) {
                                    setState(() {
                                      selectedPaymentOption = value!;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<TransactionPaymentOption>(
                                  activeColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                  selectedTileColor:
                                      Theme.of(context).colorScheme.secondary,
                                  title: Text('Bank',
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary)),
                                  value: TransactionPaymentOption.bank,
                                  groupValue: selectedPaymentOption,
                                  onChanged: (TransactionPaymentOption? value) {
                                    setState(() {
                                      selectedPaymentOption = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: RadioListTile<TransactionPaymentOption>(
                                  activeColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                  selectedTileColor:
                                      Theme.of(context).colorScheme.secondary,
                                  title: Text('Credit/Debit Card',
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary)),
                                  value: TransactionPaymentOption.credit,
                                  groupValue: selectedPaymentOption,
                                  onChanged: (TransactionPaymentOption? value) {
                                    setState(() {
                                      selectedPaymentOption = value!;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<TransactionPaymentOption>(
                                  activeColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                  selectedTileColor:
                                      Theme.of(context).colorScheme.secondary,
                                  title: Text('UPI',
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary)),
                                  value: TransactionPaymentOption.upi,
                                  groupValue: selectedPaymentOption,
                                  onChanged: (TransactionPaymentOption? value) {
                                    setState(() {
                                      selectedPaymentOption = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.02),
                          TextButton(
                              onPressed: () {
                                if (_endDate!.isAfter(_startDate!)) {
                                  final tempTransaction =
                                      getTransactionsBetweenDates();
                                  getDateFormat(tempTransaction);
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
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
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.06,
                                  width: MediaQuery.of(context).size.width * 1,
                                  child: Card(
                                      color: PrimaryColor.colorBottleGreen,
                                      child: Center(
                                          child: Text(
                                        "Display Transactions",
                                        style: TextStyle(
                                            color: PrimaryColor.colorWhite,
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.sizeOf(context)
                                                    .height *
                                                0.018),
                                      )))))
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
      const VerticalDivider(thickness: 1, width: 1),
      Expanded(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.of(context).size.width,
          child: currentPageTransactions.isEmpty
              ? const Center(child: CustomNoData())
              : SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 04, vertical: 05),
                  scrollDirection: Axis.vertical,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: TransactionList(
                    transactionList: currentPageTransactions,
                  ),
                ),
        ),
      ),
    ]);
  }

  Widget _buildDateRangePicker() {
    // Replace this with your date range picker implementation
    return const Text('Date Range Picker');
  }

  Widget _buildFilterOptions() {
    // Replace this with your filter options implementation
    return const Text('Filter Options');
  }

  Widget _buildApplyButton() {
    return ElevatedButton(
      onPressed: () {},
      child: const Text('Apply Filters'),
    );
  }

  Widget _buildResultSection() {
    // Replace this with your result section implementation
    return const Text('Filtered Results');
  }
}
