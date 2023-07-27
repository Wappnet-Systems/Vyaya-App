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
    final bool isMobileOrTablet = MediaQuery.of(context).size.width < 600;
    final bool isDesktop = MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < 1200;
    final bool isLargeScreen = MediaQuery.of(context).size.width >= 1200;

    // Font size for mobile/tablet
    const double titleFontSizeMobile = 15.0;
    const double timeStampFontSizeMobile = 12.0;
    const double amountFontSizeMobile = 14.0;

    // Card width for mobile/tablet
    final double cardWidthMobile = MediaQuery.of(context).size.width;

    // Font size for desktop
    double titleFontSizeDesktop = MediaQuery.of(context).size.height*0.018;
    double timeStampFontSizeDesktop = MediaQuery.of(context).size.height*0.015;
    double amountFontSizeDesktop = MediaQuery.of(context).size.height*0.018;

    // Card width for desktop
    final double cardWidthDesktop = MediaQuery.of(context).size.width / 4;

    // Font size for large screen
    double titleFontSizeLargeScreen = MediaQuery.of(context).size.height*0.022;
    double timeStampFontSizeLargeScreen = MediaQuery.of(context).size.height*0.018;
    double amountFontSizeLargeScreen = MediaQuery.of(context).size.height*0.022;

    // Card width for large screen
    final double cardWidthLargeScreen = MediaQuery.of(context).size.width / 4;

    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Card(
        color: Theme.of(context).cardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.095,
          width: isMobileOrTablet
              ? cardWidthMobile
              : isDesktop
                  ? cardWidthDesktop
                  : cardWidthLargeScreen,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.08,
                      width: isMobileOrTablet
                          ? MediaQuery.of(context).size.width * 0.11
                          : isDesktop
                              ? MediaQuery.of(context).size.width * 0.08
                              : MediaQuery.of(context).size.width * 0.06,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height:
                                MediaQuery.of(context).size.width * 0.14,
                            width: isMobileOrTablet
                                ? MediaQuery.of(context).size.width * 0.16
                                : isDesktop
                                    ? MediaQuery.of(context).size.width *
                                        0.070
                                    : MediaQuery.of(context).size.width *
                                        0.045,
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
                            right: isLargeScreen ?8 :-2,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height *
                                  0.028,
                              width: isMobileOrTablet
                                  ? MediaQuery.of(context).size.width *
                                      0.062
                                  : isDesktop
                                      ? MediaQuery.of(context).size.width *
                                          0.040
                                      : MediaQuery.of(context).size.width *
                                          0.015,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(60),
                                ),
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
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 03,
                    ),
                    SizedBox(
                      width: isMobileOrTablet
                                ? MediaQuery.of(context).size.width / 2
                                : isDesktop
                                    ? MediaQuery.of(context).size.width *0.10
                                    : MediaQuery.of(context).size.width / 6,
                            
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$transactionNote",
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            style: GoogleFonts.roboto(
                              color: textTheme,
                              fontSize: isMobileOrTablet
                                  ? titleFontSizeMobile
                                  : isDesktop
                                      ? titleFontSizeDesktop
                                      : titleFontSizeLargeScreen,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            '$dateStamp \t$timeStamp',
                            maxLines: 1,
                            style: TextStyle(
                              color: textTheme,
                              fontSize: isMobileOrTablet
                                  ? timeStampFontSizeMobile
                                  : isDesktop
                                      ? timeStampFontSizeDesktop
                                      : timeStampFontSizeLargeScreen,
                            ),
                            overflow: TextOverflow.fade,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: isMobileOrTablet
                          ? MediaQuery.of(context).size.width / 3.5
                          : isDesktop
                              ? MediaQuery.of(context).size.width *0.075
                              : MediaQuery.of(context).size.width / 6.0,
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          indianRupeesFormat.format(transactionAmount),
                          style: GoogleFonts.roboto(
                            color: categoryId == 0 || categoryId == 3
                                ? PrimaryColor.colorBottleGreen
                                : PrimaryColor.colorRed,
                            fontSize: isMobileOrTablet
                                ? amountFontSizeMobile
                                : isDesktop
                                    ? amountFontSizeDesktop
                                    : amountFontSizeLargeScreen,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
