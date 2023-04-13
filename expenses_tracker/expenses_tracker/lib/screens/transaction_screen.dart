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
  // CollectionReference tranactions =
  //     FirebaseFirestore.instance.collection('transaction');

  DateTime _dateTime = DateTime.now();

  Icon? prefixIcon;
  int? subcategoryindex;
  int? subcategory;
  int? categoryindex;
  int? personal_finaance_cetegory;
  bool _isChecked = true;

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
      
      if(value==1){
        if(_isChecked==true){
                    categoryindex = 3;
        }
        else if(_isChecked==false){
                    categoryindex = 0;
        }

      }
      
      final transactionRef = firestore
          .collection('users')
          .doc(userid)
          .collection('transaction')
          .doc();

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
    );
    if (picked != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_dateTime),
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

    // if(widget.id==2){
    //   _dateTime=widget.trasactionDate.toString();
    //   _amountController.text=widget.transactionAmount.toString();
    //   _noteController.text=widget.transactionNote.toString();
    // // }
    // uid = FirebaseAuth.instance.currentUser!.uid;

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
      _amountController.text = widget.transactionAmount.toString();
      _noteController.text = widget.transactionNote.toString();
      _paymentModeController.text = "Cash";
      _setdateController.text = widget.trasactionDate!;
      subcategory = widget.tranactionsSubCategory;
      personal_finaance_cetegory = 1;
      if (widget.transactionCategory == 1) {
        value = widget.transactionCategory! - 1;
        _incomecategoryController.text = ListOfAppData
            .listOfCategory[widget.tranactionsSubCategoryindex!].categoryText!;
        prefixIcon = ListOfAppData
            .listOfCategory[widget.tranactionsSubCategoryindex!].categoryIcon;
      } else {
        value = widget.transactionCategory! + 1;
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
                              ? PrimaryColor.color_bottle_green
                              : Colors.black),
                    ),
                    child: Text(
                      "Expenses",
                      style: TextStyle(
                        color: (value == 0)
                            ? PrimaryColor.color_bottle_green
                            : Colors.black,
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
                              ? PrimaryColor.color_bottle_green
                              : Colors.black),
                    ),
                    child: Text(
                      "Income",
                      style: TextStyle(
                        color: (value == 1)
                            ? PrimaryColor.color_bottle_green
                            : Colors.black,
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
                              ? PrimaryColor.color_bottle_green
                              : Colors.black),
                    ),
                    child: Text(
                      "Transfer",
                      style: TextStyle(
                        color: (value == 2)
                            ? PrimaryColor.color_bottle_green
                            : Colors.black,
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
                                  decoration: InputDecoration(
                                      hintText: "Enter Date",
                                      prefixIconConstraints:
                                          BoxConstraints.tightFor(
                                              height: 05, width: 35)),
                                ),
                              ),
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
                                  controller: _amountController,
                                  validator: amountvalidator,
                                  decoration: InputDecoration(
                                      hintText: "Enter Amount",
                                      prefixIconConstraints:
                                          BoxConstraints.tightFor(
                                              height: 05, width: 35)),
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
                                                validator: textFormFieldValidator,
                                                onTap: () {
                                                  navigate(context, 0);
                                                },
                                                readOnly: true,
                                                controller:
                                                    _expensescategoryController,
                                                decoration: InputDecoration(
                                                    suffixIcon:
                                                        Icon(Icons.chevron_right),
                                                    prefixIconConstraints:
                                                        BoxConstraints.tightFor(
                                                            height: 05, width: 35)),
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
                                            decoration: InputDecoration(
                                                suffixIcon:
                                                    Icon(Icons.chevron_right),
                                                prefixIconConstraints:
                                                    BoxConstraints.tightFor(
                                                        height: 05,
                                                        width: 35)),
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
                                      validator: textFormFieldValidator,
                                      keyboardType: TextInputType.number,
                                      controller: _paymentModeController,
                                      decoration: InputDecoration(
                                          suffixIcon: Icon(Icons.chevron_right),
                                          prefixIconConstraints:
                                              BoxConstraints.tightFor(
                                                  height: 05, width: 35)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          value==1 ?Row(
                            children: [
                                                Checkbox(
                                                  value: _isChecked,
                                                  onChanged: (bool? newValue) {
                                                      _isChecked = newValue!;
                                                      print("_isChecked : $_isChecked");
                                                    
                                                    setState(() {
                                                      
                                                    });
                                                  },
                                                ),
                                                const Text(
                                                    'Add to Personal Finance Portion'),
                                              ],
                                            )
                                            :SizedBox(height: 0,),
      
                          SizedBox(
                            height: 20,
                          ),
                          // Divider(color: PrimaryColor.color_bottle_green,),
                          Row(
                            children: [
                              CustomTextStyle(
                                  customtextstyletext: "Other Details",
                                  customtextcolor: Colors.black,
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
                                  keyboardType: TextInputType.text,
                                  validator: noteValidator,
                                  controller: _noteController,
                                  decoration: InputDecoration(
                                      hintText: "Note",
                                      prefixIconConstraints:
                                          BoxConstraints.tightFor(
                                              height: 05, width: 35)),
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
      floatingActionButton: FloatingActionButton(
          backgroundColor: PrimaryColor.color_bottle_green,
          child: Icon(
            Icons.save,
            color: PrimaryColor.color_white,
          ),
          onPressed: addTransaction),
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
