import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:socially/models/post_model.dart';
import 'package:socially/services/feed/feed_storage.dart';

class FeedService {
  //collection reference
  final CollectionReference _feedsCollection = FirebaseFirestore.instance
      .collection("feeds");

  //save the post in the firestore database
  Future<void> savePost(Post post) async {
    try {
      //check if the post has an image

      //add the post too the collection

      final DocumentReference docref = await _feedsCollection.add(
        post.toJson(),
      );

      final postId = docref.id;

      final feedMap = post.toJson();
      feedMap['postId'] = postId;

      await docref.set(feedMap);

      print("Post saved succcessfully!");
      // await docref.update({"postId": docref.id});
    } catch (err) {
      print("Saving post error : $err");
    }
  }

  Stream<List<Post>> getPostStream() {
    return _feedsCollection.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList(),
    );
  }

  //create a method to like a post
  Future<void> likePost({
    required String postId,
    required String userId,
  }) async {
    try {
      final DocumentReference postLikesRef = _feedsCollection
          .doc(postId)
          .collection("likes")
          .doc(userId);

      //add a document to the likes subcollection
      await postLikesRef.set({"LikedAt": Timestamp.now()});

      //update the post like count in the post document
      final DocumentSnapshot postDoc = await _feedsCollection.doc(postId).get();

      final Post post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

      final int newLikes = post.likes + 1;

      //update
      await _feedsCollection.doc(postId).update({"likes": newLikes});

      print("Post Liked Successfully");
    } catch (err) {
      print("Liking service error : $err");
    }
  }

  //deslike post
  Future<void> disLikePost({
    required String postId,
    required String userId,
  }) async {
    try {
      final DocumentReference postLikesRef = _feedsCollection
          .doc(postId)
          .collection("likes")
          .doc(userId);

      //delete a document to the likes subcollection
      await postLikesRef.delete();

      //update the post like count in the post document
      final DocumentSnapshot postDoc = await _feedsCollection.doc(postId).get();

      final Post post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

      final int newLikes = post.likes - 1;

      //update
      await _feedsCollection.doc(postId).update({"likes": newLikes});
      print("Post DisLiked Successfully");
    } catch (err) {
      print("Liking service error : $err");
    }
  }

  //check if a user has liked a post
  Future<bool> hasUserLikedPost({
    required String postId,
    required String userId,
  }) async {
    try {
      final DocumentReference postLikeRef = _feedsCollection
          .doc(postId)
          .collection("likes")
          .doc(userId);

      final DocumentSnapshot doc = await postLikeRef.get();
      return doc.exists;
    } catch (err) {
      print("Error checking if user liked post : $err");
      return false;
    }
  }

  //delete feed
  // Delete a post from the Firestore database
  Future<void> deletePost({
    required String postId,

    required String publicId,
  }) async {
    try {
      await _feedsCollection.doc(postId).delete();
      await FeedStorage().destroyCloudinaryImage(publicId);
      print("Post deleted successfully");
    } catch (error) {
      print('Error deleting post: $error');
    }
  }

  //get all post images from user
  Future<List<String>> getAllUserPostImages({required String userId}) async {
    try {
      final userPosts = await _feedsCollection
          .where("userId", isEqualTo: userId)
          .get()
          .then((snapshot) {
            return snapshot.docs.map((doc) {
              return Post.fromJson(doc.data() as Map<String, dynamic>);
            }).toList();
          });
      return userPosts.map((post) => post.postImage).toList();
    } catch (err) {
      print("Error getting user all images: $err");
      return [];
    }
  }
}
