import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextStyle extends StatelessWidget {
  final String? customTextStyleText;
  final Color? customTextColor;
  final FontWeight? customTextFontWeight;
  final FontStyle? customtextstyle;
  final double? customTextSize;
  const CustomTextStyle({super.key, required this.customTextStyleText,required this.customTextColor,required this.customTextFontWeight,required this.customtextstyle,required this.customTextSize});

  @override
  Widget build(BuildContext context) {
    return Text('$customTextStyleText',style: GoogleFonts.roboto(
    color: customTextColor,
    fontSize: customTextSize,
    fontWeight: customTextFontWeight,
  ),
  // textAlign: TextAlign.center,
  );
    
  }
}