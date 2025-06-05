import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socially/models/user_model.dart';
import 'package:socially/router/route_names.dart';
import 'package:socially/services/auth/auth_service.dart';
import 'package:socially/services/storage/user_storage.dart';
import 'package:socially/services/users/user_service.dart';
import 'package:socially/utils/constants/colors.dart';
import 'package:socially/widgets/reusable/custom_button.dart';
import 'package:socially/widgets/reusable/custom_input.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  File? _imageFile;

  //pick the image
  Future<void> _pickImage(ImageSource source) async {
    final _picker = ImagePicker();
    final _pickedImage = await _picker.pickImage(source: source);

    if (_pickedImage != null) {
      setState(() {
        _imageFile = File(_pickedImage.path);
      });
    }
  }

  Future<void> _selectSource(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        alignment: Alignment.center,
        title: Text("Please Select Source"),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(mainPurpleColor),
                ),
                onPressed: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
                child: Text(
                  "Gallery",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: mainWhiteColor,
                  ),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(mainOrangeColor),
                ),
                onPressed: () {
                  _pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
                child: Text(
                  "Camera",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: mainWhiteColor,
                  ),
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  //save user
  Future<void> _saveUser(BuildContext context) async {
    try {
      if (_imageFile != null) {
        final imageUrl = await UserStorage().uploadImageToCloudinary(
          _imageFile!,
        );
        _imageController.text = imageUrl!;
        print(_imageController.text);
      }
      final userCredential = await AuthService().createUserWithEmailAndPssword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final userId = userCredential.user?.uid;

      final user = UserModel(
        userId: userId!,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        teamName: _teamNameController.text.trim(),
        imageUrl: _imageController.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        password: _passwordController.text,
        followers: 0,
      );

      await UserService().saveUser(user);
    } catch (err) {
      print("User Saving UI error: $err");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Regiter Failed",
            style: TextStyle(fontSize: 14, color: Colors.red),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Close",
                style: TextStyle(fontSize: 12, color: mainWhiteColor),
              ),
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
                    Center(
                      child: Stack(
                        children: [
                          _imageFile != null
                              ? CircleAvatar(
                                  radius: 64,
                                  backgroundColor: mainPurpleColor,
                                  backgroundImage: FileImage(_imageFile!),
                                )
                              : const CircleAvatar(
                                  radius: 64,
                                  backgroundColor: mainPurpleColor,
                                  backgroundImage: NetworkImage(
                                    "https://i.stack.imgur.com/l60Hf.png",
                                  ),
                                ),
                          Positioned(
                            bottom: -10,
                            right: 0,
                            child: IconButton(
                              //todo:pick image
                              iconSize: 30,
                              onPressed: () async {
                                _selectSource(context);
                              },
                              icon: Icon(Icons.add_a_photo),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ReusableInput(
                      iconData: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your name!";
                        }
                        return null;
                      },
                      controller: _nameController,
                      labelText: "Name",
                      obscureText: false,
                    ),
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
                      iconData: Icons.group,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your team!";
                        }

                        return null;
                      },
                      controller: _teamNameController,
                      labelText: "Team",
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
                    ReusableInput(
                      iconData: Icons.lock,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email!";
                        }

                        if (value != _passwordController.text) {
                          return "Password do not match!";
                        }
                        return null;
                      },
                      controller: _confirmPasswordController,
                      labelText: "Confirm Password",
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    ReusableButton(
                      buttonText: "Sign Up",
                      width: double.infinity,
                      onPressed: () {
                        //todo:signup logic
                        _saveUser(context);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    (context).goNamed(RouteNames.login);
                  },
                  child: Text("Already have an account? Log in"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
