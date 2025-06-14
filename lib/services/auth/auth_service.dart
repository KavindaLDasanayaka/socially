import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:socially/models/user_model.dart';
import 'package:socially/services/exceptions/exceptions.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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

  //sign in with email and password
  //This methode will sign in the user with email and password
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      print("user sign in successfully");
    } on FirebaseAuthException catch (err) {
      throw Exception(mapFirebaseAuthExceptionCode(err.code));
    } catch (err) {
      print("Login Failed service error : $err");
    }
  }

  //sign i with google
  Future<void> signInWithGoogle() async {
    try {
      //trigger the google sin in prcess
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }

      //obtain the googlesignInauthentication
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      //cerate a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      //sign into firebase with the google auth credentials

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      //firebase eken ena user
      final user = userCredential.user;

      if (user != null) {
        final UserModel newUser = UserModel(
          userId: user.uid,
          name: user.displayName ?? "No name",
          email: user.email ?? "No email",
          teamName: "teamName",
          imageUrl: user.photoURL ?? "",
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          // password: "",
          followers: 0,
        );

        //save in firestore
        final DocumentReference docref = FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid);
        await docref.set(newUser.toJson());

        print("User data saved in firestore under google sign in");
      }
    } on FirebaseAuthException catch (err) {
      throw Exception(mapFirebaseAuthExceptionCode(err.code));
    } catch (err) {
      print("login failed with google $err");
      throw Exception("Login Failed");
    }
  }
}
