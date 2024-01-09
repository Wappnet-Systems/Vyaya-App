import 'package:flutter/material.dart';

double wp(double percentage, context) {
  double result = (MediaQuery.of(context).size.width / percentage) / 100;
  return result;
}

double hp(double percentage, context) {
  double result = (MediaQuery.of(context).size.height * percentage) / 100;
  return result;
}

double dp(BuildContext context, double size) {
  return size * MediaQuery.textScaleFactorOf(context);
}
