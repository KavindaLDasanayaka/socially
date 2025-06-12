import 'package:flutter/material.dart';
import 'package:socially/services/auth/auth_service.dart';
import 'package:socially/widgets/reusable/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Center(
        child: ReusableButton(
          buttonText: "Logout",
          width: double.infinity,
          onPressed: () {
            AuthService().signOut();
          },
        ),
      ),
    );
  }
}
