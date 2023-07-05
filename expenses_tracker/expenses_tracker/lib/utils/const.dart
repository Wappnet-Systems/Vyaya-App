import 'package:flutter/material.dart';
import '../model/category.dart';

class PrimaryColor{
  static Color colorBlack= const Color(0xff000000);
  static Color colorWhite = const Color(0xffffffff);
  static Color colorBottleGreen =const Color(0xff04836B);
  static Color colorBlue=const Color(0xff2d81f7);
  static Color colorRed=const Color(0xFFFF4040);
}

class UserData{
  static String? currentUserId;
  static String? currentUserName;
  static String? currentUserEmail;
  static String? userIdForLocal;
}

class ListOfAppData{
  static List<Category> listOfCategory=[
    Category(categoryIndex: 0, categoryIcon: Icon(Icons.more_horiz,color: PrimaryColor.colorWhite,size: 30,), categoryText: "Others",categoryType: 1),
    Category(categoryIndex: 1, categoryIcon: Icon(Icons.food_bank,color: PrimaryColor.colorWhite,size: 30,), categoryText: "Food & Dinning",categoryType: 1),
    Category(categoryIndex: 2, categoryIcon: Icon(Icons.shopping_cart,color: PrimaryColor.colorWhite,size: 30,), categoryText: "Shopping",categoryType: 1),
    Category(categoryIndex: 3, categoryIcon: Icon(Icons.travel_explore,color: PrimaryColor.colorWhite,size: 30,), categoryText: "Traveling",categoryType: 1),
    Category(categoryIndex: 4, categoryIcon: Icon(Icons.live_tv,color: PrimaryColor.colorWhite,size: 30,), categoryText: "Entertainment",categoryType: 1),
    Category(categoryIndex: 5, categoryIcon: Icon(Icons.personal_injury,color: PrimaryColor.colorWhite,size: 30,), categoryText: "Personal care",categoryType: 0),
    Category(categoryIndex: 6, categoryIcon: Icon(Icons.book,color: PrimaryColor.colorWhite,size: 30,), categoryText: "Education",categoryType: 0),
    Category(categoryIndex: 7, categoryIcon: Icon(Icons.receipt,color: PrimaryColor.colorWhite,size: 30,), categoryText: "Bills & Utilities",categoryType: 0),
    Category(categoryIndex: 8, categoryIcon: Icon(Icons.moving,color: PrimaryColor.colorWhite,size: 30,), categoryText: "Investment",categoryType: 2),
    Category(categoryIndex: 9, categoryIcon: Icon(Icons.home_work,color: PrimaryColor.colorWhite,size: 30,), categoryText: "Rent",categoryType: 0),
    Category(categoryIndex: 10, categoryIcon: Icon(Icons.content_paste_go,color: PrimaryColor.colorWhite,size: 30,), categoryText: "Taxes",categoryType: 0),
    Category(categoryIndex: 11, categoryIcon: Icon(Icons.security,color: PrimaryColor.colorWhite,size: 30,), categoryText: "Insurances",categoryType: 2),
  ];

  static List<Category> listOfIncome=[
    Category(categoryIndex: 0, categoryIcon: Icon(Icons.more_horiz,color: PrimaryColor.colorWhite,size: 30,), categoryText: "Others",categoryType: 3),
    Category(categoryIndex: 1, categoryIcon: Icon(Icons.money,color: PrimaryColor.colorWhite,size: 30,), categoryText: "Salary",categoryType: 3),
    Category(categoryIndex: 2, categoryIcon: Icon(Icons.abc,color: PrimaryColor.colorWhite,size: 30,), categoryText: "Sold Items",categoryType: 3),
    Category(categoryIndex: 3, categoryIcon: Icon(Icons.access_time,color: PrimaryColor.colorWhite,size: 30,), categoryText: "Coupons",categoryType: 3),    
  ];
}