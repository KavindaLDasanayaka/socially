import 'package:flutter/material.dart';

class UtilFunctions {
  //show snack bar
  void showSnackBar({required BuildContext context, required String message}) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
