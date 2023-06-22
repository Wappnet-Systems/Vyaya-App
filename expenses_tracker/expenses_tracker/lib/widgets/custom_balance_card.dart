import 'package:flutter/material.dart';

import '../utils/const.dart';
import 'custom_text_style.dart';

class CustomBalanceCard extends StatelessWidget {
  final int balanceOfTheMonthValue;
  final Color? themeColor, textThemeColor;
  const CustomBalanceCard(
      {super.key,
      required this.balanceOfTheMonthValue,
      required this.themeColor,
      required this.textThemeColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
          width: MediaQuery.of(context).size.width * 0.45,
          child: Card(
            color: themeColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: PrimaryColor.colorWhite),
            ),
            child: Center(
                child: balanceOfTheMonthValue > 0
                    ? CustomTextStyle(
                        customTextStyleText:
                            "Balance: ₹$balanceOfTheMonthValue",
                        customTextColor: textThemeColor,
                        customTextFontWeight: FontWeight.normal,
                        customtextstyle: null,
                        customTextSize: 15.0)
                    : CustomTextStyle(
                        customTextStyleText:
                            "Balance: - ₹${balanceOfTheMonthValue.abs()}",
                        customTextColor: textThemeColor,
                        customTextFontWeight: FontWeight.normal,
                        customtextstyle: null,
                        customTextSize: 15.0)),
          )),
    );
  }
}