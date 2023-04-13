import 'package:cloud_firestore/cloud_firestore.dart';

class AllTransactionDetails {
  final String? uId;
  final String? tID;
  final Timestamp? transactionDate;
  final int? transactionAmount;
  final int? transactioncategory;
  final int? transactionsubcategory;
  final int? transactionsubcategoryindex;
  final String? transactionnote;
  final String? transactionpaymentmode;
  final Timestamp? transactionCreatedAt;

  AllTransactionDetails(
      {required this.uId,
      required this.tID,
      required this.transactionDate,
      required this.transactionAmount,
      required this.transactioncategory,
      required this.transactionsubcategory,
      required this.transactionsubcategoryindex,
      required this.transactionnote,
      required this.transactionpaymentmode,
      required this.transactionCreatedAt});

  // AllTransactionDetails({required this.transactionAmount,required this.transactioncategory,required this.transactionDate,required this.transactionnote,required this.transactionpaymentmode,required this.transactionsubcategory,required this.uId});
}
