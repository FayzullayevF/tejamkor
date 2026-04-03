import 'package:flutter/material.dart' hide Router;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tejamkor/auth/blocs/login/login_bloc.dart';
import 'package:tejamkor/auth/blocs/login/login_event.dart';
import 'package:tejamkor/auth/blocs/login/login_state.dart';
import 'package:tejamkor/core/routing/router.dart';
import 'package:tejamkor/core/utils/app_colors.dart';
import 'package:tejamkor/widgets/app_button.dart';
import 'auth_text_field.dart';
import 'show_error_dialog.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.onSuccess,
  });

  final VoidCallback onSuccess;

  @override
  Widget build(BuildContext context) {
    return _LoginFormBody(onSuccess: onSuccess);
  }
}

class _LoginFormBody extends StatefulWidget {
  const _LoginFormBody({
    required this.onSuccess,
  });

  final VoidCallback onSuccess;

  @override
  State<_LoginFormBody> createState() => _LoginFormBodyState();
}

class _LoginFormBodyState extends State<_LoginFormBody> {
  final _formKey = GlobalKey<FormState>();

  bool rememberMe = false;

  static const String kRemember = "remember_me";
  static const String kEmail = "saved_email";
  static const String kPassword = "saved_password";

  @override
  void initState() {
    super.initState();
    _loadSavedLogin();
  }

  Future<void> _loadSavedLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final savedRemember = prefs.getBool(kRemember) ?? false;

    if (!mounted) return;

    final bloc = context.read<LoginBloc>();

    setState(() {
      rememberMe = savedRemember;
    });

    if (savedRemember) {
      bloc.emailController.text = prefs.getString(kEmail) ?? '';
      bloc.passwordController.text = prefs.getString(kPassword) ?? '';
    }
  }

  Future<void> _saveOrClear() async {
    final prefs = await SharedPreferences.getInstance();
    final bloc = context.read<LoginBloc>();

    await prefs.setBool(kRemember, rememberMe);

    if (rememberMe) {
      await prefs.setString(kEmail, bloc.emailController.text.trim());
      await prefs.setString(kPassword, bloc.passwordController.text.trim());
    } else {
      await prefs.remove(kEmail);
      await prefs.remove(kPassword);
    }
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    await _saveOrClear();

    if (!mounted) return;
    context.read<LoginBloc>().add(LoginSubmitted());
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<LoginBloc>();

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login success")),
          );
          widget.onSuccess();
          context.go(Routers.categories);
        }

        if (state.status == LoginStatus.error) {
          showErrorDialog(context, state.errorMessage ?? "Login xatoligi");
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 20.h),
            AuthTextField(
              controller: bloc.emailController,
              type: AuthFieldType.email,
              labelText: "Email pochtangiz",
              hintText: "Misol uchun: user@gmail.com",
            ),
            SizedBox(height: 10.h),
            AuthTextField(
              controller: bloc.passwordController,
              type: AuthFieldType.password,
              labelText: "Parolingiz",
              hintText: "********",
              validatorOverride: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Parolni kiriting";
                }
                return null;
              },
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Checkbox(
                  shape: const CircleBorder(),
                  value: rememberMe,
                  onChanged: (v) async {
                    setState(() {
                      rememberMe = v ?? false;
                    });
                    await _saveOrClear();
                  },
                ),
                Text(
                  "Eslab qolish",
                  style: TextStyle(fontSize: 14.sp),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    context.push(Routers.forgotPassword);
                  },
                  child: Text(
                    "Parolni unutdingizmi?",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                      foreground: Paint()
                        ..shader = LinearGradient(
                          colors: [
                            AppColors.cyanAccent,
                            AppColors.darkNavy.withOpacity(0.5),
                          ],
                        ).createShader(
                          const Rect.fromLTWH(0, 0, 200, 70),
                        ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            AppButton(
              height: 73.h,
              weight: 380.w,
              title: "Tizimga kirish",
              voidCallback: _submit,
            ),
          ],
        ),
      ),
    );
  }
}