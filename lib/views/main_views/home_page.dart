import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socially/models/post_model.dart';
import 'package:socially/services/feed/feed_service.dart';
import 'package:socially/widgets/main/feed/post.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.only(right: 20),
        title: Image.asset(
          "assets/logo.png",
          width: MediaQuery.of(context).size.width * 0.4,
        ),
      ),
      body: StreamBuilder(
        stream: FeedService().getPostStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Failed to fetch posts"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No post available"));
          }

          final List<Post> posts = snapshot.data!;

          posts.sort((a, b) => b.datePublished.compareTo(a.datePublished));

          return ListView.builder(
            itemCount: posts.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final Post post = posts[index];
              return Padding(
                padding: const EdgeInsets.all(20),
                child: PostWidget(
                  post: post,
                  currentUserId: FirebaseAuth.instance.currentUser!.uid,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
