// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  final TextInputType textInputType;
  final TextEditingController textEditingController;
  final String textEditingHintText;
  final Icon? customPreFixIcon;
  final bool customObscureText;
  final String? Function(String? value)? validationFunction;
  final InkWell? customInkwell; 
  bool? readOnly;
  TextCapitalization? textCapitalization;
  List<TextInputFormatter>? inputFormatters;
  final TextInputAction textInputAction;
  // final bool? readOnly;
  
  CustomTextFormField({super.key, required this.textInputType,
      required this.textEditingController,
      required this.textEditingHintText,
      required this.customPreFixIcon,
      required this.customObscureText,
      required this.validationFunction,
      required this.customInkwell,
      this.textCapitalization,
      required this.textInputAction,
      this.readOnly,
      this.inputFormatters
      });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: widget.textInputAction,
      scrollPadding: const EdgeInsets.only(bottom: 200),
      textCapitalization: widget.textCapitalization!,
      inputFormatters: widget.inputFormatters,
      keyboardType: widget.textInputType,
      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      obscureText: !widget.customObscureText,
      cursorColor: Theme.of(context).colorScheme.onPrimary,
      readOnly: widget.readOnly ?? false,
      controller: widget.textEditingController,
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
        hintText: widget.textEditingHintText,
        hintStyle: TextStyle(
          color: Theme.of(context).hintColor,
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        prefixIcon: widget.customPreFixIcon,
        suffixIcon: widget.customInkwell,
      ),
      validator: widget.validationFunction,
    );
  }
}