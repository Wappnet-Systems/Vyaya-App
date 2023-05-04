import 'package:flutter/material.dart';

import 'custom_textstyle.dart';

class CustomNoData extends StatelessWidget {
  const CustomNoData({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomTextStyle(
        customtextstyletext: "No Data",
        customtextcolor: Theme.of(context).hintColor,
        customtextfontweight: FontWeight.bold,
        customtextstyle: null,
        customtextsize: MediaQuery.of(context).size.height * 0.025);
  }
}
