import 'package:flutter/material.dart';
import 'package:tejamkor/auth/widgets/auth_app_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AuthAppBar(),
      body: Center(
        child: Text(
          "Home Page ",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 36,
          ),
        ),
      ),
    );
  }
}
