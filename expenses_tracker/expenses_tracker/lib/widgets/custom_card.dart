import 'package:intl/intl.dart';
import 'package:expenses_tracker/exports.dart';

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
                      height: MediaQuery.of(context).size.width*0.14,
                      child: icon),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextStyle(
                      customTextStyleText: "$title",
                      customTextColor: themeColor,
                      customTextFontWeight: FontWeight.normal,
                      customTextStyle: null,
                      customTextSize: MediaQuery.of(context).size.width/25), 
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width/4,
                    child: Text(formatCurrency(speOrIncMonthValue),style: TextStyle(color: themeColor,fontSize: MediaQuery.of(context).size.width/25),overflow: TextOverflow.fade,maxLines: 1,)),
                                        
                  // CustomTextStyle(
                  //     customTextStyleText: formatCurrency(speOrIncMonthValue),
                  //     customTextColor: themeColor,
                  //     customTextFontWeight: FontWeight.normal,
                  //     customtextstyle: null,
                  //     customTextSize: MediaQuery.of(context).size.width/25),
                ],
              )
            ],
          ),
        ));
  }
}
