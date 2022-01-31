
import 'package:flutter/material.dart';

class DefaultTextFormField extends StatelessWidget {

    TextInputType type;
    TextEditingController controller;
    Icon prefixicon;
    String hint;
    bool isPassword = false;
    IconData suffixicon;
    Function sufOnPressed;
    Function validate;
    Function ontap;
    bool enabled = true;
    Function onSubmitted;

    DefaultTextFormField({
    @required  this.type,
    @required  this.controller,
     this.prefixicon,
      this.hint,
     this.isPassword = false,
     this.suffixicon,
     this.sufOnPressed,
     this.validate,
     this.ontap,
     this.enabled = true,
     this.onSubmitted,
  });



  @override
  Widget build(BuildContext context) {
      return TextFormField(
        enabled: enabled,
        validator: validate,
        obscureText: isPassword,
        keyboardType: type,
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(suffixicon),
            onPressed: sufOnPressed,
          ),
          prefixIcon: prefixicon,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        onFieldSubmitted: onSubmitted,
        onTap: ontap,
      );
  }
}
