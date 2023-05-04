import 'package:flutter/material.dart';

import '../utils/const.dart';
import 'custom_textstyle.dart';

class CustomBalanceCard extends StatelessWidget {
  final balance_of_the_month_value;
  final Color? theme_color,text_theme_color;
  CustomBalanceCard({super.key,required this.balance_of_the_month_value,required this.theme_color,required this.text_theme_color});

  @override
  Widget build(BuildContext context) {
    return Center(
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Card(
                              color: theme_color,
                              shape: RoundedRectangleBorder(
                                
                                  borderRadius: BorderRadius.circular(20),side: BorderSide(color: PrimaryColor.color_white),),
                              child: Center(
                                  child: balance_of_the_month_value! > 0
                                      ? CustomTextStyle(
                                          customtextstyletext:
                                              "Balance: ₹${balance_of_the_month_value}",
                                          customtextcolor:
                                              text_theme_color,
                                          customtextfontweight:
                                              FontWeight.normal,
                                          customtextstyle: null,
                                          customtextsize: 15.0)
                                      : CustomTextStyle(
                                          customtextstyletext:
                                              "Balance: - ₹${balance_of_the_month_value?.abs()}",
                                          customtextcolor:
                                              text_theme_color,
                                          customtextfontweight:
                                              FontWeight.normal,
                                          customtextstyle: null,
                                          customtextsize: 15.0)),
                            )),
                      );
  }
}