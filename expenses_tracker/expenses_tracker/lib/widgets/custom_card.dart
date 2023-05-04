import 'package:flutter/material.dart';

import '../utils/const.dart';
import 'custom_textstyle.dart';

class CustomCard extends StatelessWidget {
  final int? spe_or_inc_month_value;
  final Icon? icon;
  final Color? color,themecolor;
  final String? title;
  CustomCard({super.key,required this.color,required this.icon,required this.spe_or_inc_month_value,required this.title,required this.themecolor});

  @override
  Widget build(BuildContext context) {

    return Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              color: color,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.43,
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(60)),
                                        color: themecolor,
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.14,
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          child: icon
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomTextStyle(
                                            customtextstyletext: "$title",
                                            customtextcolor:
                                              themecolor,
                                            customtextfontweight:
                                                FontWeight.normal,
                                            customtextstyle: null,
                                            customtextsize: 16.0),
                                        CustomTextStyle(
                                            customtextstyletext:
                                                "₹${spe_or_inc_month_value}",
                                            customtextcolor:
                                                themecolor,
                                            customtextfontweight:
                                                FontWeight.bold,
                                            customtextstyle: null,
                                            customtextsize: 14.5),
                                      ],
                                    )
                                  ],
                                ),
                              ));
  }
}