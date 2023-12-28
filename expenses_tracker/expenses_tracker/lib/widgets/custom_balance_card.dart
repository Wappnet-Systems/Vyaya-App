import 'package:expenses_tracker/exports.dart';

class CustomBalanceCard extends StatelessWidget {
  final int balanceOfTheMonthValue;
  final Color? themeColor, textThemeColor;
  const CustomBalanceCard(
      {super.key,
      required this.balanceOfTheMonthValue,
      required this.themeColor,
      required this.textThemeColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
          width: MediaQuery.of(context).size.width * 0.50,
          child: Card(
            color: themeColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: PrimaryColor.colorWhite),
            ),
            child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: balanceOfTheMonthValue > 0
                      ? SizedBox(
                        width: MediaQuery.of(context).size.width * 0.50,
                        child: Center(
                          child: Text("Balance: ₹$balanceOfTheMonthValue",style: TextStyle(color: textThemeColor,fontWeight: FontWeight.normal,fontSize: MediaQuery.of(context).size.width/25),textAlign: TextAlign.left,maxLines: 1,  overflow: TextOverflow.clip,),
                        ),
                      )
                      : SizedBox(
                        width: MediaQuery.of(context).size.width * 0.50,
                        child: Center(
                          child: Text("Balance: -₹${balanceOfTheMonthValue.abs()}",style: TextStyle(color: textThemeColor,fontWeight: FontWeight.normal,fontSize: MediaQuery.of(context).size.width/25),textAlign: TextAlign.left,maxLines: 1,  overflow: TextOverflow.ellipsis),
                        ),
                      ),
                )),
          )),
    );
  }
}