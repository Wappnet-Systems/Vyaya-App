// ignore_for_file: must_be_immutable

import 'package:expenses_tracker/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class CustomCircularSlider extends StatelessWidget {
  Color? sliderColor;
  final double initialValue;
  

  CustomCircularSlider({super.key, 
    required this.initialValue,this.sliderColor    
  });

  @override
  Widget build(BuildContext context) {
    return SleekCircularSlider(
      appearance: CircularSliderAppearance(
        startAngle: 0,
        angleRange: 360,
        customColors: CustomSliderColors(
          trackColor: Theme.of(context).hintColor,
          progressBarColor: sliderColor ?? PrimaryColor.colorBottleGreen,
          dotColor: sliderColor ?? PrimaryColor.colorBottleGreen,
        ),
        customWidths: CustomSliderWidths(
          trackWidth: 1.5,
          progressBarWidth: 2.5,
          handlerSize: 4,
        ),
        infoProperties: InfoProperties(
          modifier: (double value) {
            final roundedValue = value.ceil().toInt().toString();
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
      initialValue: initialValue,
    );
  }
}
