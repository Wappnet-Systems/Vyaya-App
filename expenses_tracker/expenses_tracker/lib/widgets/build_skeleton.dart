import 'package:expenses_tracker/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'custom_balance_card.dart';
import 'custom_card.dart';
import 'custom_header.dart';
import 'custom_textstyle.dart';

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer(
              period: const Duration(milliseconds: 1500),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.grey[300]!,
                  Colors.grey[100]!,
                  Colors.grey[300]!
                ],
                stops: [0.1, 0.5, 0.9],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomHeader(
                      initial_of_name: "...",
                      username: "....",
                      wishingtext: "..."),
                  const SizedBox(height: 25),
                  CustomTextStyle(
                      customtextstyletext: "Current Month",
                      customtextcolor: PrimaryColor.color_black,
                      customtextfontweight: FontWeight.normal,
                      customtextstyle: null,
                      customtextsize: 25.0),
                  const SizedBox(
                    height: 7,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: Colors.grey[100]!,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.43,
                          height: MediaQuery.of(context).size.height * 0.08,
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: Colors.grey[100]!,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.43,
                          height: MediaQuery.of(context).size.height * 0.08,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Card(
                            color: Colors.grey[100]!,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ))),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextStyle(
                            customtextstyletext: "Personal Finance",
                            customtextcolor: PrimaryColor.color_black,
                            customtextfontweight: FontWeight.bold,
                            customtextstyle: null,
                            customtextsize: 20),
                        CustomTextStyle(
                            customtextstyletext: "Set Manually",
                            customtextcolor: Colors.blueAccent,
                            customtextfontweight: FontWeight.bold,
                            customtextstyle: null,
                            customtextsize: 14),
                      ],
                    ),
                  ),
                  Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: Colors.grey[100]!,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.30,
                        width: MediaQuery.of(context).size.width,
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextStyle(
                            customtextstyletext: "Recent Transaction",
                            customtextcolor: PrimaryColor.color_black,
                            customtextfontweight: FontWeight.bold,
                            customtextstyle: null,
                            customtextsize: 20),
                        CustomTextStyle(
                            customtextstyletext: "View all",
                            customtextcolor: Colors.blueAccent,
                            customtextfontweight: FontWeight.bold,
                            customtextstyle: null,
                            customtextsize: 14),
                      ],
                    ),
                  ),
                  Card(
                    color: Colors.grey[100]!,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.112,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  Card(
                    color: Colors.grey[100]!,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.112,
                      width: MediaQuery.of(context).size.width,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
