import 'package:flutter/material.dart';

class Category{
  final int? categoryIndex;
  final Icon? categoryIcon;
  final String? categoryText;
  final int? categoryType;
  bool? isSelected;

  Category({required this.categoryIndex,required this.categoryIcon,required this.categoryText,required this.categoryType,this.isSelected});
}