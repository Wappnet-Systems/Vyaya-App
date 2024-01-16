import 'package:expenses_tracker/model/transaction.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'custom_no_data.dart';

class CustomCircularChart extends StatefulWidget {
  final List<AllTransactionDetails> currentPageTransactions;

  const CustomCircularChart({
    Key? key,
    required this.currentPageTransactions,
  }) : super(key: key);

  @override
  State<CustomCircularChart> createState() => _CustomCircularChartState();
}

class _CustomCircularChartState extends State<CustomCircularChart> {
  late List<AllTransactionDetails> selectedTransactions;
  late List<CircularSeries<dynamic, dynamic>> chartSeries;

  @override
  void initState() {
    super.initState();
    selectedTransactions = [];
    // chartSeries = _buildChartSeries();
  }

  @override
  Widget build(BuildContext context) {
    int? getExplodeIndex() {
      if (selectedTransactions.isNotEmpty) {
        final selectedTransaction = selectedTransactions.first;
        return widget.currentPageTransactions.indexOf(selectedTransaction);
      }
      return null;
    }

    return Card(
      color: Theme.of(context).cardColor,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.30,
        child: widget.currentPageTransactions.isEmpty
            ? const Center(
                child: CustomNoData(),
              )
            : SfCircularChart(
                series: <CircularSeries>[
                  PieSeries<AllTransactionDetails, String>(
                    legendIconType: LegendIconType.circle,
                    groupMode: CircularChartGroupMode.value,
                    dataSource: widget.currentPageTransactions,
                    xValueMapper: (AllTransactionDetails data, _) =>
                        data.transactionNote as String,
                    yValueMapper: (AllTransactionDetails data, _) =>
                        data.transactionAmount,
                    dataLabelMapper: (AllTransactionDetails data, _) =>
                        '${data.transactionNote!}\n₹${data.transactionAmount}',
                    radius: '55%',
                    dataLabelSettings: DataLabelSettings(
                      textStyle: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).hintColor,),                      
                      isVisible: true,
                      margin: EdgeInsets.zero,
                      labelIntersectAction: LabelIntersectAction.shift,
                      overflowMode: OverflowMode.shift,
                      labelAlignment: ChartDataLabelAlignment.auto,
                      showZeroValue: true,
                      labelPosition: ChartDataLabelPosition.outside,
                      connectorLineSettings: const ConnectorLineSettings(
                        length: '20%',
                        type: ConnectorType.line,
                      ),
                    ),
                    explode: true,
                    explodeIndex: getExplodeIndex(),
                    // pointColorMapper: (AllTransactionDetails data, _) {
                    //   List<Color> colors = [
                    //     Colors.red,
                    //     Colors.blue,
                    //     Colors.green,
                    //     Colors.yellow,
                    //   ];

                    //   int index = widget.currentPageTransactions.indexOf(data);
                    //   return colors[index % colors.length];
                    // },
                  ),
                ],
                legend: Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                  overflowMode: LegendItemOverflowMode.wrap,
                ),
              ),
      ),
    );
  }
}
