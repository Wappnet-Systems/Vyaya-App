import 'package:flutter/material.dart';

import '../utils/const.dart';

class CustomHeader extends StatelessWidget {
  final String? wishingText, username, initialOfName;
  final Color? textColor;
  const CustomHeader(
      {super.key,
      required this.initialOfName,
      required this.username,
      required this.wishingText,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 1.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("$wishingText",
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Theme.of(context).colorScheme.secondary)),
              Text("$username",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontSize: 22.0,
                      color: Theme.of(context).colorScheme.secondary)),
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.15,
          height: MediaQuery.of(context).size.width * 0.15,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            color: PrimaryColor.colorBottleGreen,
            child: Center(
                child: Text("$initialOfName",
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(color: PrimaryColor.colorWhite))),
          ),
        )
      ],
    );
  }
}
