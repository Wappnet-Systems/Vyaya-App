// import 'package:flutter/material.dart';

// import '../utils/responsive.dart';

// class ConfirmDialog extends StatefulWidget {
//   final bool? load;
//   final String title;
//   final String middleText;
//   final String? confirmButtonText;
//   final Color? backgroundColor;
//   final Widget? icon;
//   final bool? showCancelButton;
//   final void Function() cancelOnPressed;
//   final void Function() confirmOnPressed;

//   ConfirmDialog({
//     this.load,
//     required this.title,
//     required this.middleText,
//     this.confirmButtonText,
//     this.backgroundColor,
//     this.icon,
//     this.showCancelButton = true,
//     required this.cancelOnPressed,
//     required this.confirmOnPressed,
//   });

//   @override
//   _ConfirmDialogState createState() => _ConfirmDialogState();
// }

// class _ConfirmDialogState extends State<ConfirmDialog> {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 200,
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Stack(
//           children: <Widget>[
//             Wrap(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 25,
//                   ),
//                   margin: EdgeInsets.symmetric(
//                     vertical: hp(30),
//                     horizontal: wp(10),
//                   ),
//                   decoration: BoxDecoration(
//                     shape: BoxShape.rectangle,
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(18),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.5),
//                         offset: const Offset(0, 1),
//                         blurRadius: 1.0,
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         height: hp(4),
//                       ),
//                       Text(
//                         widget.title,
//                         textAlign: TextAlign.center,
//                         style: texttitleBold,
//                       ),
//                       const SizedBox(
//                         height: 11,
//                       ),
//                       Text(
//                         widget.middleText,
//                         textAlign: TextAlign.center,
//                         style: textMediumRegular,
//                       ),
//                       const SizedBox(
//                         height: 11,
//                       ),
//                       Row(
//                         children: [
//                           Flexible(
//                             flex: 1,
//                             child: FillButtonWidget(
//                               height: hp(5),
//                               color: COLOR_PRIMARY_DARK,
//                               title: widget.confirmButtonText ?? "Got it",
//                               onPressed: widget.confirmOnPressed,
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 8,
//                           ),
//                           widget.showCancelButton!
//                               ? Flexible(
//                                   flex: 1,
//                                   child: FillButtonWidget(
//                                     height: hp(5),
//                                     width: MediaQuery.of(context).size.width / 2,
//                                     color: COLOR_PRIMARY_LIGHT,
//                                     title: "Cancel",
//                                     onPressed: widget.cancelOnPressed,
//                                   ),
//                                 )
//                               : const SizedBox.shrink()
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             Positioned(
//               left: wp(10),
//               right: wp(10),
//               top: hp(25),
//               child: CircleAvatar(
//                 backgroundColor: COLOR_BACKGROUND,
//                 radius: hp(5.2),
//                 child: CircleAvatar(
//                   backgroundColor: widget.backgroundColor ?? COLOR__DARK_GREEN,
//                   radius: hp(4.9),
//                   child: IconButton(
//                     padding: EdgeInsets.zero,
//                     icon: widget.icon ??
//                         Icon(
//                           Icons.thumb_up_alt_outlined,
//                           size: hp(5),
//                         ),
//                     color: COLOR_BACKGROUND,
//                     onPressed: () {},
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// void showConfirmDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return ConfirmDialog(
//         title: 'Title',
//         middleText: 'Middle Text',
//         confirmButtonText: 'Confirm',
//         cancelOnPressed: () {
//           // Cancel button pressed logic
//         },
//         confirmOnPressed: () {
//           // Confirm button pressed logic
//         },
//       );
//     },
//   );
// }