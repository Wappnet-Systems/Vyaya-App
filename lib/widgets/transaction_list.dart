import 'package:expenses_tracker/screens/transaction_screen.dart';
import 'package:expenses_tracker/widgets/fade_transition.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:show_up_animation/show_up_animation.dart';
import '../utils/functions.dart';
import '../widgets/custom_transaction.dart';
import '../model/transaction.dart';
import '../utils/const.dart';

class TransactionList extends StatelessWidget {
  final List<AllTransactionDetails> transactionList;

  const TransactionList({super.key, required this.transactionList});

  @override
  Widget build(BuildContext context) {
    return transactionList.isNotEmpty
        ? Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactionList.length,
                itemBuilder: (BuildContext context, int i) {
                  return Column(
                    children: [
                      if (i == 0 ||
                          isDifferentDay(
                              transactionList[i].transactionDate!,
                              transactionList[i - 1].transactionDate!))
                        SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.040,
                            width: MediaQuery.sizeOf(context).width / 3.5,
                            child: Card(
                                color: Theme.of(context).colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                        getDatestamp(transactionList[i]
                                            .transactionDate!
                                            ),
                                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary)
                                        
                                                ),
                                  ],
                                ))),
                      ShowUpAnimation(
                        animationDuration: const Duration(milliseconds: 750),
                        direction: Direction.horizontal,
                        offset: i % 2==0 ?-0.5 :0.5,
                        child: GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(
                                FadeSlideTransitionRoute(
                                  page: TransactionScreen(
                                    id: 2,
                                    transactionPaymentMode: transactionList[i].transactionPaymentMode,
                                    transactionId: transactionList[i].tID,
                                    transactionNote:
                                        transactionList[i].transactionNote,
                                    transactionAmount:
                                        transactionList[i].transactionAmount,
                                    transactionSubcategoryIndex:
                                        transactionList[i].transactionSubcategoryIndex!,
                                    transactionDate:
                                        "${DateFormat.yMMMd().format(transactionList[i].transactionDate!)} ${DateFormat.jm().format(transactionList[i].transactionDate!)}",
                                    transactionSubcategory: transactionList[i].transactionSubcategory,
                                    transactionCategory:
                                        transactionList[i].transactionCategory,
                                  ),
                                   
                                ),
                              );
                          },
                          child: CustomTransaction(
                            iconColor: PrimaryColor.colorRed,
                            categoryId: transactionList[i].transactionCategory,
                            subCateId:
                                transactionList[i].transactionSubcategoryIndex,
                            transactionAmount:
                                transactionList[i].transactionAmount,
                            transactionNote: transactionList[i].transactionNote,
                            dateStamp: DateFormat.yMMMd().format(
                              transactionList[i].transactionDate!,
                            ),
                            timeStamp: DateFormat.jm().format(
                              transactionList[i].transactionDate!,
                            ),
                            themeColor: Theme.of(context).colorScheme.primary,
                            textTheme: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}
