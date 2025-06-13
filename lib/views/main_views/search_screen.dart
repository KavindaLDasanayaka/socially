import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socially/models/user_model.dart';
import 'package:socially/router/route_names.dart';
import 'package:socially/services/users/user_service.dart';
import 'package:socially/utils/constants/app_constants.dart';
import 'package:socially/utils/constants/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<UserModel> _users = [];
  List<UserModel> _filteredUsers = [];

  Future<void> _fetchAllUsers() async {
    try {
      final List<UserModel> users = await UserService().getAllUsers();
      setState(() {
        _users = users;
        _filteredUsers = users;
      });
    } catch (err) {
      print("Error fetching users : $err");
    }
  }

  void _filterUsers(String query) {
    setState(() {
      _filteredUsers = _users
          .where(
            (user) => user.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
      borderRadius: BorderRadius.circular(8),
    );

    return Scaffold(
      appBar: AppBar(title: Text("Search users")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                filled: true,
                border: inputBorder,
                focusedBorder: inputBorder,
                enabledBorder: inputBorder,
                prefixIcon: const Icon(
                  Icons.search,
                  color: mainWhiteColor,
                  size: 20,
                ),
              ),
              onChanged: _filterUsers,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredUsers.length,
                itemBuilder: (context, index) {
                  final UserModel user = _users[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: user.imageUrl.isNotEmpty
                          ? NetworkImage(user.imageUrl)
                          : const AssetImage(profileImage) as ImageProvider,
                    ),
                    title: Text(user.name),
                    subtitle: Text(user.teamName),
                    onTap: () {
                      (context).pushNamed(RouteNames.sinlgeUser, extra: user);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
