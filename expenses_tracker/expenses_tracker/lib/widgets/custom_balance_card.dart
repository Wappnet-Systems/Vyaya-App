import 'package:flutter/material.dart';

import '../utils/const.dart';
import 'custom_textstyle.dart';

class CustomBalanceCard extends StatelessWidget {
  final balance_of_the_month_value;
  CustomBalanceCard({super.key,required this.balance_of_the_month_value});

  @override
  Widget build(BuildContext context) {
    return Center(
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                  child: balance_of_the_month_value! > 0
                                      ? CustomTextStyle(
                                          customtextstyletext:
                                              "Balance: ₹${balance_of_the_month_value}",
                                          customtextcolor:
                                              PrimaryColor.color_black,
                                          customtextfontweight:
                                              FontWeight.normal,
                                          customtextstyle: null,
                                          customtextsize: 15.0)
                                      : CustomTextStyle(
                                          customtextstyletext:
                                              "Balance: - ₹${balance_of_the_month_value?.abs()}",
                                          customtextcolor:
                                              PrimaryColor.color_black,
                                          customtextfontweight:
                                              FontWeight.normal,
                                          customtextstyle: null,
                                          customtextsize: 15.0)),
                            )),
                      );
  }
}