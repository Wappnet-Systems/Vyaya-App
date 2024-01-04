import 'package:expenses_tracker/exports.dart';

part 'localtransaction.g.dart';

@HiveType(typeId: 1)
class LocalTransaction extends HiveObject {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String tID;

  @HiveField(2)
  final String tNote;

  @HiveField(3)
  final String tPaymentMode;

  @HiveField(4)
  final int tAmount;

  @HiveField(5)
  final int tCategory;

  @HiveField(6)
  final int tSubcategory;

  @HiveField(7)
  final int tSubcategoryIndex;

  @HiveField(8)
  final DateTime tDateTime;

  @HiveField(9)
  final DateTime tCreatedAt;

  LocalTransaction(
      {required this.userId,
      required this.tID,
      required this.tNote,
      required this.tPaymentMode,
      required this.tAmount,
      required this.tCategory,
      required this.tSubcategory,
      required this.tSubcategoryIndex,
      required this.tDateTime,
      required this.tCreatedAt});
}
