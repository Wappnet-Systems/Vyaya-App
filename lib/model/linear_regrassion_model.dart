import 'package:expenses_tracker/model/prediaction_helper.dart';

class LinearRegressionModel {
  late double slope;
  late double intercept;

  void train(List<Map<String, PredictionHelper>> data, double Function(PredictionHelper helper) getValue) {
    final int n = data.length;
    double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;

    for (var i = 0; i < n; i++) {
      var helper = data[i].values.first;
      var order = i + 1;

      sumX += order;
      sumY += getValue(helper);
      sumXY += order * getValue(helper);
      sumX2 += order * order;
    }

    slope = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
    intercept = (sumY - slope * sumX) / n;
  }

  double predict(double order) {
    return slope * order + intercept;
  }
}

class IncomeModel extends LinearRegressionModel {
  void trainForIncome(List<Map<String, PredictionHelper>> data) {
    train(data, (helper) => helper.totalIncome!.toDouble());
  }

  double predictIncome(double order) {
    return predict(order);
  }
}

class ExpensesModel extends LinearRegressionModel {
  void trainForExpenses(List<Map<String, PredictionHelper>> data) {
    train(data, (helper) => helper.totalExpenses!.toDouble());
  }

  double predictExpenses(double order) {
    return predict(order);
  }
}

class NeedExpensesModel extends LinearRegressionModel {
  void trainForNeedExpenses(List<Map<String, PredictionHelper>> data) {
    train(data, (helper) => helper.needExpenses!.toDouble());
  }

  double predictNeedExpenses(double order) {
    return predict(order);
  }
}

class WantExpensesModel extends LinearRegressionModel {
  void trainForWantExpenses(List<Map<String, PredictionHelper>> data) {
    train(data, (helper) => helper.wantsExpenses!.toDouble());
  }

  double predictWantExpenses(double order) {
    return predict(order);
  }
}

class SavingExpensesModel extends LinearRegressionModel {
  void trainForSavingExpenses(List<Map<String, PredictionHelper>> data) {
    train(data, (helper) => helper.savingExpenses!.toDouble());
  }

  double predictSavingExpenses(double order) {
    return predict(order);
  }
}

class RemainingBalanceModel extends LinearRegressionModel {
  void trainForRemainingBalance(List<Map<String, PredictionHelper>> data) {
    train(data, (helper) => helper.remaininBalance!.toDouble());
  }

  double predictRemainingBalance(double order) {
    return predict(order);
  }
}
