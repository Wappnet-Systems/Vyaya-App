import 'package:flutter/material.dart';

import '../utils/const.dart';

class CustomTransaction extends StatelessWidget {
  final Color? icon_color;
  final int? categoryid,subcateid,transaction_amount;
  final String? transactionnote,datestamp,timestamp;
  CustomTransaction({super.key,required this.icon_color,required this.categoryid,required this.subcateid,required this.transaction_amount,required this.transactionnote,required this.datestamp,required this.timestamp});

  @override
  Widget build(BuildContext context) {
    return Container(
                                  color: PrimaryColor.color_white,
                                  height: MediaQuery.of(context).size.height *
                                      0.112,
                                  width: MediaQuery.of(context).size.width,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(
                                            color: PrimaryColor
                                                .color_bottle_green)),
                                    color: PrimaryColor.color_white,
                                    child: Column(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.08,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.18,
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.08,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.18,
                                                        child: Card(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          60)),
                                                          color: categoryid == 0 || categoryid ==3 ?PrimaryColor.color_bottle_green :PrimaryColor.color_red,
                                                          child: categoryid == 0 || categoryid ==3
                                                              ? ListOfAppData
                                                                  .listofIncome[
                                                                      subcateid!]
                                                                  .categoryIcon
                                                              : ListOfAppData
                                                                  .listOfCategory[
                                                                      subcateid!]
                                                                  .categoryIcon,
                                                        ),
                                                      ),
                                                      Positioned(
                                                          bottom: 2,
                                                          right: 0,
                                                          child: Container(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.032,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.072,
                                                            child: Card(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            60)),
                                                                elevation: 5,
                                                                child:
                                                                    categoryid ==
                                                                            0 || categoryid==3
                                                                        ? Icon(
                                                                            Icons.arrow_downward,
                                                                            color:
                                                                                PrimaryColor.color_bottle_green,
                                                                            size:
                                                                                MediaQuery.of(context).size.height * 0.02,
                                                                          )
                                                                        : Icon(
                                                                            Icons.arrow_upward,
                                                                            color:
                                                                                PrimaryColor.color_red,
                                                                            size:
                                                                                MediaQuery.of(context).size.height * 0.02,
                                                                          )),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "₹${transaction_amount}",
                                                      style: TextStyle(
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.025,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          '${transactionnote}',
                                                          style: TextStyle(
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.019),
                                                        ),
                                                      ],
                                                    ),
                                                    Divider(
                                                      height: 0.1,
                                                      color: Colors.grey,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text('$datestamp \t$timestamp'),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.059,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 5.0),
                                                  child: Icon(
                                                    Icons.money,
                                                    color: PrimaryColor
                                                        .color_bottle_green,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ]),
                                  ),
                                );

  }
}