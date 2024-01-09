// ignore_for_file: must_be_immutable

import 'package:expenses_tracker/widgets/custom_no_data.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../model/localtransaction.dart';
import '../model/transaction.dart';
import '../utils/const.dart';
import 'package:intl/intl.dart';
import '../widgets/transaction_list.dart';

class TransactionOfMonth extends StatefulWidget implements PreferredSizeWidget {
  final int id, amount;
  String? titleText, subtitleText;
  List<AllTransactionDetails>? currentPageTransaction;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  TransactionOfMonth(
      {super.key,
      required this.id,
      required this.amount,
      this.currentPageTransaction,
      this.titleText,
      this.subtitleText});

  @override
  State<TransactionOfMonth> createState() => _TransactionOfMonthState();
}

class _TransactionOfMonthState extends State<TransactionOfMonth>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  static List<AllTransactionDetails> currentMonthTransactions = [];
  static List<LocalTransaction> transactionOfMonth = [];
  String? uid;
  DateTime? currentDate;
  DateTime? yesterdayDate;

  Future<void> getAllTransaction() async {
    setState(() {
      isLoading = true;
    });
    try {
      final tempTransactionDateStampTransactionData =
          getTransactionsThisMonth();
      transactionOfMonth = await tempTransactionDateStampTransactionData;
      setState(() {
        currentMonthTransactions = transactionOfMonth
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
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    currentDate = DateTime.now();
    yesterdayDate == currentDate!.subtract(const Duration(days: 1));
    uid = UserData.currentUserId;
    getAllTransaction();
  }

  @override
  Widget build(BuildContext context) {
    String formatCurrency(int? value) {
      NumberFormat currencyFormat = NumberFormat.currency(
        symbol: '₹',
        locale: "HI",
        decimalDigits: 0,
      );
      return currencyFormat.format(value);
    }

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          iconTheme:
              IconThemeData(color: Theme.of(context).colorScheme.secondary),
          title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.id == 1
                      ? 'Monthly Transaction'
                      : widget.id == 3
                          ? 'Monthly Expenses'
                          : widget.id == 2
                              ? 'Monthly Income'
                              : widget.titleText!,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: MediaQuery.of(context).size.height * 0.025),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    widget.id == 1
                        ? "Remaining Balance : ${formatCurrency(widget.amount)}"
                        : widget.id == 2 || widget.id == 3
                            ? formatCurrency(widget.amount)
                            : '${widget.subtitleText}',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).colorScheme.secondary),
                    overflow: TextOverflow.clip,
                  ),
                ),
              ]),
          elevation: 5,
          backgroundColor: Theme.of(context).bottomAppBarTheme.color,
        ),
        body: widget.id == 1 || widget.id == 2 || widget.id == 3
            ? isLoading == true
                ? const Center(child: CircularProgressIndicator())
                : currentMonthTransactions.isEmpty
                    ? const Center(child: CustomNoData())
                    : Container(
                        height: MediaQuery.of(context).size.height,
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: TransactionList(
                            transactionList: currentMonthTransactions,
                          ),
                        ),
                      )
            : widget.currentPageTransaction!.isEmpty
                ? const Center(child: CustomNoData())
                : Container(
                    height: MediaQuery.of(context).size.height,
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: TransactionList(
                        transactionList: widget.currentPageTransaction!,
                      ),
                    ),
                  ));
  }

  Future<List<LocalTransaction>> getAllLocalTransactions() async {
    final box = await Hive.openBox<LocalTransaction>('local_transactions');
    final transactions = box.values.toList();
    return transactions;
  }

  Future<List<LocalTransaction>> getTransactionsThisMonth() async {
    final transactions = await getAllLocalTransactions();

    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;

    final transactionsThisMonth = transactions.where((transaction) {
      final transactionDate = transaction.tDateTime;
      if (widget.id == 2) {
        return transactionDate.month == currentMonth &&
                transactionDate.year == currentYear &&
                UserData.currentUserId == transaction.userId &&
                transaction.tCategory == 3 ||
            transaction.tCategory == 0;
      } else if (widget.id == 3) {
        return transactionDate.month == currentMonth &&
            transactionDate.year == currentYear &&
            UserData.currentUserId == transaction.userId &&
            transaction.tCategory == 1;
      } else {
        return transactionDate.month == currentMonth &&
            transactionDate.year == currentYear &&
            UserData.currentUserId == transaction.userId;
      }
    }).toList();
    transactionsThisMonth.sort((a, b) => b.tDateTime.compareTo(a.tDateTime));
    return transactionsThisMonth;
  }
}
