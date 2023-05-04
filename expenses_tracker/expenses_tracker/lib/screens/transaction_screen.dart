import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_tracker/screens/home_screen.dart';
import 'package:expenses_tracker/utils/validation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/const.dart';
import '../widgets/custom_textstyle.dart';
import 'category_list.dart';

class TransactionScreen extends StatefulWidget {
  final int? id;
  String? transactionId, transactionNote, trasactionDate;
  int? transactionAmount,
      transactionCategory,
      tranactionsSubCategory,
      tranactionsSubCategoryindex;

  TransactionScreen(
      {super.key,
      required this.id,
      this.transactionId,
      this.transactionAmount,
      this.transactionNote,
      this.tranactionsSubCategory,
      this.transactionCategory,
      this.trasactionDate,
      this.tranactionsSubCategoryindex});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  int value = 0;
  String? userid,
      transactioncategory,
      transactiondate,
      transactionamount,
      transactionsubcategory,
      transactionpaymentmode,
      transactionnote;
  TextEditingController _amountController = TextEditingController();
  TextEditingController _setdateController = TextEditingController();
  TextEditingController _expensescategoryController = TextEditingController();
  TextEditingController _incomecategoryController = TextEditingController();
  TextEditingController _paymentModeController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  GlobalKey<FormState> transactionFormGloblaKey = GlobalKey<FormState>();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  DateTime _dateTime = DateTime.now();

  Icon? prefixIcon;
  int? subcategoryindex;
  int? subcategory;
  int? categoryindex;
  int? personal_finaance_cetegory;
  bool _isChecked = true;

  void updateTransaction() {
    if (transactionFormGloblaKey.currentState!.validate()) {
      String dateonly = _setdateController.text.substring(0, 12);
      String timeonly = _setdateController.text.substring(13, 21);
      
      DateTime _dateTime =
          DateFormat('MMM d, yyyy h:mm a').parse("$dateonly $timeonly");

      DateTime currentdatetime = DateTime.now();
      print(widget.transactionId);

      if (value == 1) {
        if (_isChecked == true) {
          categoryindex = 3;
        } else if (_isChecked == false) {
          categoryindex = 0;
        }
      }
      Timestamp timestamp = Timestamp.fromDate(_dateTime);
      Timestamp currenttimestamp = Timestamp.fromDate(currentdatetime);

      transactionnote = _noteController.text;

      transactionamount = _amountController.text;
      int amountOfmoney = int.parse(transactionamount!);
      String tID = widget.transactionId.toString();
      transactionpaymentmode = 'Cash';

      final transactionRef = firestore
          .collection('users')
          .doc(userid)
          .collection('transaction')
          .doc(tID);

      transactionRef.set({
        'uId': userid,
        'tID': tID,
        'transactionCategory': categoryindex,
        'transactionsubcategory': subcategory,
        'transactionsubcategoryindex': subcategoryindex,
        'transactionDate': timestamp,
        'transactionAmount': amountOfmoney,
        'transactionpaymentmode': transactionpaymentmode,
        'transactionnote': transactionnote,
        'transactionCreatedAt': currenttimestamp
      });

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: ((context) => HomeScreen())));
    }
  }

  void addTransaction() {
    if (transactionFormGloblaKey.currentState!.validate()) {
      String dateonly = _setdateController.text.substring(0, 12);
      String timeonly = _setdateController.text.substring(13, 21);
      print(dateonly);
      print(timeonly);
      DateTime _dateTime =
          DateFormat('MMM d, yyyy h:mm a').parse("$dateonly $timeonly");
      print(_dateTime);

      DateTime currentdatetime = DateTime.now();

      if (value == 1) {
        if (_isChecked == true) {
          categoryindex = 3;
        } else if (_isChecked == false) {
          categoryindex = 0;
        }
      }

      final transactionRef = firestore
          .collection('users')
          .doc(userid)
          .collection('transaction')
          .doc(widget.transactionId);

      transactioncategory = "Expenses";
      transactiondate = _dateTime.toString();
      transactionamount = _amountController.text;
      transactionsubcategory = "medical";
      transactionpaymentmode = 'Cash';

      transactionnote = _noteController.text;
      int amountOfmoney = int.parse(transactionamount!);
      TabController _tabController;

      Timestamp timestamp = Timestamp.fromDate(_dateTime);
      Timestamp currenttimestamp = Timestamp.fromDate(currentdatetime);

      print("timestamp $timestamp");

      transactionRef.set({
        'uId': userid,
        'tID': transactionRef.id,
        'transactionCategory': categoryindex,
        'transactionsubcategory': subcategory,
        'transactionsubcategoryindex': subcategoryindex,
        'transactionDate': timestamp,
        'transactionAmount': amountOfmoney,
        'transactionpaymentmode': transactionpaymentmode,
        'transactionnote': transactionnote,
        'transactionCreatedAt': currenttimestamp
      });

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: ((context) => HomeScreen())));
    }
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
        }
    );
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
        }
      );
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

        _setdateController.text =
            DateFormat('MMM dd, yyyy hh:mm a').format(_dateTime).toString();
        print("_dateTime $_dateTime");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.id == 1) {
      userid = FirebaseAuth.instance.currentUser!.uid;
      _setdateController.text =
          DateFormat('MMM dd, yyyy hh:mm a').format(DateTime.now()).toString();
      print("in initstate  ${_setdateController.text}");
      DateTime currentdatetime = DateTime.now();
      _paymentModeController.text = "Cash";
      _expensescategoryController.text = "others";
      _incomecategoryController.text = "others";
      prefixIcon = Icon(
        Icons.more_horiz,
        color: PrimaryColor.color_white,
        size: 30,
      );
      subcategoryindex = 0;
      categoryindex = 1;
      subcategory = 0;
      personal_finaance_cetegory = 1;
    } else {
      print(widget.transactionCategory);
      userid = FirebaseAuth.instance.currentUser!.uid;
      _amountController.text = widget.transactionAmount.toString();
      _noteController.text = widget.transactionNote.toString();
      _paymentModeController.text = "Cash";
      _setdateController.text = widget.trasactionDate!;
      subcategory = widget.tranactionsSubCategory;
      personal_finaance_cetegory = 1;
      categoryindex = widget.transactionCategory;
      if (widget.transactionCategory == 1) {
        value = widget.transactionCategory! - 1;
        _incomecategoryController.text = ListOfAppData
            .listOfCategory[widget.tranactionsSubCategoryindex!].categoryText!;
        prefixIcon = ListOfAppData
            .listOfCategory[widget.tranactionsSubCategoryindex!].categoryIcon;
      } else {
        value = widget.transactionCategory! - 2;
        _expensescategoryController.text = ListOfAppData
            .listofIncome[widget.tranactionsSubCategoryindex!].categoryText!;
        prefixIcon = ListOfAppData
            .listofIncome[widget.tranactionsSubCategoryindex!].categoryIcon;
      }
      subcategoryindex = widget.tranactionsSubCategoryindex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(color: PrimaryColor.color_white),
        title: widget.id == 1
            ? Text(
                'Add Transaction',
                style: TextStyle(color: PrimaryColor.color_white),
              )
            : Text(
                'Update Transaction',
                style: TextStyle(color: PrimaryColor.color_white),
              ),
        elevation: 5,
        backgroundColor: PrimaryColor.color_bottle_green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.02,
                  ),
                  OutlinedButton(
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.02,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        value = 2;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      side: BorderSide(
                          color: (value == 2)
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.secondary),
                    ),
                    child: Text(
                      "Transfer",
                      style: TextStyle(
                        color: (value == 2)
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            value == 2
                ? Container()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: transactionFormGloblaKey,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  color: PrimaryColor.color_bottle_green,
                                  child: Container(
                                      padding: EdgeInsets.all(6),
                                      child: Icon(
                                        Icons.calendar_month,
                                        color: PrimaryColor.color_white,
                                        size: 20,
                                      ))),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: TextFormField(
                                  readOnly: true,
                                  onTap: () {
                                    _selectDateTime(context);
                                  },
                                  controller: _setdateController,
                                  validator: textFormFieldValidator,
                                  style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(color: Theme.of(context).hintColor),
                                    hintText: "Enter Date",
                                    prefixIconConstraints:
                                        BoxConstraints.tightFor(
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
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  color: PrimaryColor.color_bottle_green,
                                  child: Container(
                                      padding: EdgeInsets.all(6),
                                      child: Icon(
                                        Icons.calculate,
                                        color: PrimaryColor.color_white,
                                        size: 20,
                                      ))),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  cursorColor: Theme.of(context).colorScheme.onPrimary,
                                  style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                  enableInteractiveSelection: false,
                                  controller: _amountController,
                                  validator: amountvalidator,
                                  decoration: InputDecoration(
                                    hintText: "Enter Amount",
                                    prefixIconConstraints:
                                        BoxConstraints.tightFor(
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
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                color: PrimaryColor.color_bottle_green,
                                child: Container(child: prefixIcon),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              value == 1
                                  ? Flexible(
                                      child: InkWell(
                                        onTap: () {
                                          print('print');
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              child: TextFormField(
                                                validator:
                                                    textFormFieldValidator,
                                                onTap: () {
                                                  navigate(context, 0);
                                                },
                                                readOnly: true,
                                                controller:
                                                    _expensescategoryController,
                                                    style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                                decoration: InputDecoration(
                                                  suffixIcon:
                                                      Icon(Icons.chevron_right),
                                                  prefixIconConstraints:
                                                      BoxConstraints.tightFor(
                                                          height: 05,
                                                          width: 35),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary, // Change this to your desired border color
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onPrimary, // Change this to your desired border color
                                                    ),
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
                                        onTap: () {
                                          print('print');
                                        },
                                        child: Container(
                                          child: TextFormField(
                                            validator: textFormFieldValidator,
                                            onTap: () {
                                              navigate(context, 1);
                                            },
                                            readOnly: true,
                                            controller:
                                                _incomecategoryController,
                                                style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                            decoration: InputDecoration(
                                              suffixIcon:
                                                  Icon(Icons.chevron_right),
                                              prefixIconConstraints:
                                                  BoxConstraints.tightFor(
                                                      height: 05, width: 35),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary, // Change this to your desired border color
                                                ),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary, // Change this to your desired border color
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),

                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  color: PrimaryColor.color_bottle_green,
                                  child: Container(
                                      padding: EdgeInsets.all(6),
                                      child: Icon(
                                        Icons.money,
                                        color: PrimaryColor.color_white,
                                        size: 20,
                                      ))),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: InkWell(
                                  onTap: () {
                                    print('print');
                                  },
                                  child: Container(
                                    child: TextFormField(
                                      readOnly: true,
                                      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                      validator: textFormFieldValidator,
                                      keyboardType: TextInputType.number,
                                      controller: _paymentModeController,
                                      decoration: InputDecoration(
                                        suffixIcon: Icon(Icons.chevron_right),
                                        prefixIconConstraints:
                                            BoxConstraints.tightFor(
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
                              ),
                            ],
                          ),
                          value == 1
                              ? Padding(
                                padding: const EdgeInsets.only(top :8.0,left: 8.0),
                                child: Row(
                                    children: [
                                      Container(
                                        height: MediaQuery.of(context).size.height*0.025,
                                        width: MediaQuery.of(context).size.width*0.056,
                                        decoration: BoxDecoration(
                                  border: _isChecked
                                      ? Border.all(
                                        
                                          color: Theme.of(context).colorScheme.secondary, // Change this to your desired border color
                                        )
                                      : null,
                                ),
                                
                                        child: Checkbox(
                                          shape: RoundedRectangleBorder(side: BorderSide(color: Theme.of(context).colorScheme.secondary),),
                                          side: BorderSide(color: Theme.of(context).colorScheme.secondary),
                                          checkColor: Theme.of(context).colorScheme.secondary,
                                          value: _isChecked,
                                          onChanged: (bool? newValue) {
                                            _isChecked = newValue!;
                                            print("_isChecked : $_isChecked");
                                      
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 8.0,),
                                      Text(
                                          'Add to Personal Finance Portion',style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
                                    ],
                                  ),
                              )
                              : SizedBox(
                                  height: 0,
                                ),

                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              CustomTextStyle(
                                  customtextstyletext: "Other Details",
                                  customtextcolor: Theme.of(context).colorScheme.secondary,
                                  customtextfontweight: FontWeight.bold,
                                  customtextstyle: null,
                                  customtextsize: 18.00),
                            ],
                          ),
                          Row(
                            children: [
                              Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  color: PrimaryColor.color_bottle_green,
                                  child: Container(
                                      padding: EdgeInsets.all(6),
                                      child: Icon(
                                        Icons.note,
                                        color: PrimaryColor.color_white,
                                        size: 20,
                                      ))),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: TextFormField(
                                  readOnly: false,
                                  cursorColor: Theme.of(context).colorScheme.onPrimary,
                                  style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                  keyboardType: TextInputType.text,
                                  validator: noteValidator,
                                  enableInteractiveSelection: false,
                                  controller: _noteController,
                                  decoration: InputDecoration(
                                    hintText: "Note",
                                    prefixIconConstraints:
                                        BoxConstraints.tightFor(
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
              backgroundColor: PrimaryColor.color_bottle_green,
              child: Icon(
                Icons.save,
                color: PrimaryColor.color_white,
              ),
              onPressed: addTransaction)
          : FloatingActionButton(
              backgroundColor: PrimaryColor.color_bottle_green,
              child: Icon(
                Icons.save,
                color: PrimaryColor.color_white,
              ),
              onPressed: updateTransaction),
    );
  }

  Future<void> navigate(BuildContext context, int id) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CategoryList(id: id)),
    );
    if (!mounted) return;
    int index = int.parse(result);
    int indexforicon = index;
    print("$result");
    setState(() {
      if (id == 0) {
        _expensescategoryController.text =
            ListOfAppData.listofIncome[index].categoryText!;
        prefixIcon = ListOfAppData.listofIncome[index].categoryIcon;
        subcategoryindex = ListOfAppData.listofIncome[index].categoryindex;
        subcategory = ListOfAppData.listofIncome[index].categorytype;
        print("subcategory $subcategory");
        print("_isChecked : $_isChecked");
        // if(_isChecked==true){

        //             categoryindex = 3;

        // }
        // else if(_isChecked==false){
        //             categoryindex = 0;

        // }
      } else if (id == 1) {
        _incomecategoryController.text =
            ListOfAppData.listOfCategory[index].categoryText!;
        prefixIcon = ListOfAppData.listOfCategory[index].categoryIcon;
        subcategoryindex =
            ListOfAppData.listOfCategory[indexforicon].categoryindex;
        subcategory = ListOfAppData.listOfCategory[index].categorytype;
        print("subcategory $subcategory");
        print('Income');
        categoryindex = 1;
      } else {
        _incomecategoryController.text =
            ListOfAppData.listOfCategory[index].categoryText!;
        prefixIcon = ListOfAppData.listOfCategory[index].categoryIcon;
        subcategoryindex =
            ListOfAppData.listOfCategory[indexforicon].categoryindex;
        subcategory = ListOfAppData.listOfCategory[index].categorytype;
        print("subcategory $subcategory");
      }

      print('subcategoryindex $subcategoryindex');
    });
  }
}
