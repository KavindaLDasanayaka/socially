import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:socially/models/user_model.dart';
import 'package:socially/services/auth/auth_service.dart';

class UserService {
  final CollectionReference _userCollection = FirebaseFirestore.instance
      .collection("users");

  //save user method
  Future<void> saveUser(UserModel user, String password) async {
    try {
      final userCredential = await AuthService().createUserWithEmailAndPssword(
        email: user.email,
        password: password,
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
      final doc = await _userCollection.doc(userId).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
    } catch (error) {
      print('Error getting user: $error');
    }
    return null;
  }

  //get all users
  Future<List<UserModel>> getAllUsers() async {
    try {
      final QuerySnapshot snapshot = await _userCollection.get();

      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (err) {
      print("Error getting users");
      return [];
    }
  }

  //method to folloe user and upddate thhe user following count
  Future<void> followUser({
    required String currentUserId,
    required String userToFollowId,
  }) async {
    try {
      //add the user to the follower
      await _userCollection
          .doc(userToFollowId)
          .collection("followers")
          .doc(currentUserId)
          .set({"FollowedAt": Timestamp.now()});

      // Update follower count for the followed user
      final followedUserRef = _userCollection.doc(userToFollowId);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final followedUserDoc = await transaction.get(followedUserRef);
        if (followedUserDoc.exists) {
          final data = followedUserDoc.data() as Map<String, dynamic>;
          final currentCount = data['followersCount'] ?? 0;
          transaction.update(followedUserRef, {
            'followersCount': currentCount + 1,
          });
        }
      });

      // Update following count for the current user
      final currentUserRef = _userCollection.doc(currentUserId);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final currentUserDoc = await transaction.get(currentUserRef);
        if (currentUserDoc.exists) {
          final data = currentUserDoc.data() as Map<String, dynamic>;
          final currentCount = data['followingCount'] ?? 0;
          transaction.update(currentUserRef, {
            'followingCount': currentCount + 1,
          });
        }
      });

      print('User followed successfully');
    } catch (err) {
      print("Error following user:$err");
    }
  }

  //methode to unfollow user and update the user followers count

  //LOGIC EXPLANATION

  // 1. Remove the current user from the followers collection of the user to unfollow
  // 2. Update the followers count for the user to unfollow
  // 3. Update the following count for the current user

  Future<void> unfollowUser(
    String currentUserId,
    String userToUnfollowId,
  ) async {
    try {
      // Remove the user from the followers collection
      await _userCollection
          .doc(userToUnfollowId)
          .collection('followers')
          .doc(currentUserId)
          .delete();

      // Update follower count for the unfollowed user
      final unfollowedUserRef = _userCollection.doc(userToUnfollowId);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final unfollowedUserDoc = await transaction.get(unfollowedUserRef);
        if (unfollowedUserDoc.exists) {
          final data = unfollowedUserDoc.data() as Map<String, dynamic>;
          final currentCount = data['followersCount'] ?? 0;
          transaction.update(unfollowedUserRef, {
            'followersCount': currentCount > 0 ? currentCount - 1 : 0,
          });
        }
      });

      // Update following count for the current user
      final currentUserRef = _userCollection.doc(currentUserId);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final currentUserDoc = await transaction.get(currentUserRef);
        if (currentUserDoc.exists) {
          final data = currentUserDoc.data() as Map<String, dynamic>;
          final currentCount = data['followingCount'] ?? 0;
          transaction.update(currentUserRef, {
            'followingCount': currentCount > 0 ? currentCount - 1 : 0,
          });
        }
      });

      print('User unfollowed successfully');
    } catch (error) {
      print('Error unfollowing user: $error');
    }
  }

  //Method to check if the current user is following another user
  Future<bool> isFollowing(String currentUserId, String userToCheckId) async {
    try {
      final docSnapshot = await _userCollection
          .doc(userToCheckId)
          .collection('followers')
          .doc(currentUserId)
          .get();

      return docSnapshot
          .exists; // Returns true if the document exists, meaning the user is following
    } catch (error) {
      print('Error checking follow status: $error');
      return false; // Return false if there's an error
    }
  }

  // Get the count of followers for a user
  // Get the count of followers for a user
  Future<int> getUserFollowersCount(String userId) async {
    try {
      final doc = await _userCollection.doc(userId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['followersCount'] ?? 0;
      }
      return 0; // Return 0 if the document doesn't exist
    } catch (error) {
      print('Error getting user followers count: $error');
      return 0;
    }
  }

  // Get the count of users the current user is following
  // Get the count of users the current user is following
  Future<int> getUserFollowingCount(String userId) async {
    try {
      final doc = await _userCollection.doc(userId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['followingCount'] ?? 0;
      }
      return 0; // Return 0 if the document doesn't exist
    } catch (error) {
      print('Error getting user following count: $error');
      return 0;
    }
  }
}
