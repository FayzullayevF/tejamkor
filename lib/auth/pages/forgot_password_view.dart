import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tejamkor/auth/blocs/forgot_password/forgot_password_bloc.dart';
import 'package:tejamkor/auth/blocs/forgot_password/forgot_password_event.dart';
import 'package:tejamkor/auth/blocs/forgot_password/forgot_password_state.dart';
import 'package:tejamkor/auth/widgets/auth_app_bar.dart';
import 'package:tejamkor/auth/widgets/auth_text_field.dart';
import 'package:tejamkor/auth/widgets/show_otp_dialog.dart';
import 'package:tejamkor/core/routing/router.dart';
import 'package:tejamkor/widgets/app_button.dart';

import '../../core/utils/app_colors.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final emailCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ForgotPasswordBloc>();
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) async {
        if (state.status == ForgotPasswordStatus.codeSent) {
          await showOtpDialog(
            context: context,
            email: bloc.emailController.text.trim(),
            bloc: bloc
          );
        }
        if (state.status == ForgotPasswordStatus.verified) {
          context.push(Routers.enterPassword, extra: state.resetToken);
        }
        if (state.status == ForgotPasswordStatus.error) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Xatolik yuz berdi")));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration:  BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.cyanAccent,
                    AppColors.darkNavy,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.65,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.white,
                      Colors.white,
                    ],
                    stops: [0.0, 0.3, 1.0],
                  ),
                ),
              ),
            ),
            AuthAppBar(),
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 52.h),
                      SizedBox(
                        width: 350.w,
                        child: const Text(
                          "Parolingizni\nunutgan bo‘lsangiz\nushbu maydonga e-mail pochtangizni kiriting!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            height: 1.02,
                          ),
                        ),
                      ),
                      SizedBox(height: 17.h),
                      const Text(
                        "Pullaringizni biz orqali tejang!",
                        style: TextStyle(
                          color: Color(0xffDCDCDC),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 80.h),
                      const Center(
                        child: Text(
                          "Kodni olish",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0B1E29),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      AuthTextField(
                        controller: bloc.emailController,
                        type: AuthFieldType.email,
                        labelText: "Email pochtangiz",
                      ),
                      SizedBox(height: 20.h),
                      AppButton(
                        height: 72.h,
                        weight: 380.w,
                        title: "Kodni yuborish",
                        voidCallback: () {
                          final email = bloc.emailController.text.trim();
                          if (email.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Email kiriting")),
                            );
                            return;
                          }
                          context.read<ForgotPasswordBloc>().add(
                            ForgotPasswordRequestEvent(email),
                          );
                        },
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
