import 'package:expenses_tracker/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class CustomPfRow extends StatefulWidget {
  final String labelText,hintText;
  final TextEditingController textEditingController;
  final TextInputAction textInputAction;
  
  const CustomPfRow({super.key, required this.labelText, required this.hintText, required this.textEditingController, required this.textInputAction});

  @override
  State<CustomPfRow> createState() => _CustomPfRowState();
}

class _CustomPfRowState extends State<CustomPfRow> {
  FocusNode? focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    focusNode!.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    focusNode!.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = focusNode!.hasFocus;
    });
  }

  int getValue() {
    if (widget.textEditingController.text.isEmpty) {
      return 0;
    }
  
    try {
      return int.parse(widget.textEditingController.text);
    } catch (e) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        
        Flexible(
          child: TextFormField(
            
            validator: personalFinanceValidator,
            enableInteractiveSelection: false,
            focusNode: focusNode,
            cursorColor: Theme.of(context).colorScheme.onPrimary,
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(2),],
            keyboardType: TextInputType.phone,
            
            controller: widget.textEditingController,
            decoration: InputDecoration(
                suffixIcon: Icon(Icons.percent,size: MediaQuery.of(context).size.height*0.018,color: _isFocused ? Theme.of(context).colorScheme.onPrimary : Colors.grey,),
                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary),
                ),
                labelText: widget.labelText,
                labelStyle: TextStyle(
          color: _isFocused ? Theme.of(context).colorScheme.onPrimary : Colors.grey, // Change color based on focus
          fontSize: 16,
        ),
                hintText: widget.hintText),
          ),
        ),
      ],
    );
  }
}
