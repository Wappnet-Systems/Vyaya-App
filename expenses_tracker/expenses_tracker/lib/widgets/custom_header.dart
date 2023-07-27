import 'package:flutter/material.dart';

import '../utils/const.dart';
import 'custom_text_style.dart';

class CustomHeader extends StatelessWidget {
  final String? wishingText, username, initialOfName;
  final Color? textColor;

  const CustomHeader({
    Key? key,
    required this.initialOfName,
    required this.username,
    required this.wishingText,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    // Mobile and tablet view
    if (screenWidth < 600) {
      return _buildMobileTableView(context);
    }
    // Desktop view
    else if (screenWidth >= 600 && screenWidth < 900) {
      return _buildDesktopView(context);
    }
    // Large screen view
    else {
      return _buildLargeScreenView(context);
    }
  }

  Widget _buildMobileTableView(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height*0.075,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex:85,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextStyle(
                  customTextStyleText: "$wishingText",
                  customTextColor: textColor,
                  customTextFontWeight: FontWeight.normal,
                  customTextSize: MediaQuery.sizeOf(context).height*0.022,
                  customtextstyle: null,
                ),
                CustomTextStyle(
                  customTextStyleText: "$username",
                  customTextColor: textColor,
                  customTextFontWeight: FontWeight.w400,
                  customTextSize: MediaQuery.sizeOf(context).height*0.025,
                  customtextstyle: null,
                ),
              ],
            ),
          ),
          Expanded(
            flex:15,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              color: PrimaryColor.colorBottleGreen,
              child: Center(
                child: Text(
                  "$initialOfName",
                  style: TextStyle(
                    color: PrimaryColor.colorWhite,
                    fontSize: MediaQuery.of(context).size.height * 0.040,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopView(BuildContext context) {
    return SizedBox(
      height:MediaQuery.sizeOf(context).height*0.075,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextStyle(
                  customTextStyleText: "$wishingText",
                  customTextColor: textColor,
                  customTextFontWeight: FontWeight.normal,
                  customTextSize: MediaQuery.of(context).size.height * 0.022,
                  customtextstyle: null,
                ),
                CustomTextStyle(
                  customTextStyleText: "$username",
                  customTextColor: textColor,
                  customTextFontWeight: FontWeight.w400,
                  customTextSize: MediaQuery.of(context).size.height *0.025,
                  customtextstyle: null,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              color: PrimaryColor.colorBottleGreen,
              child: Center(
                child: Text(
                  "$initialOfName",
                  style: TextStyle(
                    color: PrimaryColor.colorWhite,
                    fontSize: MediaQuery.of(context).size.height * 0.035,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLargeScreenView(BuildContext context) {
    return SizedBox(
      height:MediaQuery.sizeOf(context).height*0.080,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex:85,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextStyle(
                  customTextStyleText: "$wishingText",
                  customTextColor: textColor,
                  customTextFontWeight: FontWeight.normal,
                  customTextSize:MediaQuery.sizeOf(context).height*0.022,
                  customtextstyle: null,
                ),
                CustomTextStyle(
                  customTextStyleText: "$username",
                  customTextColor: textColor,
                  customTextFontWeight: FontWeight.w400,
                  customTextSize: MediaQuery.sizeOf(context).height*0.025,
                  customtextstyle: null,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 15,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              color: PrimaryColor.colorBottleGreen,
              child: Center(
                child: Text(
                  "$initialOfName",
                  style: TextStyle(
                    color: PrimaryColor.colorWhite,
                    fontSize: MediaQuery.of(context).size.height * 0.040,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
