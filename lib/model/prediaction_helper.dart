class PredictionHelper {
  final int? totalIncome;
  final int? totalExpenses;
  final int? needExpenses;
  final int? wantsExpenses;
  final int? savingExpenses;
  final int? remaininBalance;
  final int? expensesOnOthers;
  final int? expensesOnFood;
  final int? expensesOnShopping;
  final int? expensesOnTravelling;
  final int? expensesOnEntertainment;
  final int? expensesOnPersonalCare;
  final int? expensesOnEducation;
  final int? expensesOnBillUtils;
  final int? expensesOnInvestment;
  final int? expensesOnRent;
  final int? expensesOnTaxes;
  final int? expensesOnInsurance;

  PredictionHelper(
      {required this.totalIncome,
      this.totalExpenses,
      this.needExpenses,
      this.wantsExpenses,
      this.savingExpenses,
      required this.remaininBalance,
      this.expensesOnOthers,
      this.expensesOnFood,
      this.expensesOnShopping,
      this.expensesOnTravelling,
      this.expensesOnEntertainment,
      this.expensesOnPersonalCare,
      this.expensesOnEducation,
      this.expensesOnBillUtils,
      this.expensesOnInvestment,
      this.expensesOnRent,
      this.expensesOnTaxes,
      this.expensesOnInsurance});
}
