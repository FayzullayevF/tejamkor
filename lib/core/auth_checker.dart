import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tejamkor/auth/pages/login_view.dart';
import 'package:tejamkor/home/pages/home_view.dart';


class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {

  Future<bool> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("token");

    return token != null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkLogin(),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.data == true) {
          return const HomeView();
        }

        return const LoginView();
      },
    );
  }
}