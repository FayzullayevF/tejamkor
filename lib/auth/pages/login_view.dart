import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tejamkor/core/routing/router.dart';
import '../widgets/auth_panel.dart';
import '../widgets/login_form.dart';
import '../widgets/register_form.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool isLogin = true;

  void _submitLogin() {
    debugPrint("LOGIN SUBMIT");
  }

  void _submitRegister() {
    debugPrint("REGISTER SUBMIT");
  }

  void _goToLogin(){
    setState(() {
      isLogin = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthPanel(
        isLogin: isLogin,
        onChanged: (v) => setState(() => isLogin = v),
        child: isLogin
            ? LoginForm(
          key:  ValueKey('login'),
          onSuccess:(){
            context.go(Routers.home);
          },
        )
            : RegisterForm(
          key:  ValueKey('register'),
          onSubmit: _submitRegister,
          onSuccess: _goToLogin,
        ),
      ),
    );
  }
}
