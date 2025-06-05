import 'package:flutter/material.dart';
import 'package:socially/utils/constants/colors.dart';

class ReusableButton extends StatelessWidget {
  final String buttonText;
  final double width;
  final VoidCallback onPressed;
  const ReusableButton({
    super.key,
    required this.buttonText,
    required this.width,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 50,
      decoration: BoxDecoration(
        gradient: gradientColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: TextStyle(fontSize: 16, color: mainWhiteColor),
        ),
      ),
    );
  }
}
