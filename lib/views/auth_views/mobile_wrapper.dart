import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socially/views/auth_views/login.dart';
import 'package:socially/views/main_views/home_page.dart';

class MobileWrapper extends StatelessWidget {
  const MobileWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return HomePage();
        }
        return LoginPage();
      },
    );
  }
}
