import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socially/router/route_names.dart';
import 'package:socially/utils/constants/colors.dart';
import 'package:socially/widgets/reusable/custom_button.dart';
import 'package:socially/widgets/reusable/custom_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsetsGeometry.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Image.asset(
                "assets/logo.png",
                width: MediaQuery.of(context).size.width * 0.4,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.06),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    ReusableInput(
                      iconData: Icons.email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email!";
                        }
                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      controller: _emailController,
                      labelText: "Email",
                      obscureText: false,
                    ),

                    const SizedBox(height: 16),
                    ReusableInput(
                      iconData: Icons.lock,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email!";
                        }
                        if (value.length < 6) {
                          return "Too Short!";
                        }
                        return null;
                      },
                      controller: _passwordController,
                      labelText: "Password",
                      obscureText: true,
                    ),

                    const SizedBox(height: 16),
                    ReusableButton(
                      buttonText: "Log In",
                      width: double.infinity,
                      onPressed: () {
                        //todo:signup logic
                      },
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Sign in with Google to access the app's features",
                      style: TextStyle(
                        fontSize: 13,
                        // ignore: deprecated_member_use
                        color: mainWhiteColor.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ReusableButton(
                      buttonText: 'Sign in with Google',
                      width: double.infinity,
                      onPressed: () {
                        //todo:gogle sign in
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    (context).goNamed(RouteNames.register);
                  },
                  child: Text(
                    "Don't have an account? Sign Up",
                    style: TextStyle(fontSize: 14, color: mainWhiteColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
