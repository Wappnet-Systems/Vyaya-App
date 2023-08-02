import 'package:flutter/material.dart';

import '../utils/const.dart';

class CustomBalanceCard extends StatelessWidget {
  final int balanceOfTheMonthValue;
  final Color? themeColor, textThemeColor;

  const CustomBalanceCard({
    Key? key,
    required this.balanceOfTheMonthValue,
    required this.themeColor,
    required this.textThemeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isDesktop =
        mediaQuery.size.width > 600; // Adjust the breakpoint as needed

    return Center(
      child: SizedBox(
        height: isDesktop
            ? mediaQuery.size.height * 0.1
            : mediaQuery.size.height * 0.05,
        width: isDesktop
            ? mediaQuery.size.width * 0.2
            : mediaQuery.size.width * 0.5,
        child: Card(
          color: themeColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isDesktop ? 30 : 20),
            side: BorderSide(color: PrimaryColor.colorWhite),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: balanceOfTheMonthValue > 0
                  ? SizedBox(
                      width: isDesktop
                          ? mediaQuery.size.width * 0.2
                          : mediaQuery.size.width * 0.35,
                      child: Center(
                        child: Text(
                          "Balance: ₹$balanceOfTheMonthValue",
                          style: TextStyle(
                            color: textThemeColor,
                            fontWeight: FontWeight.normal,
                            fontSize: isDesktop
                                ? mediaQuery.size.height * 0.018
                                : mediaQuery.size.height * 0.018,
                          ),
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    )
                  : SizedBox(
                      width: isDesktop
                          ? mediaQuery.size.width * 0.2
                          : mediaQuery.size.width * 0.5,
                      child: Center(
                        child: Text(
                          "Balance: -₹${balanceOfTheMonthValue.abs()}",
                          style: TextStyle(
                            color: textThemeColor,
                            fontWeight: FontWeight.normal,
                            fontSize: isDesktop
                                ? mediaQuery.size.width * 0.0001
                                : mediaQuery.size.width * 0.005,
                          ),
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
