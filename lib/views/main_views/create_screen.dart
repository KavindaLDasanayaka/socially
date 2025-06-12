import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:socially/models/post_model.dart';

import 'package:socially/services/feed/feed_service.dart';
import 'package:socially/services/feed/feed_storage.dart';
import 'package:socially/services/users/user_service.dart';
import 'package:socially/utils/constants/colors.dart';
import 'package:socially/utils/functions/functions.dart';
import 'package:socially/utils/functions/mood.dart';

import 'package:socially/widgets/reusable/custom_button.dart';
import 'package:socially/widgets/reusable/custom_input.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  File? _imageFile;

  Mood _selectedMood = Mood.happy;

  bool _isUploading = false;

  //pick the image
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  //save user
  Future<void> _saveUser() async {
    try {
      if (_imageFile != null) {
        setState(() {
          _isUploading = true;
        });
        final imageUrl = await FeedStorage().uploadImageToCloudinary(
          imageFile: _imageFile!,
        );
        _imageController.text = imageUrl!;
      }
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final userDetails = await UserService().getUserById(user.uid);

        if (userDetails != null) {
          final Post newPost = Post(
            postCaption: _captionController.text,
            mood: _selectedMood,
            userId: userDetails.userId,
            username: userDetails.name,
            likes: 0,
            postId: "",
            datePublished: DateTime.now(),
            postImage: _imageController.text,
            profImage: userDetails.imageUrl,
          );

          await FeedService().savePost(newPost);

          UtilFunctions().showSnackBar(
            context: context,
            message: "Post Published!",
          );
          _formKey.currentState!.reset();
        }
      }
    } catch (err) {
      print("Error create screen : $err");
      throw Exception(err);
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create post")),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 15),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableInput(
                  iconData: Icons.text_fields,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a caption";
                    }
                    return null;
                  },
                  controller: _captionController,
                  labelText: "Caption",
                  obscureText: false,
                ),
                const SizedBox(height: 20),
                DropdownButton<Mood>(
                  value: _selectedMood,
                  items: Mood.values.map((Mood mood) {
                    return DropdownMenuItem(
                      value: mood,
                      child: Text("${mood.name} ${mood.emoji}"),
                    );
                  }).toList(),
                  onChanged: (Mood? newMood) {
                    setState(() {
                      _selectedMood = newMood ?? _selectedMood;
                    });
                  },
                ),
                const SizedBox(height: 20),
                _imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: kIsWeb
                            ? Image.network(_imageFile!.path)
                            : Image.file(_imageFile!),
                      )
                    : Text(
                        "No Image Selected",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: mainWhiteColor,
                        ),
                      ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ReusableButton(
                      buttonText: "Use Camera",
                      width: MediaQuery.of(context).size.width * 0.43,
                      onPressed: () {
                        _pickImage(ImageSource.camera);
                      },
                    ),
                    ReusableButton(
                      buttonText: "Use Gallery",
                      width: MediaQuery.of(context).size.width * 0.43,
                      onPressed: () {
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ReusableButton(
                  buttonText: kIsWeb
                      ? "Not supported yet"
                      : _isUploading
                      ? "Uploading..."
                      : "Create Post",
                  width: double.infinity,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _saveUser();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
