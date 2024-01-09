// ignore_for_file: must_be_immutable

import 'package:expenses_tracker/model/prediaction_helper.dart';
import 'package:expenses_tracker/utils/const.dart';
import 'package:expenses_tracker/widgets/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
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
  int? pfBalance, pfIncome, pfSpending, pfNeeds, pfWants, pfSaving;
  int? needLimitCross = 0;
  int? wantsLimitCross = 0;
  int? savingLimitCross = 0;
  List<double> needPercentageList = [];
  List<double> wantPercentageList = [];
  List<double> savingPercentageList = [];
  String selectedKey = '';
  @override
  void initState() {
    lastElement = widget.predictionHelperList.isNotEmpty
        ? widget.predictionHelperList.last
        : null;

    for (var element in widget.predictionHelperList) {
      selectedKey = element.keys.last;
    }
    if (lastElement != null) {
      lastElement!.forEach((key, value) {
        lastIncome = value.totalIncome!;
        lastExpenses = value.totalExpenses!;
        lastRemainingBalance = value.remaininBalance;
      });
    } else {
      print('The list is empty');
    }
    fetchValuesForSelectedKey();
    fetchPercentageOfSpending();
    printListing(needPercentageList, 50, "need");
    printListing(wantPercentageList, 30, "want");
    printListing(savingPercentageList, 20, "saving");
    print(
        "Needs Limit Cross: $needLimitCross, Want Limit Cross : $wantsLimitCross, Saving Limit Cross: $savingLimitCross");
    print(
        "Exceeded needs limit $needLimitCross out of ${needPercentageList.length} times.");
    print(
        "Exceeded wants limit $wantsLimitCross out of ${needPercentageList.length} times.");
    print(
        "Exceeded saving limit $savingLimitCross out of ${needPercentageList.length} times.");
    super.initState();
  }

  printListing(List<double> listing, int limit, String value) {
    for (int i = 0; i < listing.length; i++) {
      if (listing[i] >= limit) {
        switch (value) {
          case "need":
            needLimitCross = (needLimitCross! + 1);
            break;
          case "want":
            wantsLimitCross = (wantsLimitCross! + 1);
            break;
          case "saving":
            savingLimitCross = (savingLimitCross! + 1);
            break;
          default:
            break;
        }
      }
    }
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
      backgroundColor: Theme.of(context).colorScheme.primary,
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
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.018),
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
                customtextstyle: null,
                customTextSize: 25.0),
            const SizedBox(
              height: 7,
            ),
            Card(
              color: Theme.of(context).cardColor,
              elevation: 5,
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
                        const SizedBox(
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
                      padding: const EdgeInsets.all(8.0),
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
                                'Predicted Spending',
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
                      padding: const EdgeInsets.all(8.0),
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
              height: screenHeight * 0.015,
            ),
            CustomTextStyle(
                customTextStyleText: 'Previous Records',
                customTextColor: Theme.of(context).colorScheme.secondary,
                customTextFontWeight: FontWeight.normal,
                customtextstyle: null,
                customTextSize: 25.0),
            SizedBox(
              height: screenHeight * 0.009,
            ),
            Card(
              color: Theme.of(context).cardColor,
              elevation: 5,
              child: Container(
                height: screenHeight * 0.30,
                padding: const EdgeInsets.all(16.0),
                child: buildColumnChart(),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.009,
            ),
            Card(
              color: Theme.of(context).cardColor,
              elevation: 5,
              child: Container(
                height: screenHeight * 0.30,
                padding: const EdgeInsets.all(16.0),
                child: buildColumnChartForSubCategory(),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.020,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTextStyle(
                    customTextStyleText: 'Monthly Recap',
                    customTextColor: Theme.of(context).colorScheme.secondary,
                    customTextFontWeight: FontWeight.normal,
                    customtextstyle: null,
                    customTextSize: 25.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: selectedKey,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedKey = newValue!;
                        fetchValuesForSelectedKey();
                      });
                    },
                    underline: const SizedBox.shrink(),
                    items: widget.predictionHelperList
                        .map((Map<String, PredictionHelper> map) {
                          return map.keys.map((String key) {
                            return DropdownMenuItem<String>(
                              value: key,
                              child: Text(
                                key,
                                style: TextStyle(
                                  color: PrimaryColor.colorBottleGreen,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            );
                          }).toList();
                        })
                        .expand((element) => element)
                        .toList(),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            Card(
              color: Theme.of(context).cardColor,
              elevation: 5,
              child: Container(
                height: screenHeight * 0.35,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                            width: screenWidth / 2.201,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Total Income",
                                  style: TextStyle(
                                    color: Theme.of(context).hintColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: screenHeight * 0.016,
                                  ),
                                ),
                                Text(
                                  formatCurrency(pfIncome),
                                  style: TextStyle(
                                    color: PrimaryColor.colorBottleGreen,
                                    fontWeight: FontWeight.w500,
                                    fontSize: screenHeight * 0.022,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                ),
                              ],
                            )),
                        SizedBox(
                            width: screenWidth / 2.201,
                            child: Column(children: [
                              Text(
                                'Total Spending',
                                style: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: screenHeight * 0.016,
                                ),
                              ),
                              Text(
                                formatCurrency(pfSpending),
                                style: TextStyle(
                                  color: PrimaryColor.colorRed,
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenHeight * 0.022,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                              ),
                            ]))
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: screenWidth * 0.07,
                        ),
                        Flexible(
                          flex: 3,
                          child: Column(
                            children: [
                              SleekCircularSlider(
                                appearance: CircularSliderAppearance(
                                  startAngle: 0,
                                  angleRange: 360,
                                  customColors: CustomSliderColors(
                                    trackColor: Theme.of(context).hintColor,
                                    progressBarColor:
                                        PrimaryColor.colorBottleGreen,
                                    dotColor: PrimaryColor.colorBottleGreen,
                                  ),
                                  customWidths: CustomSliderWidths(
                                    trackWidth: 1.5,
                                    progressBarWidth: 2.5,
                                    handlerSize: 4,
                                  ),
                                  infoProperties: InfoProperties(
                                    modifier: (double value) {
                                      final roundedValue =
                                          value.ceil().toInt().toString();
                                      return '$roundedValue%';
                                    },
                                    mainLabelStyle: TextStyle(
                                        fontSize: 13.0,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  ),
                                ),
                                min: 0,
                                max: 100,
                                initialValue: pfIncome == 0
                                    ? (pfNeeds == 0)
                                        ? 0
                                        : 100
                                    : ((pfNeeds! / pfIncome!) * 100),
                              ),
                              Text(
                                'Needs',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontSize: screenHeight * 0.020),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                formatCurrency(pfNeeds),
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontSize: screenHeight * 0.020),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.07,
                        ),
                        Flexible(
                          flex: 3,
                          child: Column(
                            children: [
                              SleekCircularSlider(
                                appearance: CircularSliderAppearance(
                                  startAngle: 0,
                                  angleRange: 360,
                                  customColors: CustomSliderColors(
                                    trackColor: Theme.of(context).hintColor,
                                    progressBarColor: PrimaryColor.colorRed,
                                    dotColor: PrimaryColor.colorRed,
                                  ),
                                  customWidths: CustomSliderWidths(
                                    trackWidth: 1.5,
                                    progressBarWidth: 2.5,
                                    handlerSize: 4,
                                  ),
                                  infoProperties: InfoProperties(
                                    modifier: (double value) {
                                      final roundedValue =
                                          value.ceil().toInt().toString();
                                      return '$roundedValue%';
                                    },
                                    mainLabelStyle: TextStyle(
                                        fontSize: 13.0,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  ),
                                ),
                                min: 0,
                                max: 100,
                                initialValue: pfIncome == 0
                                    ? (pfWants == 0)
                                        ? 0
                                        : 100
                                    : ((pfWants! / pfIncome!) * 100),
                              ),
                              Text(
                                'Wants',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontSize: screenHeight * 0.020),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                formatCurrency(pfWants),
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontSize: screenHeight * 0.020),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.07,
                        ),
                        Flexible(
                          flex: 3,
                          child: Column(
                            children: [
                              SleekCircularSlider(
                                appearance: CircularSliderAppearance(
                                  startAngle: 0,
                                  angleRange: 360,
                                  customColors: CustomSliderColors(
                                    trackColor: Theme.of(context).hintColor,
                                    progressBarColor: PrimaryColor.colorBlue,
                                    dotColor: PrimaryColor.colorBlue,
                                  ),
                                  customWidths: CustomSliderWidths(
                                    trackWidth: 1.5,
                                    progressBarWidth: 2.5,
                                    handlerSize: 4,
                                  ),
                                  infoProperties: InfoProperties(
                                    modifier: (double value) {
                                      final roundedValue =
                                          value.ceil().toInt().toString();
                                      return '$roundedValue%';
                                    },
                                    mainLabelStyle: TextStyle(
                                        fontSize: 13.0,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  ),
                                ),
                                min: 0,
                                max: 100,
                                initialValue: pfIncome == 0
                                    ? (pfSaving == 0)
                                        ? 0
                                        : 100
                                    : ((pfSaving! / pfIncome!) * 100),
                              ),
                              Text(
                                'Saving',
                                style: TextStyle(
                                    color:Theme.of(context).colorScheme.secondary,
                                    fontSize: screenHeight * 0.020),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                formatCurrency(pfSaving),
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontSize: screenHeight * 0.020),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.07,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.009,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildColumnChartForSubCategory() {
    
    return SfCartesianChart(
      title:  ChartTitle(text: 'Spending Spectrum'),
      primaryXAxis:  CategoryAxis(),
      tooltipBehavior: TooltipBehavior(enable: true),
      legend:  Legend(
        isVisible: true,
        position: LegendPosition.bottom,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      series: <StackedColumnSeries>[
        StackedColumnSeries<Map<String, dynamic>, String>(
          dataSource: widget.predictionHelperList,
          xValueMapper: (Map<String, dynamic> data, _) => data.keys.first,
          yValueMapper: (Map<String, dynamic> data, _) =>
              data.values.first.needExpenses,
          name: 'Needs',
        ),
        StackedColumnSeries<Map<String, dynamic>, String>(
          dataSource: widget.predictionHelperList,
          xValueMapper: (Map<String, dynamic> data, _) => data.keys.first,
          yValueMapper: (Map<String, dynamic> data, _) =>
              data.values.first.wantsExpenses,
          name: 'Wants',
        ),
        StackedColumnSeries<Map<String, dynamic>, String>(
          dataSource: widget.predictionHelperList,
          xValueMapper: (Map<String, dynamic> data, _) => data.keys.first,
          yValueMapper: (Map<String, dynamic> data, _) =>
              data.values.first.savingExpenses,
          name: 'Savings',
        ),
      ],
    );
  }

  Widget buildLineChart() {
    List<ChartData> incomeData = getIncomeChartData('Income');
    List<ChartData> expensesData = getExpensesChartData('Expenses');
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      primaryYAxis:  NumericAxis(),
      legend:  Legend(
        isVisible: true,
        position: LegendPosition.bottom,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      series: <CartesianSeries>[
        LineSeries<ChartData, String>(
          legendItemText: 'Income',
          dataSource: incomeData,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          xValueMapper: (ChartData data, _) => data.month,
          yValueMapper: (ChartData data, _) => data.amount,
          name: 'Income',
        ),
        LineSeries<ChartData, String>(
          legendItemText: 'Expenses',
          dataSource: expensesData,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          xValueMapper: (ChartData data, _) => data.month,
          yValueMapper: (ChartData data, _) => data.amount,
          name: 'Expenses',
        ),
      ],
    );
  }

  Widget buildColumnChart() {
    List<ChartData> incomeData = getIncomeChartData('Income');
    List<ChartData> expensesData = getExpensesChartData('Expenses');
    return SfCartesianChart(
      title:  ChartTitle(text: 'Financial Flow'),
      primaryXAxis:  CategoryAxis(),
      primaryYAxis:  NumericAxis(),
      legend:  Legend(
        isVisible: true,
        position: LegendPosition.bottom,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries>[
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

  fetchPercentageOfSpending() {
    widget.predictionHelperList.forEach((map) {
      map.forEach((key, personalFinanceHelper) {
        double needPercentage = (personalFinanceHelper.needExpenses! /
                personalFinanceHelper.totalIncome!) *
            100;
        double wantPercentage = (personalFinanceHelper.wantsExpenses! /
                personalFinanceHelper.totalIncome!) *
            100;
        double savingPercentage = (personalFinanceHelper.savingExpenses! /
                personalFinanceHelper.totalIncome!) *
            100;
        print(
            "Needs: $needPercentage Wants: $wantPercentage Saving : $savingPercentage");
        needPercentageList.add(needPercentage);
        wantPercentageList.add(wantPercentage);
        savingPercentageList.add(savingPercentage);
      });
    });
  }

  void fetchValuesForSelectedKey() {
    Map<String, PredictionHelper>? selectedMap =
        widget.predictionHelperList.firstWhere(
      (map) => map.containsKey(selectedKey),
    );

    PredictionHelper? personalFinanceHelper = selectedMap[selectedKey];

    if (personalFinanceHelper != null) {
      pfIncome = personalFinanceHelper.totalIncome;
      pfSpending = personalFinanceHelper.totalExpenses;
      pfBalance = personalFinanceHelper.remaininBalance;
      pfNeeds = personalFinanceHelper.needExpenses;
      pfWants = personalFinanceHelper.wantsExpenses;
      pfSaving = personalFinanceHelper.savingExpenses;
    } else {
      print('No PredictionHelper found for $selectedKey');
    }
  }

  List<ChartData> getIncomeChartData(String type) {
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

  List<ChartData> getExpensesChartData(String type) {
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
