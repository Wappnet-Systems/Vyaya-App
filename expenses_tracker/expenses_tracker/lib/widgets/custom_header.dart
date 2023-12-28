import 'package:expenses_tracker/exports.dart';

class CustomHeader extends StatelessWidget {
  final String? wishingText,username,initialOfName;
  final Color? textColor;
  const CustomHeader({super.key,required this.initialOfName,required this.username,required this.wishingText,required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width:MediaQuery.of(context).size.width/1.8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextStyle(
                                  customTextStyleText: "$wishingText",
                                  customTextColor: textColor,
                                  customTextFontWeight: FontWeight.normal,
                                  customTextSize: 17.0,
                                  customTextStyle: null,
                                ),
                                CustomTextStyle(
                                      customTextStyleText: "$username",
                                      customTextColor: textColor,
                                      customTextFontWeight: FontWeight.w400,
                                      customTextSize: 22.0,
                                      customTextStyle: null,
                                    ),
                                  
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: MediaQuery.of(context).size.width * 0.15,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              color: PrimaryColor.colorBottleGreen,
                              child: Center(
                                  child: Text(
                                "$initialOfName",
                                style: TextStyle(
                                    color: PrimaryColor.colorWhite,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.035),
                              )),
                            ),
                          )
                           ],
                      );
  }
}