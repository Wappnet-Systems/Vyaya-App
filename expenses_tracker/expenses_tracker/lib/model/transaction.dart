import 'package:cloud_firestore/cloud_firestore.dart';

class AllTransactionDetails {
  final String? uId;
  final String? tID;
  final Timestamp? transactionDate;
  final int? transactionAmount;
  final int? transactionCategory;
  final int? transactionSubcategory;
  final int? transactionSubcategoryIndex;
  final String? transactionNote;
  final String? transactionPaymentMode;
  final Timestamp? transactionCreatedAt;

  
  AllTransactionDetails(
      {required this.uId,
      required this.tID,
      required this.transactionDate,
      required this.transactionAmount,
      required this.transactionCategory,
      required this.transactionSubcategory,
      required this.transactionSubcategoryIndex,
      required this.transactionNote,
      required this.transactionPaymentMode,
      required this.transactionCreatedAt});

  static fromJson(Map<String, dynamic> data) {}

  // AllTransactionDetails({required this.transactionAmount,required this.transactionCategory,required this.transactionDate,required this.transactionNote,required this.transactionPaymentMode,required this.transactionSubcategory,required this.uId});
}
