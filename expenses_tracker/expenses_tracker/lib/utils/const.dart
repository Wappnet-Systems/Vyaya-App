import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/category.dart';

class PrimaryColor{
  static Color color_black= const Color(0xff000000);
    static Color color_white = const Color(0xffffffff);

  static Color color_dark_blue = const Color(0xff443AD8);
  static Color color_neon_green =const Color(0xffCAFCC4);

  static Color color_dark_green =const Color(0xff00ac47);
  static Color color_mint_green =const Color(0xff007629);
  static Color color_sea_green =const Color(0xff9adcb2);
  static Color color_bottle_green =const Color(0xff04836B);
  
  static Color color_blue=const Color(0xff2d81f7);
  static Color color_red=Color.fromARGB(255, 212, 64, 64);
  
}

class UserData{
  static String? CurrentUserId;
  static String? CurentUserName;
  static String? CurrentUserEmail;
  static String? CurentUserPhone;
  static String? CurentUserToken;
}

class ListOfAppData{
  static List<Category> listOfCategory=[
    Category(categoryindex: 0, categoryIcon: Icon(Icons.more_horiz,color: PrimaryColor.color_white,size: 30,), categoryText: "Others",categorytype: 1),
    Category(categoryindex: 1, categoryIcon: Icon(Icons.food_bank,color: PrimaryColor.color_white,size: 30,), categoryText: "Food & Dinning",categorytype: 1),
    Category(categoryindex: 2, categoryIcon: Icon(Icons.shopping_cart,color: PrimaryColor.color_white,size: 30,), categoryText: "Shopping",categorytype: 1),
    Category(categoryindex: 3, categoryIcon: Icon(Icons.travel_explore,color: PrimaryColor.color_white,size: 30,), categoryText: "Travelling",categorytype: 1),
    Category(categoryindex: 4, categoryIcon: Icon(Icons.live_tv,color: PrimaryColor.color_white,size: 30,), categoryText: "Entertainment",categorytype: 1),
    Category(categoryindex: 5, categoryIcon: Icon(Icons.personal_injury,color: PrimaryColor.color_white,size: 30,), categoryText: "Personal care",categorytype: 0),
    Category(categoryindex: 6, categoryIcon: Icon(Icons.book,color: PrimaryColor.color_white,size: 30,), categoryText: "Education",categorytype: 0),
    Category(categoryindex: 7, categoryIcon: Icon(Icons.receipt,color: PrimaryColor.color_white,size: 30,), categoryText: "Bills & Utilities",categorytype: 0),
    Category(categoryindex: 8, categoryIcon: Icon(Icons.moving,color: PrimaryColor.color_white,size: 30,), categoryText: "Investment",categorytype: 2),
    Category(categoryindex: 9, categoryIcon: Icon(Icons.home_work,color: PrimaryColor.color_white,size: 30,), categoryText: "Rent",categorytype: 0),
    Category(categoryindex: 10, categoryIcon: Icon(Icons.content_paste_go,color: PrimaryColor.color_white,size: 30,), categoryText: "Taxes",categorytype: 0),
    Category(categoryindex: 11, categoryIcon: Icon(Icons.security,color: PrimaryColor.color_white,size: 30,), categoryText: "Insurances",categorytype: 2),
  ];

  static List<Category> listofIncome=[
    Category(categoryindex: 0, categoryIcon: Icon(Icons.more_horiz,color: PrimaryColor.color_white,size: 30,), categoryText: "Others",categorytype: 3),
    Category(categoryindex: 1, categoryIcon: Icon(Icons.money,color: PrimaryColor.color_white,size: 30,), categoryText: "Salary",categorytype: 3),
    Category(categoryindex: 2, categoryIcon: Icon(Icons.abc,color: PrimaryColor.color_white,size: 30,), categoryText: "Sold Items",categorytype: 3),
    Category(categoryindex: 3, categoryIcon: Icon(Icons.access_time,color: PrimaryColor.color_white,size: 30,), categoryText: "Coupons",categorytype: 3),
    
  ];
}