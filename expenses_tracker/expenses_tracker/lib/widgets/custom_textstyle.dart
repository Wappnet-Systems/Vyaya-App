import 'dart:ffi';

import 'package:expenses_tracker/utils/const.dart';
import 'package:flutter/material.dart';

class CustomTextStyle extends StatelessWidget {
  final String? customtextstyletext;
  final Color? customtextcolor;
  final FontWeight? customtextfontweight;
  final FontStyle? customtextstyle;
  final double? customtextsize;
  CustomTextStyle({required this.customtextstyletext,required this.customtextcolor,required this.customtextfontweight,required this.customtextstyle,required this.customtextsize});

  @override
  Widget build(BuildContext context) {
    return Text('$customtextstyletext',style: TextStyle(color: customtextcolor,fontWeight: customtextfontweight,fontSize:customtextsize),);
    
  }
}