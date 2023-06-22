import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'custom_text_style.dart';

class CustomPfRow extends StatelessWidget {
  final String labelText,hintText;
  final TextEditingController textEditingController;
  final MaskTextInputFormatter maskTextInputFormatter;
  const CustomPfRow({super.key, required this.labelText, required this.hintText, required this.textEditingController, required this.maskTextInputFormatter});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
            child: CustomTextStyle(
                customTextStyleText: labelText,
                customTextColor: Theme.of(context).colorScheme.secondary,
                customTextFontWeight: FontWeight.w400,
                customtextstyle: null,
                customTextSize: MediaQuery.of(context).size.height * 0.020)),
        const SizedBox(
          width: 10,
        ),
        Flexible(
          flex: 3,
          child: TextField(
            enableInteractiveSelection: false,
            cursorColor: Theme.of(context).colorScheme.onPrimary,
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            inputFormatters: [maskTextInputFormatter],
            keyboardType: TextInputType.phone,
            controller: textEditingController,
            decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary),
                ),
                hintText: hintText),
          ),
        ),
      ],
    );
  }
}
