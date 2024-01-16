// ignore_for_file: must_be_immutable

import 'package:expenses_tracker/model/prediaction_helper.dart';
import 'package:expenses_tracker/screens/spending_category_percentage.dart';
import 'package:expenses_tracker/utils/const.dart';
import 'package:expenses_tracker/widgets/custom_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  List<double> othersPercentageList = [];
  List<double> foodPercentageList = [];
  List<double> shoppingPercentageList = [];
  List<double> travellingPercentageList = [];
  List<double> entertainmentPercentageList = [];
  List<double> personalcarePercentageList = [];
  List<double> educationPercentageList = [];
  List<double> billsUtillsPercentageList = [];
  List<double> investmentPercentageList = [];
  List<double> rentPercentageList = [];
  List<double> taxesPercentageList = [];
  List<double> insurancePercentageList = [];

  double? othersAverage;
  double? foodAverage;
  double? shoppingAverage;
  double? travellingAverage;
  double? entertainmentAverage;
  double? personalcareAverage;
  double? educationAverage;
  double? billsUtillsAverage;
  double? investmentAverage;
  double? rentAverage;
  double? taxesAverage;
  double? insuranceAverage;
  Map<String, double>? averages;
  Map<String, double>? top3Values;

  double needResult = 0;
  double wantResult = 0;
  double savingResult = 0;

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
    categoriseListing(needPercentageList, 50, "need");
    categoriseListing(wantPercentageList, 30, "want");
    categoriseListing(savingPercentageList, 20, "saving");
    findRuleBrekPercetage();

    super.initState();
  }

  double calculateAverage(List<double> list) {
    double sum = list.reduce((a, b) => a + b);
    return sum / list.length;
  }

  findRuleBrekPercetage() {
    needResult = (((needLimitCross)! / (needPercentageList.length)) * 100);
    wantResult = ((wantsLimitCross! / (wantPercentageList.length)) * 100);
    savingResult = ((savingLimitCross! / (savingPercentageList.length)) * 100);
  }

  categoriseListing(List<double> listing, int limit, String value) {
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
        backgroundColor: Theme.of(context).bottomAppBarTheme.color,
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.secondary),
        title: Text('Budget Prediction',
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: Theme.of(context).colorScheme.secondary)),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              openBottomSheet(context, screenHeight, screenWidth);
            },
          )
        ],
        elevation: 5,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.020),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 25,
            ),
            Text(DateFormat.yMMM().format(DateTime(now.year, now.month + 1)),
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(color: Theme.of(context).colorScheme.secondary)),
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
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .copyWith(
                                color: PrimaryColor.colorBottleGreen,
                                fontWeight: FontWeight.w500,
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
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                      color: PrimaryColor.colorBottleGreen),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              formatCurrency(lastRemainingBalance),
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                    color: Theme.of(context).hintColor,
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
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                color: Theme.of(context).hintColor,
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
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                      color: PrimaryColor.colorWhite,
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
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .copyWith(
                                      color: PrimaryColor.colorWhite,
                                      fontWeight: FontWeight.w500,
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
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                      color: PrimaryColor.colorWhite,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                formatCurrency(lastExpenses),
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                      color: PrimaryColor.colorWhite,
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
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                      color: PrimaryColor.colorWhite,
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
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .copyWith(
                                      color: PrimaryColor.colorWhite,
                                      fontWeight: FontWeight.w500,
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
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                      color: PrimaryColor.colorWhite,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                formatCurrency(lastIncome),
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                      color: PrimaryColor.colorWhite,
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
            Text('Most spending categories',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: Theme.of(context).colorScheme.secondary)),
            SizedBox(
              height: screenHeight * 0.009,
            ),
            Card(
              color: Theme.of(context).cardColor,
              elevation: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: screenWidth * 0.04,
                        ),
                        Flexible(
                          flex: 4,
                          child: Column(
                            children: [
                              SizedBox(
                                height: screenHeight * 0.03,
                              ),
                              CustomCircularSlider(
                                initialValue:
                                    top3Values!.entries.elementAt(1).value,
                                sliderColor: PrimaryColor.colorBlue,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 50,
                                    width: 80,
                                    child: Text(
                                        '${top3Values!.entries.elementAt(1).key}',
                                        maxLines: 2,
                                        overflow: TextOverflow.clip,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall!
                                            .copyWith(
                                                color: PrimaryColor.colorBlue)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.04,
                        ),
                        Flexible(
                          flex: 5,
                          child: Column(
                            children: [
                              CustomCircularSlider(
                                initialValue:
                                    top3Values!.entries.elementAt(0).value,
                                sliderColor: PrimaryColor.colorRed,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 50,
                                    width: 80,
                                    child: Text(
                                        '${top3Values!.entries.elementAt(0).key}',
                                        maxLines: 2,
                                        overflow: TextOverflow.clip,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall!
                                            .copyWith(
                                                color: PrimaryColor.colorRed)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.04,
                        ),
                        Flexible(
                          flex: 4,
                          child: Column(
                            children: [
                              SizedBox(
                                height: screenHeight * 0.03,
                              ),
                              CustomCircularSlider(
                                initialValue:
                                    top3Values!.entries.elementAt(2).value,
                                sliderColor: PrimaryColor.colorBottleGreen,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 50,
                                    width: 80,
                                    child: Text(
                                        top3Values!.entries.elementAt(2).key,
                                        maxLines: 2,
                                        overflow: TextOverflow.clip,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall!
                                            .copyWith(
                                                color: PrimaryColor
                                                    .colorBottleGreen)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.04,
                        ),
                      ],
                    ),
                    Divider(
                      color: Theme.of(context).hintColor.withOpacity(.4),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SpendingCategoryPercentage(
                                      averages: averages,
                                    )));
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: screenHeight * .007),
                        child: Text('View All',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                    color: Theme.of(context)
                                        .hintColor
                                        .withOpacity(.4))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.015,
            ),
            Text('Previous Records',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: Theme.of(context).colorScheme.secondary)),
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
                Text('Monthly Recap',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondary)),
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
                              child: Text(key,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary)),
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
                                Text("Total Income",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Theme.of(context).hintColor,
                                        )),
                                Text(
                                  formatCurrency(pfIncome),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: PrimaryColor.colorBottleGreen,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                ),
                              ],
                            )),
                        SizedBox(
                            width: screenWidth / 2.201,
                            child: Column(children: [
                              Text('Total Spending',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Theme.of(context).hintColor,
                                      )),
                              Text(
                                formatCurrency(pfSpending),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: PrimaryColor.colorRed,
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
                                    mainLabelStyle: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                    
                                  ),
                                ),
                                min: 0,
                                max: 100,
                                initialValue: pfIncome == 0
                                    ? (pfNeeds == 0)
                                        ? 0
                                        : 100
                                    : ((pfNeeds! / pfIncome!) * 100) > 100
                                        ? 100
                                        : ((pfNeeds! / pfIncome!) * 100),
                              ),
                              Text(
                                'Needs',
                                style: Theme.of(context).textTheme.displayMedium,
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                formatCurrency(pfNeeds),
                                style: Theme.of(context).textTheme.displayMedium,
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
                                    mainLabelStyle: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                  ),
                                ),
                                min: 0,
                                max: 100,
                                initialValue: pfIncome == 0
                                    ? (pfWants == 0)
                                        ? 0
                                        : 100
                                    : ((pfWants! / pfIncome!) * 100) > 100
                                        ? 100
                                        : ((pfWants! / pfIncome!) * 100),
                              ),
                              Text(
                                'Wants',
                                style: Theme.of(context).textTheme.displayMedium,
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                formatCurrency(pfWants),
                                style: Theme.of(context).textTheme.displayMedium,
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
                                    mainLabelStyle: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                  ),
                                ),
                                min: 0,
                                max: 100,
                                initialValue: pfIncome == 0
                                    ? (pfSaving == 0)
                                        ? 0
                                        : 100
                                    : ((pfSaving! / pfIncome!) * 100) > 100
                                        ? 100
                                        : ((pfSaving! / pfIncome!) * 100),
                              ),
                              Text(
                                'Saving',
                                style: Theme.of(context).textTheme.displayMedium,
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                formatCurrency(pfSaving),
                                style: Theme.of(context).textTheme.displayMedium,
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
      // floatingActionButton: FloatingActionButton(onPressed: ),
    );
  }

  Widget buildColumnChartForSubCategory() {
    return SfCartesianChart(
      title: ChartTitle(text: 'Spending Spectrum'),
      primaryXAxis: CategoryAxis(),
      tooltipBehavior: TooltipBehavior(enable: true),
      legend: Legend(
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
      primaryYAxis: NumericAxis(),
      legend: Legend(
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
      title: ChartTitle(text: 'Financial Flow'),
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(),
      legend: Legend(
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
    for (var map in widget.predictionHelperList) {
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

        double otherPercentage = (personalFinanceHelper.expensesOnOthers! /
                personalFinanceHelper.totalIncome!) *
            100;
        double foodPercentage = (personalFinanceHelper.expensesOnFood! /
                personalFinanceHelper.totalIncome!) *
            100;
        double shoppingPercentage = (personalFinanceHelper.expensesOnShopping! /
                personalFinanceHelper.totalIncome!) *
            100;
        double travellingPercentage =
            (personalFinanceHelper.expensesOnTravelling! /
                    personalFinanceHelper.totalIncome!) *
                100;
        double entertainmentPercentage =
            (personalFinanceHelper.expensesOnEntertainment! /
                    personalFinanceHelper.totalIncome!) *
                100;
        double personalcarePercentage =
            (personalFinanceHelper.expensesOnPersonalCare! /
                    personalFinanceHelper.totalIncome!) *
                100;
        double educationPercentage =
            (personalFinanceHelper.expensesOnEducation! /
                    personalFinanceHelper.totalIncome!) *
                100;
        double billsPercentage = (personalFinanceHelper.expensesOnBillUtils! /
                personalFinanceHelper.totalIncome!) *
            100;
        double investmentPercentage =
            (personalFinanceHelper.expensesOnInvestment! /
                    personalFinanceHelper.totalIncome!) *
                100;
        double rentPercentage = (personalFinanceHelper.expensesOnRent! /
                personalFinanceHelper.totalIncome!) *
            100;
        double taxesPercentage = (personalFinanceHelper.expensesOnTaxes! /
                personalFinanceHelper.totalIncome!) *
            100;
        double insurancePercentage =
            (personalFinanceHelper.expensesOnInsurance! /
                    personalFinanceHelper.totalIncome!) *
                100;

        // print("Expenses on \nOthers: $otherPercentage\nFood: $foodPercentage\nShopping: $shoppingPercentage\nTravelling: $travellingPercentage\nEntertainment: $entertainmentPercentage\nPersonal Care: $personalcarePercentage \nEducation: $educationPercentage \nBills Utils: $billsPercentage\nInvestment: $investmentPercentage \nRent: $rentPercentage \nTaxes: $taxesPercentage \nInsurance: $insurancePercentage");

        othersPercentageList.add(otherPercentage);
        foodPercentageList.add(foodPercentage);
        shoppingPercentageList.add(shoppingPercentage);
        travellingPercentageList.add(travellingPercentage);
        entertainmentPercentageList.add(entertainmentPercentage);
        personalcarePercentageList.add(personalcarePercentage);
        educationPercentageList.add(educationPercentage);
        billsUtillsPercentageList.add(billsPercentage);
        investmentPercentageList.add(investmentPercentage);
        rentPercentageList.add(rentPercentage);
        taxesPercentageList.add(taxesPercentage);
        insurancePercentageList.add(insurancePercentage);

        findMostSpendCategory();
        print(
            "Needs: $needPercentage Wants: $wantPercentage Saving : $savingPercentage");
        needPercentageList.add(needPercentage);
        wantPercentageList.add(wantPercentage);
        savingPercentageList.add(savingPercentage);
      });
    }
  }

  findMostSpendCategory() {
    othersAverage = calculateAverage(othersPercentageList);
    foodAverage = calculateAverage(foodPercentageList);
    shoppingAverage = calculateAverage(shoppingPercentageList);
    travellingAverage = calculateAverage(travellingPercentageList);
    entertainmentAverage = calculateAverage(entertainmentPercentageList);
    personalcareAverage = calculateAverage(personalcarePercentageList);
    educationAverage = calculateAverage(educationPercentageList);
    billsUtillsAverage = calculateAverage(billsUtillsPercentageList);
    investmentAverage = calculateAverage(investmentPercentageList);
    rentAverage = calculateAverage(rentPercentageList);
    taxesAverage = calculateAverage(taxesPercentageList);
    insuranceAverage = calculateAverage(insurancePercentageList);

    averages = {
      'Others': othersAverage!,
      'Food': foodAverage!,
      'Shopping': shoppingAverage!,
      'Travelling': travellingAverage!,
      'Entertainment': entertainmentAverage!,
      'Personalcare': personalcareAverage!,
      'Education': educationAverage!,
      'BillsUtills': billsUtillsAverage!,
      'Investment': investmentAverage!,
      'Rent': rentAverage!,
      'Taxes': taxesAverage!,
      'Insurance': insuranceAverage!,
    };

    var sortedEntries = averages!.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    var top3Entries = sortedEntries.take(3);
    top3Values = Map.fromEntries(top3Entries);
    top3Values!.forEach((key, value) {
      print('$key: $value');
    });
  }

  void openBottomSheet(
      BuildContext context, double screenHeight, double screenWidth) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        Widget fetchPerformanceFromValue(double value, String stringValue) {
          if (value == 0) {
            return Row(
              children: [
                Icon(
                  Icons.star,
                  color: PrimaryColor.colorBottleGreen,
                ),
                Text(
                  stringValue,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(color: PrimaryColor.colorBottleGreen,),
                  
                ),
              ],
            );
          } else if (value > 0 && value <= 50) {
            return Row(
              children: [
                const Icon(
                  Icons.sentiment_satisfied,
                  color: Colors.orange,
                ),
                Text(
                  stringValue,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.orange,),
                ),
              ],
            );
          } else if (value > 50 && value <= 100) {
            return Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: PrimaryColor.colorRed,
                ),
                Text(
                  stringValue,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(color: PrimaryColor.colorRed,),
                  
                ),
              ],
            );
          } else {
            return const Text('');
          }
        }

        return Container(
          // height: screenHeight * 0.70,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Spending Analysis',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w500,),                    
                  ),
                ],
              ),
              SizedBox(height: ScreenUtil().setHeight(10)),
              Text(
                "Important :",
                style: Theme.of(context).textTheme.displayMedium!.copyWith(fontWeight: FontWeight.w400)
                
              ),
              Text(
                "\u2022 Stick to the 50-30-20 Budgeting rule!",
                style: Theme.of(context).textTheme.headlineSmall
                
              ),
              Text(
                "\u2022 Out of all recorded budgets, track instances how many time that rule isn't followed.",
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.justify,
              ),
              Text(
                "\u2022 Performance measured in 3 categories.",
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.justify,
              ),
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: PrimaryColor.colorBottleGreen,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    '(Outstanding Performance)',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: PrimaryColor.colorBottleGreen)
                    
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.sentiment_satisfied,
                    color: Colors.orange,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    '(Average Performance)',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.orange)
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.warning,
                    color: PrimaryColor.colorRed,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    '(Poor Performance)',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: PrimaryColor.colorRed)
                  ),
                ],
              ),
              SizedBox(height: ScreenUtil().setHeight(5)),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth * 0.07,
                  ),
                  Flexible(
                    flex: 3,
                    child: Column(
                      children: [
                        CustomCircularSlider(
                          initialValue: needResult,
                          sliderColor: PrimaryColor.colorBottleGreen,
                        ),
                        Row(
                          children: [
                            fetchPerformanceFromValue(needResult, "Needs"),
                          ],
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
                        CustomCircularSlider(
                          initialValue: wantResult,
                          sliderColor: PrimaryColor.colorRed,
                        ),
                        Row(
                          children: [
                            fetchPerformanceFromValue(wantResult, "Wants"),
                          ],
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
                        CustomCircularSlider(
                          initialValue: savingResult,
                          sliderColor: PrimaryColor.colorBlue,
                        ),
                        Row(
                          children: [
                            fetchPerformanceFromValue(savingResult, "Saving"),
                          ],
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
        );
      },
    );
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
