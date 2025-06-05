import 'package:flutter/material.dart';
import 'package:socially/widgets/reusable/custom_button.dart';

class MobileScreenLayout extends StatelessWidget {
  const MobileScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Text("Mobile screen layout")),

            const SizedBox(height: 10),
            ReusableButton(
              buttonText: "Log in",
              width: double.infinity,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
