import 'dart:io';
import 'package:expenses_tracker/api/pdf_api.dart';
import 'package:expenses_tracker/model/transaction.dart';
import 'package:expenses_tracker/utils/const.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfInvoiceApi {
  static Future<File> generate(
      List<AllTransactionDetails> transaction,
      String duration,
      String title,
      int income,
      int spending,
      int balance) async {
    final pdf = Document();
    String len = transaction.length.toString();
    print(transaction.length);
    pdf.addPage(MultiPage(
      build: (context) => [
        buildTitle(title: title),
        SizedBox(height: 20),
        buildSimpleText(title: "$duration", value: "Duration"),
        SizedBox(height: 10),
        buildTransaction(transaction),
        Divider(),
        buildTotal(income, spending, balance),
      ],
      footer: (context) => buildFooter(),
    ));

    return PdfApi.saveDocument(name: '$title ($duration).pdf', pdf: pdf);
  }

  static buildTitle({
    required String title,
  }) {
    return Center(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('$title',
          style: TextStyle(
              color: PdfColors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center)
    ]));
  }

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Column(children: [
      Row(
        children: [
          Text("Username:"),
          SizedBox(width: 2 * PdfPageFormat.mm),
          Text(UserData.CurentUserName!, style: style),
        ],
      ),
      SizedBox(height: 5),
      Row(
        children: [
          Text("Phone No.:"),
          SizedBox(width: 2 * PdfPageFormat.mm),
          Text(UserData.CurentUserPhone!, style: style),
        ],
      ),
      SizedBox(height: 5),
      Row(
        children: [
          Text("Email:"),
          SizedBox(width: 2 * PdfPageFormat.mm),
          Text(UserData.CurrentUserEmail!, style: style),
        ],
      ),
      SizedBox(height: 5),
      Row(
        children: [
          Text("Transaction Period:"),
          SizedBox(width: 2 * PdfPageFormat.mm),
          Text(title, style: style),
        ],
      ),
      SizedBox(height: 5),
    ]);
  }

  static Widget buildFooter() {
    String datetime;
    DateTime transaction_datetime = DateTime.now();
    String datestamp = DateFormat.yMMMd().format(transaction_datetime);
    String timestamp = DateFormat.jm().format(transaction_datetime);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
        Text("Created by :"),
        Text(" Team Vyaya", style: TextStyle(fontWeight: FontWeight.bold))
      ]),
      SizedBox(height: 7),
      Row(
                mainAxisAlignment: MainAxisAlignment.end,

        children: [Text("Created on :"),Text(" $datestamp $timestamp", style: TextStyle(fontWeight: FontWeight.bold))])
    ]);
  }

  static Widget buildTransaction(List<AllTransactionDetails> transaction) {
    int id = 1;
    final headers = [
      'No ',
      'Date & Time',
      'Category',
      'Subcategory',
      'Note',
      'Amount',
    ];
    final data = transaction.map((item) {
      DateTime transaction_datetime = item.transactionDate!.toDate();

      String transaction_category;
      String subcategory;
      if (item.transactioncategory == 1) {
        transaction_category = "Expense";
        subcategory = ListOfAppData
            .listOfCategory[item.transactionsubcategoryindex!].categoryText!;
      } else {
        transaction_category = "Income";
        subcategory = ListOfAppData
            .listofIncome[item.transactionsubcategoryindex!].categoryText!;
      }

      String datestamp = DateFormat.yMMMd().format(transaction_datetime);
      String timestamp = DateFormat.jm().format(transaction_datetime);

      return [
        id++,
        "$datestamp $timestamp",
        '$transaction_category',
        '$subcategory',
        '${item.transactionnote}',
        '${item.transactionAmount}',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.green300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.center,
        1: Alignment.center,
        2: Alignment.center,
        3: Alignment.center,
        4: Alignment.center,
        5: Alignment.center,
        6: Alignment.center
      },
    );
  }

  static Widget buildTotal(int income, int spending, int balance) {
    final income_amount = income;
    final spending_amount = spending;
    final balance_amount = balance;
    // final total = netTotal + vat;

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 5),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Total Income',
                  value: income_amount.toString(),
                  unite: true,
                ),
                SizedBox(height: 5),
                buildText(
                  title: 'Total Spending',
                  value: "- $spending_amount",
                  unite: true,
                ),
                Divider(),
                buildText(
                  title: 'Remaining Balance',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: balance_amount.toString(),
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Container(
            padding: EdgeInsets.only(right: 20),
            child: Text(value, style: unite ? style : null),
          )
        ],
      ),
    );
  }
}
