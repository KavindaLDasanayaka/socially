import 'package:flutter/material.dart';
import 'package:socially/utils/constants/app_constants.dart';

class ResponsiveLayoutScreen extends StatefulWidget {
  final Widget mobileScreenLayout;
  final Widget webScreenLayout;
  const ResponsiveLayoutScreen({
    super.key,
    required this.mobileScreenLayout,
    required this.webScreenLayout,
  });

  @override
  State<ResponsiveLayoutScreen> createState() => _ResponsiveLayoutScreenState();
}

class _ResponsiveLayoutScreenState extends State<ResponsiveLayoutScreen> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > webScreenMinWidth) {
          return widget.webScreenLayout;
        } else {
          return widget.mobileScreenLayout;
        }
      },
    );
  }
}
