import 'package:flutter/material.dart';

import 'custom_text_style.dart';

class CustomNoData extends StatelessWidget {
  const CustomNoData({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomTextStyle(
        customTextStyleText: "No Data",
        customTextColor: Theme.of(context).hintColor,
        customTextFontWeight: FontWeight.bold,
        customtextstyle: null,
        customTextSize: MediaQuery.of(context).size.height * 0.025);
  }
}
