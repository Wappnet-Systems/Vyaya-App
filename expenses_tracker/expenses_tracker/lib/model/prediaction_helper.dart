class PredictionHelper {
  final int? totalIncome;
  final int? totalExpenses;
  final int? needExpenses;
  final int? wantsExpenses;
  final int? savingExpenses;
  final int? remaininBalance;

  PredictionHelper(
      {required this.totalIncome,
      this.totalExpenses,
      this.needExpenses,
      this.wantsExpenses,
      this.savingExpenses,
      required this.remaininBalance});
}
