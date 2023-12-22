import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CustomTextStyle extends StatelessWidget {
  final String? customTextStyleText;
  final Color? customTextColor;
  final FontWeight? customTextFontWeight;
  final FontStyle? customTextStyle;
  final double? customTextSize;
  TextAlign? textAlign;
  CustomTextStyle({super.key, required this.customTextStyleText,required this.customTextColor,required this.customTextFontWeight,required this.customTextStyle,required this.customTextSize,this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text('$customTextStyleText',style: GoogleFonts.roboto(
    color: customTextColor,
    fontSize: customTextSize,
    fontWeight: customTextFontWeight,
  ),
  overflow: TextOverflow.fade,
  maxLines: 1,
  textAlign: textAlign ?? TextAlign.left,
  );
    
  }
}