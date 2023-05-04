import 'package:flutter/material.dart';

class SkeletonForTransaction extends StatelessWidget {
  const SkeletonForTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListView.builder(itemCount: 10,itemBuilder: (BuildContext context, int index) {
        return Card(
                    color: Colors.grey[100]!,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.112,
                      width: MediaQuery.of(context).size.width,
                    ),
                  );
      }),
    );
  }
}