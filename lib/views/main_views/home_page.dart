import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
    );
  }
}
