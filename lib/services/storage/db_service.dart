import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save image URL under user's Firestore document
  Future<void> saveImageUrl(String imageUrl) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    final docRef = _firestore.collection('users').doc(user.uid);

    await docRef.set({
      'imageUrl': FieldValue.arrayUnion([imageUrl]),
    }, SetOptions(merge: true));
  }
}
