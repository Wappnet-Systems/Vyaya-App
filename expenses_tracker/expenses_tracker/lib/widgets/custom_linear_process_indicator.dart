import 'package:flutter/material.dart';

import '../utils/const.dart';
import 'custom_textstyle.dart';

class CustomLinearProcessIndicator extends StatelessWidget {
  final double? needs_of_the_month_value;
  final double? expense_needs_of_the_value;
  final double? needprogressValue;
  final Color? color_name;
  final String? title;
  CustomLinearProcessIndicator(
      {super.key,
      required this.title,
      required this.needprogressValue,
      required this.expense_needs_of_the_value,
      required this.needs_of_the_month_value,
      required this.color_name});

  @override
  Widget build(BuildContext context) {

    return 
    Padding(
      
      // ?padding:  EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0)
       padding:  EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        children: [
          Row(
            children: [
              CustomTextStyle(
                  customtextstyletext: "$title",
                  customtextcolor: Colors.black38,
                  customtextfontweight: FontWeight.bold,
                  customtextstyle: null,
                  customtextsize: MediaQuery.of(context).size.height * 0.021),
              Flexible(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                          value: needprogressValue,
                          backgroundColor: color_name,
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
                            "${expense_needs_of_the_value}",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
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
                            "${needs_of_the_month_value}",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
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
              needs_of_the_month_value! < expense_needs_of_the_value!
                  ? Text(
                      "You're spending more than your availability in $title",
                      style: TextStyle(
                          color: PrimaryColor.color_red,
                          fontSize: MediaQuery.of(context).size.height * 0.015),
                    )
                  : SizedBox(
                      height: 0,
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
