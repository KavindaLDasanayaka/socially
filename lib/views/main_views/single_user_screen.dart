import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socially/models/user_model.dart';
import 'package:socially/services/feed/feed_service.dart';
import 'package:socially/services/users/user_service.dart';
import 'package:socially/utils/constants/app_constants.dart';
import 'package:socially/utils/constants/colors.dart';
import 'package:socially/utils/functions/functions.dart';
import 'package:socially/widgets/reusable/custom_button.dart';

class SingleUserScreen extends StatefulWidget {
  final UserModel user;
  const SingleUserScreen({super.key, required this.user});

  @override
  State<SingleUserScreen> createState() => _SingleUserScreenState();
}

class _SingleUserScreenState extends State<SingleUserScreen> {
  List<String> _userPosts = [];
  late Future<bool> _isFollowing;
  late String _currentUserId;

  Future<void> _getUserPosts() async {
    try {
      final List<String> userPosts = await FeedService().getAllUserPostImages(
        userId: widget.user.userId,
      );
      setState(() {
        _userPosts = userPosts;
      });
    } catch (err) {
      print("error gettig user posts ui: $err");
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserPosts();
    _currentUserId = FirebaseAuth.instance.currentUser!.uid;
    _isFollowing = UserService().isFollowing(
      _currentUserId,
      widget.user.userId,
    );
  }

  Future<void> _toggleFollow() async {
    try {
      final isFollowing = await _isFollowing;
      if (isFollowing) {
        //unfollow
        await UserService().unfollowUser(_currentUserId, widget.user.userId);
        setState(() {
          _isFollowing = Future.value(false);
        });
        UtilFunctions().showSnackBar(
          context: context,
          message: "User UnFollowed!",
        );
      } else {
        //folow
        await UserService().followUser(
          currentUserId: _currentUserId,
          userToFollowId: widget.user.userId,
        );
        setState(() {
          _isFollowing = Future.value(true);
        });
        UtilFunctions().showSnackBar(
          context: context,
          message: "User Followed!",
        );
      }
    } catch (err) {
      print("Error following ui:$err");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    maxRadius: 30,
                    foregroundImage: widget.user.imageUrl.isNotEmpty
                        ? NetworkImage(widget.user.imageUrl)
                        : NetworkImage(profileImage),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: mainWhiteColor,
                        ),
                      ),
                      Text(
                        widget.user.teamName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          // ignore: deprecated_member_use
                          color: mainWhiteColor.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (widget.user.userId != _currentUserId)
                FutureBuilder(
                  future: _isFollowing,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text("Error following"));
                    } else if (!snapshot.hasData) {
                      return Container();
                    }
                    final isFollowing = snapshot.data!;
                    return ReusableButton(
                      buttonText: isFollowing ? "Unfollow" : "Follow",
                      width: MediaQuery.of(context).size.width,
                      onPressed: () {
                        _toggleFollow();
                      },
                    );
                  },
                ),
              const SizedBox(height: 20),
              GridView.builder(
                scrollDirection: Axis.vertical,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  // childAspectRatio: 16 / 9,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                ),
                itemCount: _userPosts.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final String imageUrl = _userPosts[index];
                  return Image.network(imageUrl, width: 100);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
