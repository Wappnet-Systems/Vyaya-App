
import 'package:expenses_tracker/utils/const.dart';
import 'package:expenses_tracker/widgets/custom_no_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/transaction.dart';
import '../widgets/transaction_list.dart';

class PfScreen extends StatefulWidget {
  final int id;
  final List<AllTransactionDetails> transactions;
  const PfScreen({super.key, required this.id, required this.transactions});

  @override
  State<PfScreen> createState() => _PfScreenState();
}

class _PfScreenState extends State<PfScreen> {
  List<String>? names;
  List<AllTransactionDetails> transactionList1 = [];
  List<AllTransactionDetails> transactionList2 = [];
  List<AllTransactionDetails> transactionList3 = [];
  List<AllTransactionDetails> transactionList4 = [];
  List<AllTransactionDetails> transactionList5 = [];

  @override
  void initState() {
    transactionList1.clear();
    transactionList2.clear();
    transactionList3.clear();
    transactionList4.clear();
    transactionList5.clear();
    for (int i = 0, a = 0, b = 0, c = 0, d = 0, e = 0;
        i < widget.transactions.length;
        i++) {
      if (widget.transactions[i].transactionSubcategoryIndex == 0 ||
          widget.transactions[i].transactionSubcategoryIndex == 5 ||
          widget.transactions[i].transactionSubcategoryIndex == 8) {
        transactionList1.insert(
            a,
            AllTransactionDetails(
                uId: widget.transactions[i].uId,
                tID: widget.transactions[i].tID,
                transactionDate: widget.transactions[i].transactionDate,
                transactionAmount: widget.transactions[i].transactionAmount,
                transactionCategory: widget.transactions[i].transactionCategory,
                transactionSubcategory:
                    widget.transactions[i].transactionSubcategory,
                transactionSubcategoryIndex:
                    widget.transactions[i].transactionSubcategoryIndex,
                transactionNote: widget.transactions[i].transactionNote,
                transactionPaymentMode:
                    widget.transactions[i].transactionPaymentMode,
                transactionCreatedAt:
                    widget.transactions[i].transactionCreatedAt));
        a++;
      } else if (widget.transactions[i].transactionSubcategoryIndex == 6 ||
          widget.transactions[i].transactionSubcategoryIndex == 1 ||
          widget.transactions[i].transactionSubcategoryIndex == 11) {
        transactionList2.insert(
            b,
            AllTransactionDetails(
                uId: widget.transactions[i].uId,
                tID: widget.transactions[i].tID,
                transactionDate: widget.transactions[i].transactionDate,
                transactionAmount: widget.transactions[i].transactionAmount,
                transactionCategory: widget.transactions[i].transactionCategory,
                transactionSubcategory:
                    widget.transactions[i].transactionSubcategory,
                transactionSubcategoryIndex:
                    widget.transactions[i].transactionSubcategoryIndex,
                transactionNote: widget.transactions[i].transactionNote,
                transactionPaymentMode:
                    widget.transactions[i].transactionPaymentMode,
                transactionCreatedAt:
                    widget.transactions[i].transactionCreatedAt));
        b++;
      } else if (widget.transactions[i].transactionSubcategoryIndex == 7 ||
          widget.transactions[i].transactionSubcategoryIndex == 2) {
        transactionList3.insert(
            c,
            AllTransactionDetails(
                uId: widget.transactions[i].uId,
                tID: widget.transactions[i].tID,
                transactionDate: widget.transactions[i].transactionDate,
                transactionAmount: widget.transactions[i].transactionAmount,
                transactionCategory: widget.transactions[i].transactionCategory,
                transactionSubcategory:
                    widget.transactions[i].transactionSubcategory,
                transactionSubcategoryIndex:
                    widget.transactions[i].transactionSubcategoryIndex,
                transactionNote: widget.transactions[i].transactionNote,
                transactionPaymentMode:
                    widget.transactions[i].transactionPaymentMode,
                transactionCreatedAt:
                    widget.transactions[i].transactionCreatedAt));
        c++;
      } else if (widget.transactions[i].transactionSubcategoryIndex == 9 ||
          widget.transactions[i].transactionSubcategoryIndex == 3) {
        transactionList4.insert(
            d,
            AllTransactionDetails(
                uId: widget.transactions[i].uId,
                tID: widget.transactions[i].tID,
                transactionDate: widget.transactions[i].transactionDate,
                transactionAmount: widget.transactions[i].transactionAmount,
                transactionCategory: widget.transactions[i].transactionCategory,
                transactionSubcategory:
                    widget.transactions[i].transactionSubcategory,
                transactionSubcategoryIndex:
                    widget.transactions[i].transactionSubcategoryIndex,
                transactionNote: widget.transactions[i].transactionNote,
                transactionPaymentMode:
                    widget.transactions[i].transactionPaymentMode,
                transactionCreatedAt:
                    widget.transactions[i].transactionCreatedAt));
        d++;
      } else if (widget.transactions[i].transactionSubcategoryIndex == 4 ||
          widget.transactions[i].transactionSubcategoryIndex == 10) {
        transactionList5.insert(
            e,
            AllTransactionDetails(
                uId: widget.transactions[i].uId,
                tID: widget.transactions[i].tID,
                transactionDate: widget.transactions[i].transactionDate,
                transactionAmount: widget.transactions[i].transactionAmount,
                transactionCategory: widget.transactions[i].transactionCategory,
                transactionSubcategory:
                    widget.transactions[i].transactionSubcategory,
                transactionSubcategoryIndex:
                    widget.transactions[i].transactionSubcategoryIndex,
                transactionNote: widget.transactions[i].transactionNote,
                transactionPaymentMode:
                    widget.transactions[i].transactionPaymentMode,
                transactionCreatedAt:
                    widget.transactions[i].transactionCreatedAt));
        e++;
      } else {}
      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          iconTheme:
              IconThemeData(color: Theme.of(context).colorScheme.secondary),
          backgroundColor: Theme.of(context).bottomAppBarTheme.color,
          elevation: 5,
          title: widget.id == 0
              ? Text(
                  "Needs of Month",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                )
              : widget.id == 1
                  ? Text(
                      "Wants of Month",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                    )
                  : Text(
                      "Saving of Month",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: transactionList1.isEmpty && transactionList2.isEmpty && transactionList3.isEmpty && transactionList4.isEmpty && transactionList5.isEmpty
              
          ?const Center(child: CustomNoData(),)
          :Column(
            children: [
              transactionList1.isNotEmpty
                  ? widget.id == 0
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            children: [
                              Text(
                                "Personal Care",
                                style: GoogleFonts.roboto(
                                    color: PrimaryColor.colorBottleGreen,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.021,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        )
                      : widget.id == 1
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Row(
                                children: [
                                  Text(
                                    "Others",
                                    style: GoogleFonts.roboto(
                                        color: PrimaryColor.colorBottleGreen,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.021,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Row(
                                children: [
                                  Text(
                                    "Investment",
                                    style: GoogleFonts.roboto(
                                        color: PrimaryColor.colorBottleGreen,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.021,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            )
                  : const SizedBox.shrink(),
              TransactionList(
                transactionList: transactionList1,
              ),
              transactionList2.isNotEmpty
                  ? widget.id == 0
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            children: [
                              Text(
                                "Education",
                                style: GoogleFonts.roboto(
                                    color: PrimaryColor.colorBottleGreen,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.021,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        )
                      : widget.id == 1
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Row(
                                children: [
                                  Text(
                                    "Food",
                                    style: GoogleFonts.roboto(
                                        color: PrimaryColor.colorBottleGreen,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.021,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Row(
                                children: [
                                  Text(
                                    "Insurance",
                                    style: GoogleFonts.roboto(
                                        color: PrimaryColor.colorBottleGreen,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.021,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            )
                  : const SizedBox.shrink(),
              TransactionList(
                transactionList: transactionList2,
              ),
              transactionList3.isNotEmpty
                  ? widget.id == 0
                      ? Padding(                        padding: const EdgeInsets.symmetric(horizontal: 12.0),


                        child: Row(
                            children: [
                              Text(
                                "Bills and Utilities",
                                style: GoogleFonts.roboto(
                                    color: PrimaryColor.colorBottleGreen,
                                    fontSize: MediaQuery.of(context).size.height *
                                        0.021,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                      )
                      : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                            children: [
                              Text(
                                "Shopping",
                                style: GoogleFonts.roboto(
                                    color: PrimaryColor.colorBottleGreen,
                                    fontSize: MediaQuery.of(context).size.height *
                                        0.021,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                      )
                  : const SizedBox.shrink(),
              TransactionList(
                transactionList: transactionList3,
              ),
              transactionList4.isNotEmpty
                  ? widget.id == 0
                      ? Padding(                        padding: const EdgeInsets.symmetric(horizontal: 12.0),


                        child: Row(
                            children: [
                              Text(
                                "Rent",
                                style: GoogleFonts.roboto(
                                    color: PrimaryColor.colorBottleGreen,
                                    fontSize: MediaQuery.of(context).size.height *
                                        0.021,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                      )
                      : Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 12.0),

                        child: Row(
                            children: [
                              Text(
                                "Traveling",
                                style: GoogleFonts.roboto(
                                    color: PrimaryColor.colorBottleGreen,
                                    fontSize: MediaQuery.of(context).size.height *
                                        0.021,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                      )
                  : const SizedBox.shrink(),
              TransactionList(
                transactionList: transactionList4,
              ),
              transactionList5.isNotEmpty
                  ? widget.id == 0
                      ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            children: [
                              Text(
                                "Taxes",
                                style: GoogleFonts.roboto(
                                    color: PrimaryColor.colorBottleGreen,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.021,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                            children: [
                              Text(
                                "Entertainment",
                                style: GoogleFonts.roboto(
                                    color: PrimaryColor.colorBottleGreen,
                                    fontSize: MediaQuery.of(context).size.height *
                                        0.021,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                      )
                  : const SizedBox.shrink(),
              TransactionList(
                transactionList: transactionList5,
              ),

            ],
          )
          
        ));
  }
}