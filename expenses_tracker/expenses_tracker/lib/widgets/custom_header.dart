import 'package:flutter/material.dart';

import '../utils/const.dart';
import 'custom_textstyle.dart';

class CustomHeader extends StatelessWidget {
  final String? wishingtext,username,initial_of_name;
  final Color? textColor;
  CustomHeader({super.key,required this.initial_of_name,required this.username,required this.wishingtext,required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CustomTextStyle(
                                    customtextstyletext: "$wishingtext",
                                    customtextcolor: textColor,
                                    customtextfontweight: FontWeight.normal,
                                    customtextsize: 17.0,
                                    customtextstyle: null,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CustomTextStyle(
                                    customtextstyletext: "$username",
                                    customtextcolor: textColor,
                                    customtextfontweight: FontWeight.bold,
                                    customtextsize: 22.0,
                                    customtextstyle: null,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: MediaQuery.of(context).size.height * 0.065,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              color: PrimaryColor.color_bottle_green,
                              child: Center(
                                  child: Text(
                                "$initial_of_name",
                                style: TextStyle(
                                    color: PrimaryColor.color_white,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.035),
                              )),
                            ),
                          )
                           ],
                      );
  }
}