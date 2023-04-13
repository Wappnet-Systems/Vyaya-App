import 'package:expenses_tracker/utils/const.dart';
import 'package:flutter/material.dart';

class CustomButtomBar extends StatelessWidget{
  CustomButtomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: PrimaryColor.color_white,
      child: Row(
        children: [
          SizedBox(width: 15),
          Container(
            height: MediaQuery.of(context).size.height * .15,
            child: Column(
              children: [
                IconButton(
                    icon: Icon(
                      Icons.home,
                      color: PrimaryColor.color_bottle_green,
                    ),
                    onPressed: () {}),
                Text(
                  "Home",
                  style: TextStyle(color: PrimaryColor.color_bottle_green),
                ),
              ],
            ),
          ),
        ],
      ),
      shape: CircularNotchedRectangle(), //shape of notch
      notchMargin: 7,
    );
  }
  }
