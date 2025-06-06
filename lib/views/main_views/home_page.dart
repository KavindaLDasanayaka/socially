import 'package:flutter/material.dart';
import 'package:socially/services/auth/auth_service.dart';
import 'package:socially/widgets/reusable/custom_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.only(right: 20),
        title: Image.asset(
          "assets/logo.png",
          width: MediaQuery.of(context).size.width * 0.4,
        ),
      ),
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
