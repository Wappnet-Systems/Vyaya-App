import 'package:expenses_tracker/exports.dart';

class CustomNoData extends StatelessWidget {
  const CustomNoData({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomTextStyle(
        customTextStyleText: "No Data",
        customTextColor: Theme.of(context).hintColor,
        customTextFontWeight: FontWeight.bold,
        customTextStyle: null,
        customTextSize: MediaQuery.of(context).size.height * 0.025);
  }
}
