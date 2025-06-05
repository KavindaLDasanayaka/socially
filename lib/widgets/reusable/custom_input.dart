import 'package:flutter/material.dart';
import 'package:socially/utils/constants/colors.dart';

class ReusableInput extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final IconData iconData;
  final String? Function(String?)? validator;
  final bool obscureText;

  const ReusableInput({
    super.key,

    required this.iconData,
    required this.validator,
    required this.controller,
    required this.labelText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    final borderStyle = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
      borderRadius: BorderRadius.circular(10),
    );

    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(iconData, size: 20),
        border: borderStyle,
        focusedBorder: borderStyle,
        enabledBorder: borderStyle,
        labelText: labelText,
        labelStyle: TextStyle(color: mainWhiteColor),
        filled: true,
      ),
      obscureText: obscureText,
    );
  }
}
