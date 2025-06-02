import 'package:flutter/material.dart';

class CustomNoData extends StatelessWidget {
  const CustomNoData({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('No Data',style: Theme.of(context).textTheme.displayLarge!.copyWith(color: Theme.of(context).hintColor,fontWeight: FontWeight.bold),);
  }
}
