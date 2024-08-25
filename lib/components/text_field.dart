import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController textController;
  final TextInputType keyboard;
  final bool isObscure;
  final Widget? prefixIcon;
  final Widget? suffixIcon;


  const CustomTextField({
    super.key,
    required this.hintText,
    required this.textController,
    this.keyboard = TextInputType.text,
    this.isObscure = false,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return  TextField(
      controller: textController,
      keyboardType: keyboard,
      obscureText: isObscure,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon
      ),
    );
  }
}
