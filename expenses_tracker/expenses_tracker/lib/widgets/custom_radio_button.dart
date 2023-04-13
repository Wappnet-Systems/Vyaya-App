// import 'package:expenses_tracker/utils/const.dart';
// import 'package:flutter/material.dart';

// class CustomRadioButton extends StatefulWidget {
  
//   const CustomRadioButton({super.key});

//   @override
//   State<CustomRadioButton> createState() => _CustomRadioButtonState();
// }

// class _CustomRadioButtonState extends State<CustomRadioButton> {

// Widget customRadioButton(String text, int index) {
//     var value=0;
//     return OutlinedButton(
//       onPressed: () {
//         setState(() {
//           value = index;
//         });
//       },
//       style: OutlinedButton.styleFrom(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         side: BorderSide(color: (value == index) ? Colors.amberAccent : Colors.black),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           color: (value == index) ? Colors.amberAccent : Colors.black,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Scaffold(
//         body: SafeArea(
//           child: Container(
//             padding: EdgeInsets.all(10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 customRadioButton('5 min', 0),
//                           SizedBox(
//                             width: MediaQuery.of(context).size.width * 0.02,
//                           ),
//                           customRadioButton('10 min', 1),
//                           SizedBox(
//                             width: MediaQuery.of(context).size.width * 0.02,
//                           ),
//                           customRadioButton('15 min', 2),
//                           SizedBox(
//                             width: MediaQuery.of(context).size.width * 0.02,
//                           ),
                           
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }