import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'custom_text_style.dart';


class CustomCard extends StatelessWidget {
  final int? speOrIncMonthValue;
  final Icon? icon;
  final Color? color, themeColor;
  final String? title;

  const CustomCard({
    Key? key,
    required this.color,
    required this.icon,
    required this.speOrIncMonthValue,
    required this.title,
    required this.themeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    // Mobile and tablet view
    if (screenWidth < 600) {
      return _buildMobileTableView(context);
    }
    // Desktop view
    else if (screenWidth >= 600 && screenWidth < 1200) {
      return _buildDesktopView(context);
    }
    // Large screen view
    else {
      return _buildLargeScreenView(context);
    }
  }

  Widget _buildMobileTableView(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: color,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.45,
        height: MediaQuery.of(context).size.height * 0.08,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60)),
                color: themeColor,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.14,
                  height: MediaQuery.of(context).size.width * 0.14,
                  child: icon,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextStyle(
                  customTextStyleText: "$title",
                  customTextColor: themeColor,
                  customTextFontWeight: FontWeight.normal,
                  customtextstyle: null,
                  customTextSize: 14.0,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  child: Text(
                    formatCurrency(speOrIncMonthValue),
                    style: TextStyle(
                      color: themeColor,
                      fontSize: 14.0,
                    ),
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopView(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 5.3,
      height: MediaQuery.of(context).size.height * 0.095,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: color,
        child: Row(
          children: [
            Expanded(
              flex:35,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.080,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60)),
                  color: themeColor,
                  child: icon,
                ),
              ),
            ),
            Expanded(
              flex:65,              
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.070,
                    child: Text(
                      "$title",
                      style: TextStyle(
                        color: themeColor,
                        fontSize: MediaQuery.sizeOf(context).height*0.018,
                        fontWeight: FontWeight.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.070,
                    child: Text(
                      formatCurrency(speOrIncMonthValue),
                      style: TextStyle(
                        color: themeColor,
                        fontSize: MediaQuery.sizeOf(context).height*0.020,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLargeScreenView(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 5.0,
      height: MediaQuery.of(context).size.height * 0.12,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: color,
        child: Row(
          children: [
            Expanded(
              flex:20,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.095,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60)),
                  color: themeColor,
                  child: icon,
                ),
              ),
            ),
            Expanded(
              flex:65,              
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.085,
                    child: Text(
                      "$title",
                      style: TextStyle(
                        color: themeColor,
                        fontSize: MediaQuery.sizeOf(context).height*0.022,
                        fontWeight: FontWeight.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.070,
                    child: Text(
                      formatCurrency(speOrIncMonthValue),
                      style: TextStyle(
                        color: themeColor,
                        fontSize: MediaQuery.sizeOf(context).height*0.025,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String formatCurrency(int? value) {
    NumberFormat currencyFormat = NumberFormat.currency(
      symbol: '₹',
      locale: "HI",
      decimalDigits: 0,
    );
    return currencyFormat.format(value);
  }
}
