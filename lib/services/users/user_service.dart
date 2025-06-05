import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socially/models/user_model.dart';

class UserService {
  final CollectionReference _userCollection = FirebaseFirestore.instance
      .collection("users");

  //save user method
  Future<void> saveUser(UserModel user) async {
    try {
      // Retrieve the user ID from the created user
      final userId = user.userId;

      final Map<String, dynamic> userData = user.toJson();
      await _userCollection.add(userData);

      print("user saved successfuly with userId :$userId");
    } catch (err) {
      print("Error Creating user: $err");
      throw Exception("Error Creating User : $err");
    }
  }
}
