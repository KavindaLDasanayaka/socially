import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socially/router/route_names.dart';
import 'package:socially/services/auth/auth_service.dart';
import 'package:socially/utils/constants/colors.dart';
import 'package:socially/utils/functions/functions.dart';
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

  //login with email and password
  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    try {
      await AuthService().signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("User signed in successfully!")));

        //naviate to main page
        (context).goNamed(RouteNames.mainScreen);
      }
    } catch (err) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Error"),
            content: Text("Error sign in with email and password :$err"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          ),
        );
      }

      print("Error login pw in ui :$err");
    }
  }

  //sign in with google
  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await AuthService().signInWithGoogle();
      //show snack bar
      if (context.mounted) {
        UtilFunctions().showSnackBar(
          context: context,
          message: "Login Successfull",
        );

        //naviate to main page
      }
      (context).goNamed(RouteNames.mainScreen);
    } catch (err) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Login Failed ui: $err"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

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
                      onPressed: () async {
                        //todo:signup logic
                        if (_formKey.currentState!.validate()) {
                          await _signInWithEmailAndPassword(context);
                        }
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
                        _signInWithGoogle(context);
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
