import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:socially/models/user_model.dart';
import 'package:socially/services/auth/auth_service.dart';

class UserService {
  final CollectionReference _userCollection = FirebaseFirestore.instance
      .collection("users");

  //save user method
  Future<void> saveUser(UserModel user) async {
    try {
      final userCredential = await AuthService().createUserWithEmailAndPssword(
        email: user.email,
        password: user.password,
      );
      // Retrieve the user ID from the created user
      final userId = userCredential.user?.uid;

      // final Map<String, dynamic> userData = user.toJson();
      // await _userCollection.add(userData);
      final DocumentReference docref = FirebaseFirestore.instance
          .collection("users")
          .doc(userId);

      final userMap = user.toJson();
      userMap['userId'] = userId;

      await docref.set(userMap);

      print("user saved successfuly with userId :$userId");
    } catch (err) {
      print("Error Creating user: $err");
      throw Exception("Error Creating User : $err");
    }
  }

  //get user details by id
  Future<UserModel?> getUserById(String userId) async {
    try {
      final data = await _userCollection.where(userId) as Map<String, dynamic>;
      print(data);
      final UserModel user = UserModel.fromJson(data);

      return user;
    } catch (error) {
      print('Error getting user: $error');
    }
    return null;
  }
}
