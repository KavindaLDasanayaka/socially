import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socially/models/user_model.dart';
import 'package:socially/router/route_names.dart';
import 'package:socially/services/auth/auth_service.dart';
import 'package:socially/services/feed/feed_service.dart';
import 'package:socially/services/users/user_service.dart';
import 'package:socially/utils/constants/app_constants.dart';
import 'package:socially/widgets/reusable/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserModel?> _userFuture;
  late Future<Map<String, int>> _userStatsFuture;
  bool _isLoading = true;
  bool _hasError = false;
  late String _currentUserId;
  late UserService _userService;
  late FeedService _feedService;

  @override
  void initState() {
    super.initState();
    _userService = UserService();
    _feedService = FeedService();
    _currentUserId = AuthService().getCurrentUser()?.uid ?? '';
    _userFuture = _fetchUserDetails();
    _userStatsFuture = _fetchUserStats();
  }

  Future<UserModel?> _fetchUserDetails() async {
    try {
      final userId = AuthService().getCurrentUser()?.uid ?? '';
      final user = await _userService.getUserById(userId);

      setState(() {
        _isLoading = false;
        if (user == null) {
          _hasError = true;
        }
      });
      return user;
    } catch (error) {
      print('Error fetching user details: $error');
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      return null;
    }
  }

  Future<Map<String, int>> _fetchUserStats() async {
    try {
      final userId = AuthService().getCurrentUser()?.uid ?? '';
      final postsCount = await _feedService.getUserPostsCount(userId);
      final followersCount = await _userService.getUserFollowersCount(userId);
      final followingCount = await _userService.getUserFollowingCount(userId);

      return {
        'posts': postsCount,
        'followers': followersCount,
        'following': followingCount,
      };
    } catch (error) {
      print('Error fetching user stats: $error');
      return {'posts': 0, 'followers': 0, 'following': 0};
    }
  }

  void _signOut(BuildContext context) async {
    await AuthService().signOut();
    (context).goNamed(RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.settings))],
      ),
      body: FutureBuilder<UserModel?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_hasError) {
            return const Center(child: Text('Error loading profile'));
          }
          final user = snapshot.data;

          if (user == null) {
            return const Center(child: Text('User not found'));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture
              CircleAvatar(
                radius: 50,
                backgroundImage: user.imageUrl.isNotEmpty
                    ? NetworkImage(user.imageUrl)
                    : const NetworkImage(profileImage) as ImageProvider,
              ),
              const SizedBox(height: 16),
              // User Name
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // User Bio
              Text(
                user.teamName,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Stats (Posts, Followers, Following)
              FutureBuilder<Map<String, int>>(
                future: _userStatsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading stats'));
                  }
                  final stats = snapshot.data;

                  if (stats == null) {
                    return const Center(child: Text('Stats not available'));
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatColumn('Posts', stats['posts'].toString()),
                      _buildStatColumn(
                        'Followers',
                        stats['followers'].toString(),
                      ),
                      _buildStatColumn(
                        'Following',
                        stats['following'].toString(),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              // Follow Button (conditional visibility)
              if (user.userId != _currentUserId)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: FutureBuilder<bool>(
                    future: _userService.isFollowing(
                      _currentUserId,
                      user.userId,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return const Text('Error checking follow status');
                      }
                      final isFollowing = snapshot.data ?? false;
                      return ReusableButton(
                        onPressed: () {
                          // TODO: Implement follow/unfollow functionality
                        },
                        width: MediaQuery.of(context).size.width,
                        buttonText: isFollowing ? 'Unfollow' : 'Follow',
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),
              // Logout Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ReusableButton(
                  onPressed: () => _signOut(context),
                  width: MediaQuery.of(context).size.width,
                  buttonText: 'Logout',
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Helper method to build stats column
  Widget _buildStatColumn(String title, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ],
      ),
    );
  }
}
