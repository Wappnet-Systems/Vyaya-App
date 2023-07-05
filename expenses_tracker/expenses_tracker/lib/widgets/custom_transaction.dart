import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../utils/const.dart';

class CustomTransaction extends StatelessWidget {
  final Color? iconColor, themeColor, textTheme;
  final int? categoryId, subCateId, transactionAmount;
  final String? transactionNote, dateStamp, timeStamp;
  const CustomTransaction(
      {super.key,
      required this.iconColor,
      required this.categoryId,
      required this.subCateId,
      required this.transactionAmount,
      required this.transactionNote,
      required this.dateStamp,
      required this.timeStamp,
      required this.themeColor,
      required this.textTheme});

  @override
  Widget build(BuildContext context) {
    final indianRupeesFormat = NumberFormat.currency(
      name: "INR",
      locale: 'en_IN',
      decimalDigits: 0, // change it to get decimal places
      symbol: '₹ ',
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Card(
        color: Theme.of(context).cardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.095,
          width: MediaQuery.of(context).size.width,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.08,
                        width: MediaQuery.of(context).size.width * 0.18,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.16,
                              width: MediaQuery.of(context).size.width * 0.16,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60)),
                                color: categoryId == 0 || categoryId == 3
                                    ? PrimaryColor.colorBottleGreen
                                    : PrimaryColor.colorRed,
                                child: categoryId == 0 || categoryId == 3
                                    ? ListOfAppData
                                        .listOfIncome[subCateId!].categoryIcon
                                    : ListOfAppData.listOfCategory[subCateId!]
                                        .categoryIcon,
                              ),
                            ),
                            Positioned(
                                bottom: 5,
                                right: 2,
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.028,
                                  width:
                                      MediaQuery.of(context).size.width * 0.062,
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(60)),
                                      elevation: 5,
                                      child: categoryId == 0 || categoryId == 3
                                          ? Icon(
                                              Icons.arrow_downward,
                                              color:
                                                  PrimaryColor.colorBottleGreen,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.015,
                                            )
                                          : Icon(
                                              Icons.arrow_upward,
                                              color: PrimaryColor.colorRed,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.015,
                                            )),
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 03,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width/2.5,
                            child: Text(
                              "$transactionNote",
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              style: GoogleFonts.roboto(
                                  color: textTheme,
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.021,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '$dateStamp \t$timeStamp',
                                style: TextStyle(
                                    color: textTheme,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.016),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width/3.5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(                                                      
                            NumberFormat.currency(
                              symbol: categoryId == 0 || categoryId == 3 ?'+ ₹' :"- ₹",
                              locale: "HI",
                              decimalDigits: 0,
                            ).format(transactionAmount),
                          
                            style: GoogleFonts.roboto(
                                color: categoryId == 0 || categoryId == 3
                                      ? PrimaryColor.colorBottleGreen
                                      : PrimaryColor.colorRed,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.020,
                                fontWeight: FontWeight.w500),
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                textAlign: TextAlign.end,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
