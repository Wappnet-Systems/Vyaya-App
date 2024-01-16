import 'package:expenses_tracker/utils/const.dart';
import 'package:expenses_tracker/widgets/custom_slider.dart';
import 'package:flutter/material.dart';

class SpendingCategoryPercentage extends StatefulWidget {
  final Map<String, double>? averages;
  const SpendingCategoryPercentage({super.key, this.averages});

  @override
  State<SpendingCategoryPercentage> createState() =>
      _SpendingCategoryPercentageState();
}

class _SpendingCategoryPercentageState
    extends State<SpendingCategoryPercentage> {
  Map<String, double>? topValues;
  final List<Color> customColors = [
    PrimaryColor.colorRed,
    PrimaryColor.colorBlue,
    PrimaryColor.colorBottleGreen,
    
  ];

  @override
  void initState() {
    var sortedEntries = widget.averages!.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    var top3Entries = sortedEntries;
    topValues = Map.fromEntries(top3Entries);
    super.initState();
  }

  Color getCustomColor(int index) {
    return customColors[index % customColors.length];
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        backgroundColor: Theme.of(context).bottomAppBarTheme.color,
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.secondary),
        title: Text('Most Spending Categories',
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: Theme.of(context).colorScheme.secondary)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
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
                                  topValues!.entries.elementAt(1).value,
                              sliderColor: PrimaryColor.colorBlue,
                            ),
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: 80,
                                  child: Text(
                                      topValues!.entries.elementAt(1).key,
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
                                  topValues!.entries.elementAt(0).value,
                              sliderColor: PrimaryColor.colorRed,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: 80,
                                  child: Text(
                                      topValues!.entries.elementAt(0).key,
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
                                  topValues!.entries.elementAt(2).value,
                              sliderColor: PrimaryColor.colorBottleGreen,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: 80,
                                  child: Text(
                                      topValues!.entries.elementAt(2).key,
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
                ],
              ),
            ),
          ),
          const SizedBox(height: 10,),
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: topValues!.length - 3,
              itemBuilder: (context, index) {
                Color customColor = getCustomColor(index);
                int value=index+3;
                return Card(
                  child: Container(
                    height: 60,
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 07,),
                        Text('#${value+1}',style: Theme.of(context).textTheme.displaySmall!.copyWith(color: customColor),),
                        SizedBox(
                          width: 60,
                          child: CustomCircularSlider(
                            initialValue: topValues!.entries.elementAt(value).value,
                            sliderColor: customColor,
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Text(topValues!.entries.elementAt(value).key)
                      ],
                    ),
                  
                  ),
                );
              }),
        ],
      ),
    );
  }
}
