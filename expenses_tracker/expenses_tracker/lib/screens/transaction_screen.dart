import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_tracker/screens/home_screen.dart';
import 'package:expenses_tracker/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../model/localtransaction.dart';
import '../utils/const.dart';
import '../widgets/custom_text_style.dart';
import 'category_list.dart';

class TransactionScreen extends StatefulWidget {
  final int? id;
  final String? transactionId, transactionNote, transactionDate;
  final int? transactionAmount,
      transactionCategory,
      transactionSubcategory,
      transactionSubcategoryIndex;

  const TransactionScreen(
      {super.key,
      required this.id,
      this.transactionId,
      this.transactionAmount,
      this.transactionNote,
      this.transactionSubcategoryIndex,
      this.transactionCategory,
      this.transactionDate,
      this.transactionSubcategory});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  int value = 0;
  
  String? userId,
      transactionCategory,
      transactionDate,
      transactionAmount,
      transactionSubcategory,
      transactionPaymentMode,
      transactionNote;
  TextEditingController amountController = TextEditingController();
  TextEditingController setDateController = TextEditingController();
  TextEditingController expensesCategoryController = TextEditingController();
  TextEditingController incomeCategoryController = TextEditingController();
  TextEditingController paymentModeController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  GlobalKey<FormState> transactionFormGlobalKey = GlobalKey<FormState>();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  DateTime _dateTime = DateTime.now();

  Icon? prefixIcon;
  int? subcategoryIndex;
  int? subcategory;
  int? categoryIndex;
  int? personalFinanceCategory;
  bool _isChecked = true;

  @override
  void initState() {
    super.initState();
    userId = UserData.currentUserId;
    if (widget.id == 1) {
      setDateController.text =
          DateFormat('MMM dd, yyyy hh:mm a').format(DateTime.now()).toString();
      paymentModeController.text = "Cash";
      expensesCategoryController.text = "others";
      incomeCategoryController.text = "others";
      prefixIcon = Icon(
        Icons.more_horiz,
        color: PrimaryColor.colorWhite,
        size: 30,
      );
      subcategoryIndex = 0;
      categoryIndex = 1;
      subcategory = 0;
      personalFinanceCategory = 1;
    } else {
      amountController.text = widget.transactionAmount.toString();
      noteController.text = widget.transactionNote.toString();
      paymentModeController.text = "Cash";
      setDateController.text = widget.transactionDate!;
      subcategory = widget.transactionSubcategory;
      personalFinanceCategory = 1;
      categoryIndex = widget.transactionCategory;
            
      if (widget.transactionCategory == 1) {
        value = widget.transactionCategory! - 1;
        incomeCategoryController.text = ListOfAppData
            .listOfCategory[widget.transactionSubcategoryIndex!].categoryText!;
        prefixIcon = ListOfAppData
            .listOfCategory[widget.transactionSubcategoryIndex!].categoryIcon;
      } else {
        value = widget.transactionCategory! - 2;
        expensesCategoryController.text = ListOfAppData
            .listOfIncome[widget.transactionSubcategoryIndex!].categoryText!;
        prefixIcon = ListOfAppData
            .listOfIncome[widget.transactionSubcategoryIndex!].categoryIcon;
      }
      subcategoryIndex = widget.transactionSubcategoryIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: PrimaryColor.colorBottleGreen,
        iconTheme: IconThemeData(color: PrimaryColor.colorWhite),
        title: widget.id == 1
            ? Text(
                'Add Transaction',
                style: TextStyle(color: PrimaryColor.colorWhite),
              )
            : Text(
                'Update Transaction',
                style: TextStyle(color: PrimaryColor.colorWhite),
              ),
        elevation: 5,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width/2.5,
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          value = 0;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        side: BorderSide(
                            color: (value == 0)
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.secondary),
                      ),
                      child: Text(
                        "Expenses",
                        style: TextStyle(
                          color: (value == 0)
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.02,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width/2.5,
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          value = 1;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        side: BorderSide(
                            color: (value == 1)
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.secondary),
                      ),
                      child: Text(
                        "Income",
                        style: TextStyle(
                          color: (value == 1)
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: transactionFormGlobalKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            color: PrimaryColor.colorBottleGreen,
                            child: Container(
                                padding: const EdgeInsets.all(6),
                                child: Icon(
                                  Icons.calendar_month,
                                  color: PrimaryColor.colorWhite,
                                  size: 20,
                                ))),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: TextFormField(
                            readOnly: true,
                            onTap: () {
                              _selectDateTime(context);
                            },
                            controller: setDateController,
                            validator: textFormFieldValidator,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary),
                            decoration: InputDecoration(
                              hintStyle:
                                  TextStyle(color: Theme.of(context).hintColor),
                              hintText: "Enter Date",
                              prefixIconConstraints:
                                  const BoxConstraints.tightFor(
                                      height: 05, width: 35),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary, // Change this to your desired border color
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimary, // Change this to your desired border color
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            color: PrimaryColor.colorBottleGreen,
                            child: Container(
                                padding: const EdgeInsets.all(6),
                                child: Icon(
                                  Icons.calculate,
                                  color: PrimaryColor.colorWhite,
                                  size: 20,
                                ))),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            cursorColor:
                                Theme.of(context).colorScheme.onPrimary,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary),
                            enableInteractiveSelection: false,
                            controller: amountController,
                            
                            validator: amountValidator,
                            decoration: InputDecoration(
                              hintText: "Enter Amount",
                              prefixIconConstraints:
                                  const BoxConstraints.tightFor(
                                      height: 05, width: 35),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          color: PrimaryColor.colorBottleGreen,
                          child: Container(child: prefixIcon),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        value == 1
                            ? Flexible(
                                child: InkWell(
                                  onTap: () {},
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        validator: textFormFieldValidator,
                                        onTap: () {
                                          navigate(context, 0);
                                        },
                                        readOnly: true,
                                        controller: expensesCategoryController,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                        decoration: InputDecoration(
                                          suffixIcon:
                                              const Icon(Icons.chevron_right),
                                          prefixIconConstraints:
                                              const BoxConstraints.tightFor(
                                                  height: 05, width: 35),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Flexible(
                                child: InkWell(
                                  onTap: () {},
                                  child: TextFormField(
                                    validator: textFormFieldValidator,
                                    onTap: () {
                                      navigate(context, 1);
                                    },
                                    readOnly: true,
                                    controller: incomeCategoryController,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                    decoration: InputDecoration(
                                      suffixIcon:
                                          const Icon(Icons.chevron_right),
                                      prefixIconConstraints:
                                          const BoxConstraints.tightFor(
                                              height: 05, width: 35),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            color: PrimaryColor.colorBottleGreen,
                            child: Container(
                                padding: const EdgeInsets.all(6),
                                child: Icon(
                                  Icons.money,
                                  color: PrimaryColor.colorWhite,
                                  size: 20,
                                ))),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: InkWell(
                            onTap: () {},
                            child: TextFormField(
                              readOnly: true,
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                              validator: textFormFieldValidator,
                              keyboardType: TextInputType.number,
                              controller: paymentModeController,
                              decoration: InputDecoration(
                                suffixIcon: const Icon(Icons.chevron_right),
                                prefixIconConstraints:
                                    const BoxConstraints.tightFor(
                                        height: 05, width: 35),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    value == 1
                        ? Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                            child: Row(
                              children: [
                                Checkbox(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  ),
                                  side: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                          activeColor: PrimaryColor.colorBottleGreen,
                                  checkColor:
                                      Theme.of(context).colorScheme.primary,
                                  value: _isChecked,
                                  onChanged: (bool? newValue) {
                                    _isChecked = newValue!;

                                    setState(() {});
                                  },
                                ),
                                
                                Text(
                                  'Add to Personal Finance Portion',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(
                            height: 0,
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        CustomTextStyle(
                            customTextStyleText: "Other Details",
                            customTextColor:
                                Theme.of(context).colorScheme.secondary,
                            customTextFontWeight: FontWeight.bold,
                            customtextstyle: null,
                            customTextSize: 18.00),
                      ],
                    ),
                    Row(
                      children: [
                        Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            color: PrimaryColor.colorBottleGreen,
                            child: Container(
                                padding: const EdgeInsets.all(6),
                                child: Icon(
                                  Icons.note,
                                  color: PrimaryColor.colorWhite,
                                  size: 20,
                                ))),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: TextFormField(
                            readOnly: false,
                            cursorColor:
                                Theme.of(context).colorScheme.onPrimary,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary),
                            keyboardType: TextInputType.text,
                            maxLength: 20,
                            enableInteractiveSelection: false,
                            controller: noteController,
                            decoration: InputDecoration(
                              hintText: "Description",
                              prefixIconConstraints:
                                  const BoxConstraints.tightFor(
                                      height: 05, width: 35),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: widget.id == 1
          ? FloatingActionButton(
              backgroundColor: PrimaryColor.colorBottleGreen,
              onPressed: addTransaction,
              child: Icon(
                Icons.save,
                color: PrimaryColor.colorWhite,
              ))
          : FloatingActionButton(
              backgroundColor: PrimaryColor.colorBottleGreen,
              onPressed: updateTransaction,
              child: Icon(
                Icons.save,
                color: PrimaryColor.colorWhite,
              )),
    );
  }

  Future<void> navigate(BuildContext context, int id) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CategoryList(id: id)),
    );
    if (!mounted) return;
    int index = int.parse(result);
    int indexForIcon = index;
    setState(() {
      if (id == 0) {
        expensesCategoryController.text =
            ListOfAppData.listOfIncome[index].categoryText!;
        prefixIcon = ListOfAppData.listOfIncome[index].categoryIcon;
        subcategoryIndex = ListOfAppData.listOfIncome[index].categoryIndex;
        subcategory = ListOfAppData.listOfIncome[index].categoryType;
      } else if (id == 1) {
        incomeCategoryController.text =
            ListOfAppData.listOfCategory[index].categoryText!;
        prefixIcon = ListOfAppData.listOfCategory[index].categoryIcon;
        subcategoryIndex =
            ListOfAppData.listOfCategory[indexForIcon].categoryIndex;
        subcategory = ListOfAppData.listOfCategory[index].categoryType;
        categoryIndex = 1;
      } else {
        incomeCategoryController.text =
            ListOfAppData.listOfCategory[index].categoryText!;
        prefixIcon = ListOfAppData.listOfCategory[index].categoryIcon;
        subcategoryIndex =
            ListOfAppData.listOfCategory[indexForIcon].categoryIndex;
        subcategory = ListOfAppData.listOfCategory[index].categoryType;

      }
    });
  }

  Future<void> _selectDateTime(BuildContext context) async {
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
                hintColor: Colors.black38),
            child: child!,
          );
        });
    if (picked != null) {
      final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(_dateTime),
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
      if (time != null) {
        setState(() {
          _dateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
        setDateController.text =
            DateFormat('MMM dd, yyyy hh:mm a').format(_dateTime).toString();
      }
    }
  }

  Future<LocalTransaction> getSingleTransaction(String transactionId) async {
  final box = await Hive.openBox<LocalTransaction>('local_transactions');
  final transaction = box.values
      .firstWhere((transaction) => transaction.tID == transactionId);
  return transaction;
}

Future<void> updateLocalTransaction(LocalTransaction updatedTransaction) async {
  final box = await Hive.openBox<LocalTransaction>('local_transactions');
  final index = box.values.toList().indexWhere((transaction) =>
      transaction.tID == updatedTransaction.tID);
  if (index != -1) {
    await box.putAt(index, updatedTransaction);
  }
}

  void updateTransaction() {
    if (transactionFormGlobalKey.currentState!.validate()) {
      DateTime currentDateTime = DateTime.now();

      if (value == 1) {
        if (_isChecked == true) {
          categoryIndex = 3;
        } else if (_isChecked == false) {
          categoryIndex = 0;
        }
      }
      if(noteController.text.isEmpty){
        noteController.text="-";
      }
      String noteDetail=noteController.text;
      String capitalizedNote=noteDetail[0].toUpperCase() + noteDetail.substring(1);
      transactionNote = capitalizedNote;
      transactionAmount = amountController.text;
      int amountOfMoney = int.parse(transactionAmount!);
      String tID = widget.transactionId.toString();
      transactionPaymentMode = 'Cash';

      // For Local Database
      final localTransaction = LocalTransaction(
          userId: userId!,
          tID: tID,
          tNote: transactionNote!,
          tPaymentMode: transactionPaymentMode!,
          tAmount: amountOfMoney,
          tCategory: categoryIndex!,
          tSubcategory: subcategory!,
          tSubcategoryIndex: subcategoryIndex!,
          tDateTime: _dateTime,
          tCreatedAt: currentDateTime);

      updateLocalTransaction(localTransaction);
      getAllLocalTransactions();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: ((context) => const HomeScreen())));
    }  
  }

  Future<void> createLocalTransaction(LocalTransaction transaction) async {
    final box = await Hive.openBox<LocalTransaction>('local_transactions');
    await box.add(transaction);
  }

  Future<List<LocalTransaction>> getAllLocalTransactions() async {
    final box = await Hive.openBox<LocalTransaction>('local_transactions');
    final transactions = box.values.toList();
    return transactions;
  }

  void addTransaction() {
    // For Local DB Function
    if (transactionFormGlobalKey.currentState!.validate()) {
      DateTime currentDateTime = DateTime.now();
      if (value == 1) {
        if (_isChecked == true) {
          categoryIndex = 3;
        } else if (_isChecked == false) {
          categoryIndex = 0;
        }
      }
      if(noteController.text.isEmpty){
        noteController.text="-";
      }
      String noteDetail=noteController.text;
      String capitalizedNote=noteDetail[0].toUpperCase() + noteDetail.substring(1);
      transactionAmount = amountController.text;
      transactionPaymentMode = 'Cash';
      transactionNote =capitalizedNote; 
      int amountOfMoney = int.parse(transactionAmount!);
      String tId = generateRandomString(20);


      final localTransaction = LocalTransaction(
          userId: userId!,
          tID: tId,
          tNote: transactionNote!,
          tPaymentMode: transactionPaymentMode!,
          tAmount: amountOfMoney,
          tCategory: categoryIndex!,
          tSubcategory: subcategory!,
          tSubcategoryIndex: subcategoryIndex!,
          tDateTime: _dateTime,
          tCreatedAt: currentDateTime);

      createLocalTransaction(localTransaction);
      getAllLocalTransactions();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: ((context) => const HomeScreen())));
    }
  }

  String generateRandomString(int length) {
    final random = Random();
    const characters = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final StringBuffer buffer = StringBuffer();
    for (int i = 0; i < length; i++) {
      final int randomIndex = random.nextInt(characters.length);
      buffer.write(characters[randomIndex]);
    }
    return buffer.toString();
  }
}
