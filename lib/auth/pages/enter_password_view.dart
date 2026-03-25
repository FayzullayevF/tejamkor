import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tejamkor/auth/blocs/forgot_password/forgot_password_bloc.dart';
import 'package:tejamkor/auth/blocs/forgot_password/forgot_password_event.dart';
import 'package:tejamkor/auth/blocs/forgot_password/forgot_password_state.dart';

import '../../core/utils/app_colors.dart';
import '../../widgets/app_button.dart';
import '../widgets/auth_app_bar.dart';
import '../widgets/auth_text_field.dart';

class EnterPasswordView extends StatelessWidget {
  EnterPasswordView({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ForgotPasswordBloc>();
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state.status == ForgotPasswordStatus.codeSent) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Password changed")));
        }
        if (state.status == ForgotPasswordStatus.error) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Password changed error")));
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.cyanAccent, AppColors.darkNavy],
                  begin: Alignment.topLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.68,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.white, Colors.white],
                    stops: [0.0, 0.2, 1.0],
                  ),
                ),
              ),
            ),
            AuthAppBar(),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 52.h),
                    SizedBox(
                      width: 350.w,
                      height: 185.h,
                      child: Text(
                        "Parolingizni\nunutgansiz\ntiklash uchun yangi\nparol kiriting!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          height: 1.02,
                        ),
                      ),
                    ),
                    SizedBox(height: 17.h),
                    Text(
                      "Pullaringizni biz orqali tejang!",
                      style: TextStyle(
                        color: Color(0xffDCDCDC),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 62.h),
                    Center(
                      child: Text(
                        "Parolni kiriting",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0B1E29),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    AuthTextField(
                      controller: bloc.newPasswordController,
                      type: AuthFieldType.email,
                      labelText: "Parol",
                    ),
                    SizedBox(height: 15.h),
                    AuthTextField(
                      controller: bloc.confirmPasswordController,
                      type: AuthFieldType.email,
                      labelText: "Parolingizni takrorlang",
                    ),
                    SizedBox(height: 14.h),
                    AppButton(
                      height: 72.h,
                      weight: 380.w,
                      title: "Tizimga kirish",
                      voidCallback: () {
                        // context.read<ForgotPasswordBloc>().add(
                        //   ForgotPasswordRequestEvent(email),
                        // );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
