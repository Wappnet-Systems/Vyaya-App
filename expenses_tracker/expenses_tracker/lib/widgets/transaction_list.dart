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
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    final bool isDesktopOrLargeScreen =
        MediaQuery.of(context).size.width >= 600;

    return transactionList.isNotEmpty
        ? Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactionList.length,
                itemBuilder: (BuildContext context, int i) {
                  return ShowUpAnimation(                    
                        animationDuration: const Duration(milliseconds: 1000),
                        direction: Direction.horizontal,
                        offset: i % 2 == 0 ? -0.5 : 0.5,
                    child: Column(
                      children: [
                        if (i == 0 ||
                            isDifferentDay(
                                transactionList[i].transactionDate!,
                                transactionList[i - 1].transactionDate!))
                          SizedBox(
                            height: isMobile
                                ? MediaQuery.of(context).size.height * 0.040
                                : MediaQuery.of(context).size.height * 0.045,
                            width: isMobile
                                ? MediaQuery.of(context).size.width / 3.5
                                : MediaQuery.of(context).size.width * 0.15,
                            child: Card(
                              color: Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                child: Text(
                                  getDatestamp(
                                      transactionList[i].transactionDate!),
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                              ),
                            ),
                          ),
                        SizedBox(
                          width: isMobile
                                ? MediaQuery.of(context).size.width
                                : MediaQuery.of(context).size.width / 2,
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
                      ],
                    ),
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
