import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socially/models/post_model.dart';

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
}
