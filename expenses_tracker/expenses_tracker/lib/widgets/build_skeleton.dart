import 'package:expenses_tracker/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'custom_header.dart';
import 'custom_text_style.dart';

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
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
                stops: const [0.1, 0.5, 0.9],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomHeader(
                      initialOfName: "...",
                      username: "....",
                      wishingText: "...",
                      textColor: PrimaryColor.colorBlack),
                  const SizedBox(height: 25),
                  CustomTextStyle(
                      customTextStyleText: "Current Month",
                      customTextColor: PrimaryColor.colorBlack,
                      customTextFontWeight: FontWeight.normal,
                      customtextstyle: null,
                      customTextSize: 25.0),
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
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.43,
                          height: MediaQuery.of(context).size.height * 0.08,
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: Colors.grey[100]!,
                        child: SizedBox(
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
                      child: SizedBox(
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
                            customTextStyleText: "Personal Finance",
                            customTextColor: PrimaryColor.colorBlack,
                            customTextFontWeight: FontWeight.bold,
                            customtextstyle: null,
                            customTextSize: 20),
                        const CustomTextStyle(
                            customTextStyleText: "Set Manually",
                            customTextColor: Colors.blueAccent,
                            customTextFontWeight: FontWeight.bold,
                            customtextstyle: null,
                            customTextSize: 14),
                      ],
                    ),
                  ),
                  Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: Colors.grey[100]!,
                      child: SizedBox(
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
                            customTextStyleText: "Recent Transaction",
                            customTextColor: PrimaryColor.colorBlack,
                            customTextFontWeight: FontWeight.bold,
                            customtextstyle: null,
                            customTextSize: 20),
                        const CustomTextStyle(
                            customTextStyleText: "View all",
                            customTextColor: Colors.blueAccent,
                            customTextFontWeight: FontWeight.bold,
                            customtextstyle: null,
                            customTextSize: 14),
                      ],
                    ),
                  ),
                  Card(
                    color: Colors.grey[100]!,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.112,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  Card(
                    color: Colors.grey[100]!,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    child: SizedBox(
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
