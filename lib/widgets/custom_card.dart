import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class CustomCard extends StatelessWidget {
  final int? speOrIncMonthValue;
  final Icon? icon;
  final Color? color, themeColor;
  final String? title;
  const CustomCard(
      {super.key,
      required this.color,
      required this.icon,
      required this.speOrIncMonthValue,
      required this.title,
      required this.themeColor});

  @override
  Widget build(BuildContext context) {
    String formatCurrency(int? value) {
      NumberFormat currencyFormat = NumberFormat.currency(
        symbol: '₹',
        locale: "HI",
        decimalDigits: 0,
      );
      return currencyFormat.format(value);
    }

    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: color,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.45,
          height: MediaQuery.of(context).size.height * 0.08,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60)),
                  color: themeColor,
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.14,
                      height: MediaQuery.of(context).size.width * 0.14,
                      child: icon),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$title',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: themeColor),
                  ),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width / 4,
                    child: Text(
                      formatCurrency(speOrIncMonthValue),
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(color: themeColor),
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
