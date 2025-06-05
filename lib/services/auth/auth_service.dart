import 'package:firebase_auth/firebase_auth.dart';
import 'package:socially/services/exceptions/exceptions.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user with email and password
  //This methode will create a new user with email and password and return the user credential

  Future<UserCredential> createUserWithEmailAndPssword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    } on FirebaseAuthException catch (err) {
      throw Exception(mapFirebaseAuthExceptionCode(err.code));
    } catch (err) {
      print("Error Creating user: $err");
      throw Exception("Error Creating User : $err");
    }
  }

  //sign out function
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (err) {
      throw Exception(mapFirebaseAuthExceptionCode(err.code));
    } catch (err) {
      print("Error sign out user: $err");
      throw Exception("Error sing out User : $err");
    }
  }

  //get user details
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
