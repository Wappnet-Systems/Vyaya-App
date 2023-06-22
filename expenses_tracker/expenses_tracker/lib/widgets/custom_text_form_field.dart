import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextInputType textInputType;
  final TextEditingController textEditingController;
  final String textEditingHintText;
  final Icon? customPreFixIcon;
  final bool customObscureText;
  final String? Function(String? value)? validationFunction;
  final InkWell? customInkwell; 
  // final bool? readOnly;
  
  const CustomTextFormField({super.key, required this.textInputType,
      required this.textEditingController,
      required this.textEditingHintText,
      required this.customPreFixIcon,
      required this.customObscureText,
      required this.validationFunction,
      required this.customInkwell,
      });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      obscureText: !customObscureText,
      enableInteractiveSelection: false,
      cursorColor: Theme.of(context).colorScheme.onPrimary,
      controller: textEditingController,
      decoration: InputDecoration(
      border: OutlineInputBorder(
      borderSide: BorderSide(color:Theme.of(context).hintColor),
      borderRadius: BorderRadius.circular(18.0)
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color:Theme.of(context).colorScheme.onPrimary),
          borderRadius: BorderRadius.circular(18.0)
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
        hintText: textEditingHintText,
        hintStyle: TextStyle(
          color: Theme.of(context).hintColor,
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        prefixIcon: customPreFixIcon,
        suffixIcon: customInkwell,
      ),
      validator: validationFunction,
    );
  }
}