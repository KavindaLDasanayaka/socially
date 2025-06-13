import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socially/models/user_model.dart';
import 'package:socially/router/route_names.dart';
import 'package:socially/views/auth_views/login.dart';

import 'package:socially/views/auth_views/register.dart';
import 'package:socially/views/main_screen.dart';
import 'package:socially/views/main_views/home_page.dart';
import 'package:socially/views/main_views/single_user_screen.dart';
import 'package:socially/views/responsive/mobile_layout.dart';
import 'package:socially/views/responsive/responsive_layout.dart';
import 'package:socially/views/responsive/web_layout.dart';

class RouterClass {
  final router = GoRouter(
    initialLocation: "/",
    errorPageBuilder: (context, state) {
      return MaterialPage(
        child: Scaffold(
          body: Column(
            children: [
              Center(child: Text("This Page Is Not Found")),
              ElevatedButton(
                onPressed: () {
                  (context).goNamed(RouteNames.mainPage);
                },
                child: Text("Go to Home"),
              ),
            ],
          ),
        ),
      );
    },
    routes: [
      GoRoute(
        path: "/",
        name: RouteNames.mainPage,
        builder: (context, state) {
          return ResponsiveLayoutScreen(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          );
        },
      ),

      GoRoute(
        path: "/register",
        name: RouteNames.register,
        builder: (context, state) {
          return RegisterScreen();
        },
      ),
      GoRoute(
        path: "/login",
        name: RouteNames.login,
        builder: (context, state) {
          return LoginPage();
        },
      ),
      GoRoute(
        path: "/home",
        name: RouteNames.homepage,
        builder: (context, state) {
          return HomePage();
        },
      ),
      GoRoute(
        path: "/mainScreen",
        name: RouteNames.mainScreen,
        builder: (context, state) {
          return MainScreen();
        },
      ),
      GoRoute(
        path: "/singleUser",
        name: RouteNames.sinlgeUser,
        builder: (context, state) {
          final UserModel user = state.extra as UserModel;
          return SingleUserScreen(user: user);
        },
      ),
    ],
  );
}
