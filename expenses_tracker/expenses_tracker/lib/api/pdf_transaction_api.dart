import 'dart:io';
import 'package:expenses_tracker/api/pdf_api.dart';
import 'package:expenses_tracker/model/transaction.dart';
import 'package:expenses_tracker/utils/const.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfInvoiceApi {
  static Future<File> generate(
      List<AllTransactionDetails> transaction,
      String duration,
      String title,
      int income,
      int spending,
      int balance) async {
    final pdf = Document();
    final pageTheme = await _myPageTheme();

    pdf.addPage(MultiPage(
      pageTheme: pageTheme,
      build: (context) => [
        buildTitle(title: title),
        SizedBox(height: 20),
        buildSimpleText(title: duration, value: "Duration"),
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
      Text(title,
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
          Text(UserData.currentUserName!, style: style),
        ],
      ),
      SizedBox(height: 5),
      Row(
        children: [
          Text("Email:"),
          SizedBox(width: 2 * PdfPageFormat.mm),
          Text(UserData.currentUserEmail!, style: style),
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
    DateTime transactionDateTime = DateTime.now();
    String dateStamp = DateFormat.yMMMd().format(transactionDateTime);
    String timeStamp = DateFormat.jm().format(transactionDateTime);

    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        Text("Created by :"),
        Text(" Team Vyaya", style: TextStyle(fontWeight: FontWeight.bold))
      ]),
      SizedBox(height: 7),
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        Text("Created on :"),
        Text(" $dateStamp $timeStamp",
            style: TextStyle(fontWeight: FontWeight.bold))
      ])
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
      DateTime transactionDateTime = item.transactionDate!.toDate();

      String transactionCategory;
      String subcategory;
      if (item.transactionCategory == 1) {
        transactionCategory = "Expense";
        subcategory = ListOfAppData
            .listOfCategory[item.transactionSubcategoryIndex!].categoryText!;
      } else {
        transactionCategory = "Income";
        subcategory = ListOfAppData
            .listOfIncome[item.transactionSubcategoryIndex!].categoryText!;
      }
      String dateStamp = DateFormat.yMMMd().format(transactionDateTime);
      String timeStamp = DateFormat.jm().format(transactionDateTime);
      String transactionAmountInString = NumberFormat.currency(
        symbol: transactionCategory == 'Income' ? '+ ' : "- ",
        locale: "HI",
        decimalDigits: 2,
      ).format(item.transactionAmount);
      return [
        id++,
        "$dateStamp $timeStamp",
        transactionCategory,
        subcategory,
        '${item.transactionNote}',
        transactionAmountInString,
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: const BoxDecoration(color: PdfColors.green300),
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
    final incomeAmount = income;
    final spendingAmount = spending;
    final balanceAmount = balance;

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
                  value: NumberFormat.currency(
                    symbol: "",
                    locale: "HI",
                    decimalDigits: 2,
                  ).format(incomeAmount),
                  unite: true,
                ),
                SizedBox(height: 5),
                buildText(
                  title: 'Total Spending',
                  value: NumberFormat.currency(
                    symbol: "",
                    locale: "HI",
                    decimalDigits: 2,
                  ).format(spendingAmount),
                  unite: true,
                ),
                Divider(),
                buildText(
                  title: 'Remaining Balance',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: NumberFormat.currency(
                    symbol: "",
                    locale: "HI",
                    decimalDigits: 2,
                  ).format(balanceAmount),
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
            padding: const EdgeInsets.only(right: 20),
            child: Text(value, style: unite ? style : null),
          )
        ],
      ),
    );
  }
}

Future<pw.PageTheme> _myPageTheme() async {
  final logoImage = pw.MemoryImage(
      (await rootBundle.load('assets/watermark.png')).buffer.asUint8List());
  return pw.PageTheme(
    margin: const pw.EdgeInsets.all(1 * PdfPageFormat.cm),
    orientation: pw.PageOrientation.portrait,
    buildBackground: (final context) => pw.FullPage(
        child: pw.Watermark(
            angle: 0,
            child: pw.Opacity(
                opacity: 0.5,
                child: pw.Image(
                    height: 5 * PdfPageFormat.cm,
                    width: 5 * PdfPageFormat.cm,
                    alignment: pw.Alignment.center,
                    logoImage,
                    fit: pw.BoxFit.contain))),
        ignoreMargins: false),
  );
}
