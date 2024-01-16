import 'package:flutter/material.dart';

import '../utils/const.dart';

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
          width: MediaQuery.of(context).size.width * 0.50,
          child: Card(
            color: themeColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: PrimaryColor.colorWhite),
            ),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: balanceOfTheMonthValue > 0
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * 0.50,
                      child: Center(
                        child: Text(
                          "Balance: ₹$balanceOfTheMonthValue",
                          style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                         
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    )
                  : SizedBox(
                      width: MediaQuery.of(context).size.width * 0.50,
                      child: Center(
                        child: Text(
                            "Balance: -₹${balanceOfTheMonthValue.abs()}",
                            
                            style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
            )),
          )),
    );
  }
}
