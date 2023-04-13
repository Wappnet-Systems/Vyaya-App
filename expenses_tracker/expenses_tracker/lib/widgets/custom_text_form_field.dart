import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextInputType textInputType;
  final TextEditingController textEditingController;
  final String texteditinghinttext;
  final Icon? customprefixicon;
  final bool customobscuretext;
  final String? Function(String? value)? validationfunction;
  final InkWell? custominkwell; 
  // final bool? readOnly;
  
  const CustomTextFormField({super.key, required this.textInputType,
      required this.textEditingController,
      required this.texteditinghinttext,
      required this.customprefixicon,
      required this.customobscuretext,
      required this.validationfunction,
      required this.custominkwell,
      });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      style: TextStyle(color: Color(0xff000000)),
      obscureText: !customobscuretext,
      cursorColor: Color(0xff000000),
      controller: textEditingController,
      // readOnly: readOnly!,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff000000)),
          borderRadius: BorderRadius.vertical(),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff000000)),
          borderRadius: BorderRadius.vertical(),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 13, vertical: 12),
        hintText: texteditinghinttext,
        hintStyle: TextStyle(
          color: Color(0xff000000),
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
        prefixIcon: customprefixicon,
        suffixIcon: custominkwell,
        
      ),
      validator: validationfunction,
    );
  }
}