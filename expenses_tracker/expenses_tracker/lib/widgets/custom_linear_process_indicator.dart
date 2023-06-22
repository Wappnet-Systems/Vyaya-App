import 'package:flutter/material.dart';
import '../utils/const.dart';
import 'custom_text_style.dart';

class CustomLinearProcessIndicator extends StatelessWidget {
  final double? needsOfTheMonthValue;
  final double? expenseNeedsOfTheValue;
  final double? needProgressValue;
  final Color? colorName,themeColor;
  final String? title;
  const CustomLinearProcessIndicator(
      {super.key,
      required this.title,
      required this.needProgressValue,
      required this.expenseNeedsOfTheValue,
      required this.needsOfTheMonthValue,
      required this.colorName,required this.themeColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        children: [
          Row(
            children: [
              CustomTextStyle(
                  customTextStyleText: "$title",
                  customTextColor: themeColor,
                  customTextFontWeight: FontWeight.w400,
                  customtextstyle: null,
                  customTextSize: MediaQuery.of(context).size.height * 0.021),
              Flexible(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                          value: needProgressValue,
                          backgroundColor: colorName,
                          color: Colors.grey,
                          minHeight: 20,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 7,
                      right: 0,
                      left: 15,
                      bottom: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$expenseNeedsOfTheValue",
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 15,
                      left: 0,
                      bottom: 7,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "$needsOfTheMonthValue",
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              needsOfTheMonthValue! < expenseNeedsOfTheValue!
                  ? Text(
                      "You're spending more than your availability in $title",
                      style: TextStyle(
                          color: PrimaryColor.colorRed,
                          fontSize: MediaQuery.of(context).size.height * 0.015),
                    )
                  : const SizedBox(
                      height: 0,
                    ),
            ],
          ),
        ],
      ),
    );
  }
}