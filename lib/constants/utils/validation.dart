String? textFormFieldValidator(String? value) {
  if (value!.isEmpty) {
    return 'Please this field must be filled';
  } 
  return null;
}

String? nameValidator(String? value){
  if (value!.isNotEmpty) {
    if(value.length >20){      
      return 'Please Enter Name Which contain 20 Characters';
    }
    if (value.contains(' ')) {
      return 'Input cannot contain blank spaces.';
    }
    else if(value.isEmpty){
    return 'Please this field must be filled';
    }
    return null;
  }
  else if(value.isEmpty){
    return 'Please this field must be filled';
  }
  return null; 
}

String noteValidator(String value){
  if(value.length>=20){
      return 'Transaction note up to 20 characters';
    }
  return "";
}

String? amountValidator(String? value){
  if (value == null || value.isEmpty) {
      return 'Please enter a number';
    }
    if (value.contains(RegExp(r'[!@#$%^&*(),?":{}|<>-]'))) {
      return 'Symbols are not allowed';
    }
    if (value.contains('.')) {
      return 'Dot is not allowed';
    }
    if (value.trim() == '') {
      return 'Blank spaces are not allowed';
    }
    try {
      if (int.parse(value) == 0) {
        return 'Value cannot be 0';
      }
    } catch (error) {
      return 'Invalid number format';
    }
  return null;
}

String? personalFinanceValidator(String? value){
  if (value == null || value.isEmpty) {
      return 'Please enter a number';
    }
    if (value.contains(RegExp(r'[!@#$%^&*(),?":{}|<>-]'))) {
      return 'Symbols are not allowed';
    }
    if (value.contains('.')) {
      return 'Dot is not allowed';
    }
    if (value.trim() == '') {
      return 'Blank spaces are not allowed';
    }
    if (int.parse(value) == 0) {
      return 'Value cannot be 0';
    }
    if(value.length<2){
      return 'Please Enter Possible Value';
    }
  
  return null;
}


String? emailValidator(String? value) {
  String pattern =
       r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$";
  RegExp regex = RegExp(pattern);
  if (value!.isEmpty) {
    return 'Please this field must be filled';
  } else if (!regex.hasMatch(value)) {
    return 'Please enter valid email';
  }
  return null;
}