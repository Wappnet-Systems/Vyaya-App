// ignore_for_file: must_be_immutable

import 'package:expenses_tracker/exports.dart';
import 'package:expenses_tracker/model/prediaction_helper.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PredictionPage extends StatefulWidget {
  List<Map<String, PredictionHelper>> predictionHelperList;
  PredictionHelper predictionHelperData;

  PredictionPage(
      {super.key,
      required this.predictionHelperList,
      required this.predictionHelperData});

  @override
  State<PredictionPage> createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  Map<String, PredictionHelper>? lastElement;
  int? lastIncome, lastExpenses, lastRemainingBalance;
  @override
  void initState() {
    lastElement = widget.predictionHelperList.isNotEmpty
        ? widget.predictionHelperList.last
        : null;
    if (lastElement != null) {
      lastElement!.forEach((key, value) {
        lastIncome = value.totalIncome!;
        lastExpenses = value.totalExpenses!;
        lastRemainingBalance = value.remaininBalance;
      });
    } else {
      print('The list is empty');
    }
    super.initState();
  }

  String formatCurrency(int? value) {
    NumberFormat currencyFormat = NumberFormat.currency(
      symbol: '₹',
      locale: "HI",
      decimalDigits: 0,
    );
    return currencyFormat.format(value);
  }

  double calculatePercentageChange(int oldValue, int newValue) {
    return ((newValue - oldValue) / oldValue) * 100;
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: PrimaryColor.colorBottleGreen,
        iconTheme: IconThemeData(color: PrimaryColor.colorWhite),
        title: Text(
          'Budget Prediction Page',
          style: TextStyle(color: PrimaryColor.colorWhite),
        ),
        elevation: 5,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth*0.030),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 25,
            ),
            CustomTextStyle(
                customTextStyleText:
                    DateFormat.yMMM().format(DateTime(now.year, now.month + 1)),
                customTextColor: Theme.of(context).colorScheme.secondary,
                customTextFontWeight: FontWeight.normal,
                customTextStyle: null,
                customTextSize: 25.0),
            const SizedBox(
              height: 7,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          formatCurrency(
                              widget.predictionHelperData.remaininBalance),
                          style: TextStyle(
                            color: PrimaryColor.colorBottleGreen,
                            fontWeight: FontWeight.w500,
                            fontSize: screenHeight * 0.030,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Icon(
                                calculatePercentageChange(
                                              lastRemainingBalance!,
                                              widget.predictionHelperData
                                                  .remaininBalance!) <
                                          0
                                      ? Icons.arrow_downward
                                      : Icons.arrow_upward,
                                // Icons.arrow_upward,
                                size: 16,
                                color: PrimaryColor.colorBottleGreen,
                              ),
                            ),
                            Text(
                              "${calculatePercentageChange(lastRemainingBalance!, widget.predictionHelperData.remaininBalance!).toStringAsFixed(1).toString()}% ",
                              style: TextStyle(
                                color: PrimaryColor.colorBottleGreen,
                                fontWeight: FontWeight.w500,
                                fontSize: screenHeight * 0.015,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              formatCurrency(lastRemainingBalance),
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontWeight: FontWeight.w500,
                                fontSize: screenHeight * 0.015,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Predicted Remaining Balance',
                          style: TextStyle(
                            color: Theme.of(context).hintColor,
                            fontWeight: FontWeight.w400,
                            fontSize: screenHeight * 0.016,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: Card(
                    color: PrimaryColor.colorRed,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60)),
                                color: PrimaryColor.colorWhite,
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.045,
                                  height:
                                      MediaQuery.of(context).size.width * 0.045,
                                  child: Icon(
                                    Icons.arrow_upward,
                                    color: PrimaryColor.colorRed,
                                    size: 16,
                                  ),
                                ),
                              ),
                              Text(
                                'Predicted Spening',
                                style: TextStyle(
                                  color: PrimaryColor.colorWhite,
                                  fontWeight: FontWeight.w400,
                                  fontSize: screenHeight * 0.016,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                formatCurrency(
                                    widget.predictionHelperData.totalExpenses),
                                style: TextStyle(
                                  color: PrimaryColor.colorWhite,
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenHeight * 0.030,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Icon(
                                  calculatePercentageChange(
                                              lastExpenses!,
                                              widget.predictionHelperData
                                                  .totalExpenses!) <
                                          0
                                      ? Icons.arrow_downward
                                      : Icons.arrow_upward,
                                  // Icons.arrow_upward,
                                  size: 16,
                                  color: PrimaryColor.colorWhite,
                                ),
                              ),
                              Text(
                                "${calculatePercentageChange(lastExpenses!, widget.predictionHelperData.totalExpenses!).toStringAsFixed(1).toString()}% ",
                                style: TextStyle(
                                  color: PrimaryColor.colorWhite,
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenHeight * 0.015,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                formatCurrency(lastExpenses),
                                style: TextStyle(
                                  color: PrimaryColor.colorWhite,
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenHeight * 0.015,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Card(
                    color: PrimaryColor.colorBottleGreen,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60)),
                                color: PrimaryColor.colorWhite,
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.045,
                                  height:
                                      MediaQuery.of(context).size.width * 0.045,
                                  child: Icon(
                                    Icons.arrow_downward,
                                    color: PrimaryColor.colorBottleGreen,
                                    size: 16,
                                  ),
                                ),
                              ),
                              Text(
                                'Predicted Income',
                                style: TextStyle(
                                  color: PrimaryColor.colorWhite,
                                  fontWeight: FontWeight.w400,
                                  fontSize: screenHeight * 0.016,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                formatCurrency(
                                    widget.predictionHelperData.totalIncome),
                                style: TextStyle(
                                  color: PrimaryColor.colorWhite,
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenHeight * 0.030,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Icon(
                                  calculatePercentageChange(
                                              lastIncome!,
                                              widget.predictionHelperData
                                                  .totalIncome!) <
                                          0
                                      ? Icons.arrow_downward
                                      : Icons.arrow_upward,
                                  size: 16,
                                  color: PrimaryColor.colorWhite,
                                ),
                              ),
                              Text(
                                "${calculatePercentageChange(lastIncome!, widget.predictionHelperData.totalIncome!).toStringAsFixed(1).toString()}% ",
                                style: TextStyle(
                                  color: PrimaryColor.colorWhite,
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenHeight * 0.015,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                formatCurrency(lastIncome),
                                style: TextStyle(
                                  color: PrimaryColor.colorWhite,
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenHeight * 0.015,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight*0.015,
            ),
            CustomTextStyle(
                customTextStyleText:
                    'Previous Records',
                customTextColor: Theme.of(context).colorScheme.secondary,
                customTextFontWeight: FontWeight.normal,
                customTextStyle: null,
                customTextSize: 25.0),
            SizedBox(
              height: screenHeight*0.009,
            ),
            Card(
              child: Container(
                height: screenHeight*0.30,
                padding: const EdgeInsets.all(16.0),
                child: _buildColumnChart(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    List<ChartData> incomeData = _getChartData('Income');
    List<ChartData> expensesData = _getExpensesChartData('Expenses');

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(),
      series: <ChartSeries>[
        AreaSeries<ChartData, String>(
          legendItemText: 'Income',
          dataSource: incomeData,
          xValueMapper: (ChartData data, _) => data.month,
          yValueMapper: (ChartData data, _) => data.amount,
          name: 'Income',
        ),
        AreaSeries<ChartData, String>(
          legendItemText: 'Expenses',
          dataSource: expensesData,
          xValueMapper: (ChartData data, _) => data.month,
          yValueMapper: (ChartData data, _) => data.amount,
          name: 'Expenses',
        ),
      ],
    );
  }

  Widget _buildColumnChart() {
    List<ChartData> incomeData = _getChartData('Income');
    List<ChartData> expensesData = _getExpensesChartData('Expenses');

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(),
      series: <ChartSeries>[
        ColumnSeries<ChartData, String>(
          legendItemText: 'Income',
          dataSource: incomeData,
          xValueMapper: (ChartData data, _) => data.month,
          yValueMapper: (ChartData data, _) => data.amount,
          name: 'Income',
        ),
        ColumnSeries<ChartData, String>(
          legendItemText: 'Expenses',
          dataSource: expensesData,
          xValueMapper: (ChartData data, _) => data.month,
          yValueMapper: (ChartData data, _) => data.amount,
          name: 'Expenses',
        ),
      ],
    );
  }

  List<ChartData> _getChartData(String type) {
    List<ChartData> result = [];

    for (Map<String, PredictionHelper> map in widget.predictionHelperList) {
      for (String key in map.keys) {
        result.add(ChartData(
          key,
          map[key]!.totalIncome!.toDouble(),
        ));
      }
    }

    return result;
  }

  List<ChartData> _getExpensesChartData(String type) {
    List<ChartData> result = [];

    for (Map<String, PredictionHelper> map in widget.predictionHelperList) {
      for (String key in map.keys) {
        result.add(ChartData(
          key,
          map[key]!.totalExpenses!.toDouble(),
        ));
      }
    }

    return result;
  }
}

class ChartData {
  final String month;
  final double amount;

  ChartData(this.month, this.amount);
}