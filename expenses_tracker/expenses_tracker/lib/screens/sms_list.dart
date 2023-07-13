import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_entity_extraction/google_mlkit_entity_extraction.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:sms_advanced/sms_advanced.dart';
import '../model/auto_read_message_model.dart';
import '../model/localtransaction.dart';
import '../utils/const.dart';

import '../utils/validation.dart';
import '../widgets/fade_transition.dart';
import 'category_list.dart';

class TextMessageList extends StatefulWidget {
  const TextMessageList({super.key});

  @override
  _TextMessageListState createState() => _TextMessageListState();
}

class _TextMessageListState extends State<TextMessageList> {
  final SmsQuery query = SmsQuery();
  String? userId;
  List<SmsMessage> listOfSms = [];
  List<LocalTransaction> allExistingTransactions = [];
  TextEditingController expensesCategoryController = TextEditingController();
  TextEditingController incomeCategoryController = TextEditingController();
  bool? isLoading;
  final RegExp allowedPattern = RegExp(r'^[A-Z]{2}-[A-Z0-9]{6}$');
  final _entityExtractor =
      EntityExtractor(language: EntityExtractorLanguage.english);
  static List<AutoReadMessageModel> listOfAutoReadTransactions = [];
  TextEditingController noteController = TextEditingController();
  TextEditingController paymentModeController = TextEditingController();
  GlobalKey<FormState> transactionFormGlobalKey = GlobalKey<FormState>();
  String dropdownvalue = 'Cash';
  int? subcategoryIndex, categoryIndex;
  int? subcategory;
  var items = [
    'Cash',
    'Bank',
    'Credit / Debit Card',
    'UPI',
  ];
  Icon? prefixIconForCategory, prefixIconForPaymentMode, prefixIconForNote;
  String? selectedValue;

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    userId = UserData.currentUserId;
    subcategoryIndex = 0;
    subcategory = 1;
    categoryIndex = 1;
    getAllLocalTransactions();
    prefixIconForCategory = Icon(
      Icons.more_horiz,
      color: PrimaryColor.colorWhite,
      size: 20,
    );
    prefixIconForPaymentMode = Icon(
      Icons.money,
      color: PrimaryColor.colorWhite,
      size: 20,
    );
    prefixIconForNote = Icon(
      Icons.note,
      color: PrimaryColor.colorWhite,
      size: 20,
    );
    expensesCategoryController.text = "others";
    incomeCategoryController.text = "others";
    paymentModeController.text = dropdownvalue;
    listOfAutoReadTransactions.clear();
    query.getAllSms.then((value) {
      setState(() {
        listOfSms = value;
      });
      for (int i = 0; i < listOfSms.length; i++) {
        if (allowedPattern.hasMatch(listOfSms[i].sender!)) {
          String messageBody = listOfSms[i].body!;
          String messageSender = listOfSms[i].sender!;
          DateTime messageReceivedTime = listOfSms[i].date!;
          if (messageBody.contains("Debited") ||
              messageBody.contains("DEBITED") ||
              messageBody.contains("debited") ||
              messageBody.contains("Credited") ||
              messageBody.contains("CREDITED") ||
              messageBody.contains("credited")) {
            _extractEntities(messageBody, messageReceivedTime, messageSender);
          }
        }
      }
      listOfAutoReadTransactions
          .sort((a, b) => b.tDateTime.compareTo(a.tDateTime));
    });
    setState(() {
      isLoading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          elevation: 5,
          backgroundColor: Theme.of(context).bottomAppBarTheme.color,
          iconTheme:
              IconThemeData(color: Theme.of(context).colorScheme.secondary),
          title: Text(
            'Auto Read Transactions',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: MediaQuery.of(context).size.height * 0.025,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        body: isLoading == true
            ? Center(
                child: CircularProgressIndicator(
                color: PrimaryColor.colorBlue,
              ))
            : listOfAutoReadTransactions.isEmpty
                ?Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: PrimaryColor.colorBlue,),
                      const SizedBox(height: 12),
                      Text(
                        'It might take Some time to \nfetch your Data',
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ))
                : ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: listOfAutoReadTransactions.length,
                    itemBuilder: (context, index) {
                      String? dateFormation = DateFormat('MMM dd, yyyy hh:mm a')
                          .format(listOfAutoReadTransactions[index].tDateTime);
                      bool isExist = allExistingTransactions.any(
                        (transaction) =>
                            transaction.tID ==
                            listOfAutoReadTransactions[index].tId,
                      );
                      if (isExist) {
                        listOfAutoReadTransactions[index].isExpanded = false;
                      }

                      return Card(
                        color: isExist
                            ? Theme.of(context).hintColor.withOpacity(0.1)
                            : Theme.of(context).cardColor,
                        child: Column(
                          children: [
                            ListTile(
                              leading: SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.14,
                                width: MediaQuery.of(context).size.width * 0.14,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60),
                                  ),
                                  color: listOfAutoReadTransactions[index]
                                                  .tCategory ==
                                              3 ||
                                          listOfAutoReadTransactions[index]
                                                  .tCategory ==
                                              0
                                      ? PrimaryColor.colorBottleGreen
                                      : PrimaryColor.colorRed,
                                  child: Icon(
                                    Icons.more_horiz,
                                    color: PrimaryColor.colorWhite,
                                    size: 30,
                                  ),
                                ),
                              ),
                              title: Text(
                                NumberFormat.currency(
                                  symbol: listOfAutoReadTransactions[index]
                                                  .tCategory ==
                                              3 ||
                                          listOfAutoReadTransactions[index]
                                                  .tCategory ==
                                              0
                                      ? '+ ₹'
                                      : "- ₹",
                                  locale: "HI",
                                  decimalDigits: 0,
                                ).format(
                                    listOfAutoReadTransactions[index].tAmount),
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                style: GoogleFonts.roboto(
                                    color: listOfAutoReadTransactions[index]
                                                    .tCategory ==
                                                3 ||
                                            listOfAutoReadTransactions[index]
                                                    .tCategory ==
                                                0
                                        ? PrimaryColor.colorBottleGreen
                                        : PrimaryColor.colorRed,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.021,
                                    fontWeight: FontWeight.w400),
                              ),
                              subtitle: Text(
                                dateFormation,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.016),
                              ),
                              trailing:
                                  listOfAutoReadTransactions[index].isExpanded
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.close,
                                            color: Theme.of(context).hintColor,
                                          ),
                                          onPressed: () {
                                            closeCard(index);
                                          },
                                        )
                                      : Icon(
                                          listOfAutoReadTransactions[index]
                                                  .isExpanded
                                              ? Icons.keyboard_arrow_up
                                              : Icons.keyboard_arrow_down,
                                          color: Theme.of(context).hintColor,
                                        ),
                              onTap: () {
                                expandCard(index);
                              },
                            ),
                            if (listOfAutoReadTransactions[index].isExpanded)
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Form(
                                  key: transactionFormGlobalKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Add Transaction',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                fontWeight: FontWeight.w400,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.045),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.05,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.05,
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              color: listOfAutoReadTransactions[
                                                                  index]
                                                              .tCategory ==
                                                          3 ||
                                                      listOfAutoReadTransactions[
                                                                  index]
                                                              .tCategory ==
                                                          0
                                                  ? PrimaryColor
                                                      .colorBottleGreen
                                                  : PrimaryColor.colorRed,
                                              child: Center(
                                                  child: prefixIconForCategory),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          listOfAutoReadTransactions[index]
                                                      .tCategory ==
                                                  1
                                              ? Flexible(
                                                  child: TextFormField(
                                                    validator:
                                                        textFormFieldValidator,
                                                    onTap: () {
                                                      navigate(context, 1);
                                                    },
                                                    readOnly: true,
                                                    controller:
                                                        incomeCategoryController,
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary),
                                                    decoration: InputDecoration(
                                                      suffixIcon: Padding(
                                                        padding: EdgeInsets.only(
                                                            left: MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.07),
                                                        child: const Icon(Icons
                                                            .chevron_right),
                                                      ),
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary,
                                                        ),
                                                      ),
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onPrimary,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Flexible(
                                                  child: TextFormField(
                                                    validator:
                                                        textFormFieldValidator,
                                                    onTap: () {
                                                      navigate(context, 0);
                                                    },
                                                    readOnly: true,
                                                    controller:
                                                        expensesCategoryController,
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary),
                                                    decoration: InputDecoration(
                                                      suffixIcon: Padding(
                                                        padding: EdgeInsets.only(
                                                            left: MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.07),
                                                        child: const Icon(Icons
                                                            .chevron_right),
                                                      ),
                                                      prefixIconConstraints:
                                                          const BoxConstraints
                                                                  .tightFor(
                                                              height: 05,
                                                              width: 35),
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary,
                                                        ),
                                                      ),
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onPrimary,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.05,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.05,
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              color: listOfAutoReadTransactions[
                                                                  index]
                                                              .tCategory ==
                                                          3 ||
                                                      listOfAutoReadTransactions[
                                                                  index]
                                                              .tCategory ==
                                                          0
                                                  ? PrimaryColor
                                                      .colorBottleGreen
                                                  : PrimaryColor.colorRed,
                                              child: Center(
                                                  child:
                                                      prefixIconForPaymentMode),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Flexible(
                                            child: DropdownButtonFormField(
                                              decoration: InputDecoration(
                                                disabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary),
                                                ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary),
                                                ),
                                                border: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary),
                                                ),
                                              ),
                                              value: dropdownvalue,
                                              dropdownColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              iconDisabledColor:
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                              icon: const Icon(
                                                  Icons.chevron_right),
                                              items: items.map((String items) {
                                                return DropdownMenuItem(
                                                  value: items,
                                                  child: Text(
                                                    items,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  dropdownvalue = newValue!;
                                                  paymentModeController.text =
                                                      dropdownvalue;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.05,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.05,
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              color: listOfAutoReadTransactions[
                                                                  index]
                                                              .tCategory ==
                                                          3 ||
                                                      listOfAutoReadTransactions[
                                                                  index]
                                                              .tCategory ==
                                                          0
                                                  ? PrimaryColor
                                                      .colorBottleGreen
                                                  : PrimaryColor.colorRed,
                                              child: Center(
                                                  child: prefixIconForNote),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Flexible(
                                            child: TextFormField(
                                              readOnly: false,
                                              cursorColor: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                              keyboardType: TextInputType.text,
                                              maxLength: 20,
                                              controller: noteController,
                                              decoration: InputDecoration(
                                                hintText: "Description",
                                                prefixIconConstraints:
                                                    const BoxConstraints
                                                            .tightFor(
                                                        height: 05, width: 35),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
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
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                addTransaction(
                                                    index,
                                                    listOfAutoReadTransactions[
                                                            index]
                                                        .tCategory,
                                                    listOfAutoReadTransactions[
                                                            index]
                                                        .tAmount,
                                                    listOfAutoReadTransactions[
                                                            index]
                                                        .tDateTime,
                                                    listOfAutoReadTransactions[
                                                            index]
                                                        .tId);
                                              },
                                              child: Text(
                                                'Save',
                                                style: TextStyle(
                                                    color: PrimaryColor
                                                        .colorBottleGreen,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.045),
                                              ))
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ));
  }

  Future<void> _extractEntities(
      String sms, DateTime time, String sender) async {
    final result = await _entityExtractor.annotateText(sms);
    EntityAnnotation? amountEntity;
    int autoReadCategory;

    if (sms.contains("Debited") ||
        sms.contains("DEBITED") ||
        sms.contains("debited")) {
      autoReadCategory = 1;

      try {
        amountEntity = result.firstWhere(
            (entity) => entity.entities.first.type == EntityType.money);
        // ignore: empty_catches
      } catch (e) {}
    } else {
      autoReadCategory = 3;
      try {
        amountEntity = result.firstWhere(
            (entity) => entity.entities.first.type == EntityType.money);
        // ignore: empty_catches
      } catch (e) {}
    }

    String amountText = amountEntity?.text.toString() ?? '';
    final cleanedText = amountText.replaceAll(RegExp(r'[^0-9.]'), '');
    amountText = cleanedText;
    String finalAmount = amountText;
    double amountOfMoney = double.parse(finalAmount);
    int finalAmountForInt = amountOfMoney.toInt();

    int timestamp = time.millisecondsSinceEpoch ~/ 1000;

    String transactionId =
        'auto${timestamp.toString().padLeft(10, '0').substring(0, 10)}'
                '${autoReadCategory.toString()}${finalAmountForInt.toString().padLeft(2, '0')}'
            .padRight(20, '0');

    setState(() {
      listOfAutoReadTransactions.add(AutoReadMessageModel(
          tId: transactionId,
          tAmount: finalAmountForInt,
          tDateTime: time,
          tSender: sender,
          tCategory: autoReadCategory,
          isExpanded: false));
    });
  }

  void addTransaction(int index, int value, int amountOfMoney,
      DateTime dateTime, String transationId) {
    // For Local DB Function
    if (transactionFormGlobalKey.currentState!.validate()) {
      bool isExist = allExistingTransactions.any(
        (transaction) => transaction.tID == transationId,
      );
      if (isExist) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 10),
              Text(
                'Transaction is Already Exist',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ));
        closeCard(index);
      } else {
        DateTime currentDateTime = DateTime.now();
        if (value == 3) {
          categoryIndex = 3;
        }
        if (noteController.text.isEmpty) {
          if (categoryIndex == 0 || categoryIndex == 3) {
            noteController.text =
                ListOfAppData.listOfIncome[subcategoryIndex!].categoryText!;
          }
          if (categoryIndex == 1) {
            noteController.text =
                ListOfAppData.listOfCategory[subcategoryIndex!].categoryText!;
          }
        }
        String noteDetail = noteController.text;
        String capitalizedNote =
            noteDetail[0].toUpperCase() + noteDetail.substring(1);

        String transactionPaymentMode = paymentModeController.text;
        String transactionNote = capitalizedNote;
        // String tId = generateRandomString(20);

        final localTransaction = LocalTransaction(
            userId: userId!,
            tID: transationId,
            tNote: transactionNote,
            tPaymentMode: transactionPaymentMode,
            tAmount: amountOfMoney,
            tCategory: categoryIndex!,
            tSubcategory: subcategory!,
            tSubcategoryIndex: subcategoryIndex!,
            tDateTime: dateTime,
            tCreatedAt: currentDateTime);

        createLocalTransaction(localTransaction);
        getAllLocalTransactions();
        setState(() {
          listOfAutoReadTransactions[index].isExpanded = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 10),
              Text(
                'Transaction Added Successfully',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ));
        closeCard(index);
      }
    }
  }

  Future<void> createLocalTransaction(LocalTransaction transaction) async {
    final box = await Hive.openBox<LocalTransaction>('local_transactions');
    await box.add(transaction);
  }

  Future<List<LocalTransaction>> getAllLocalTransactions() async {
    final box = await Hive.openBox<LocalTransaction>('local_transactions');
    allExistingTransactions = box.values.toList();
    return allExistingTransactions;
  }

  void expandCard(int index) {
    setState(() {
      subcategoryIndex = 0;
      subcategory = 1;
      categoryIndex = 1;
      prefixIconForCategory = Icon(
        Icons.more_horiz,
        color: PrimaryColor.colorWhite,
        size: 20,
      );
      prefixIconForPaymentMode = Icon(
        Icons.money,
        color: PrimaryColor.colorWhite,
        size: 20,
      );
      prefixIconForNote = Icon(
        Icons.note,
        color: PrimaryColor.colorWhite,
        size: 20,
      );

      for (int i = 0; i < listOfAutoReadTransactions.length; i++) {
        listOfAutoReadTransactions[i].isExpanded = i == index;
      }
    });
  }

  Future<void> navigate(BuildContext context, int id) async {
    final result = await Navigator.of(context).push(
      FadeSlideTransitionRoute(page: CategoryList(id: id)),
    );

    if (!mounted) return;
    int index = int.parse(result);
    int indexForIcon = index;
    setState(() {
      if (id == 0) {
        expensesCategoryController.text =
            ListOfAppData.listOfIncomeForAutoRead[index].categoryText!;
        prefixIconForCategory =
            ListOfAppData.listOfIncomeForAutoRead[index].categoryIcon;
        subcategoryIndex =
            ListOfAppData.listOfIncomeForAutoRead[index].categoryIndex;
        subcategory = ListOfAppData.listOfIncomeForAutoRead[index].categoryType;
      } else if (id == 1) {
        incomeCategoryController.text =
            ListOfAppData.listOfCategoryForAutoRead[index].categoryText!;
        prefixIconForCategory =
            ListOfAppData.listOfCategoryForAutoRead[index].categoryIcon;
        subcategoryIndex =
            ListOfAppData.listOfCategoryForAutoRead[indexForIcon].categoryIndex;
        subcategory =
            ListOfAppData.listOfCategoryForAutoRead[index].categoryType;
        categoryIndex = 1;
      } else {
        incomeCategoryController.text =
            ListOfAppData.listOfCategoryForAutoRead[index].categoryText!;
        prefixIconForCategory =
            ListOfAppData.listOfCategoryForAutoRead[index].categoryIcon;
        subcategoryIndex =
            ListOfAppData.listOfCategoryForAutoRead[indexForIcon].categoryIndex;
        subcategory =
            ListOfAppData.listOfCategoryForAutoRead[index].categoryType;
      }
    });
  }

  void closeCard(int index) {
    setState(() {
      subcategoryIndex = 0;
      subcategory = 1;
      categoryIndex = 1;
      prefixIconForCategory = Icon(
        Icons.more_horiz,
        color: PrimaryColor.colorWhite,
        size: 20,
      );
      prefixIconForPaymentMode = Icon(
        Icons.money,
        color: PrimaryColor.colorWhite,
        size: 20,
      );
      prefixIconForNote = Icon(
        Icons.note,
        color: PrimaryColor.colorWhite,
        size: 20,
      );
      listOfAutoReadTransactions[index].isExpanded = false;
      noteController.clear();
      expensesCategoryController.text = 'others';
      incomeCategoryController.text = 'others';
      paymentModeController.text = "Cash";
      dropdownvalue = 'Cash';
    });
  }
}
