import 'package:flutter/material.dart' hide Router;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tejamkor/auth/blocs/sign_up/sign_up_bloc.dart';
import 'package:tejamkor/auth/blocs/sign_up/sign_up_event.dart';
import 'package:tejamkor/auth/blocs/sign_up/sign_up_state.dart';
import '../../widgets/app_button.dart';
import 'auth_text_field.dart';
import 'show_error_dialog.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    super.key,
    required this.onSubmit,
    required this.onSuccess,
  });

  final VoidCallback onSubmit;
  final VoidCallback onSuccess;

  @override
  Widget build(BuildContext context) {
    return _RegisterFormBody(onSubmit: onSubmit, onSuccess: onSuccess);
  }
}

class _RegisterFormBody extends StatefulWidget {
  const _RegisterFormBody({required this.onSubmit, required this.onSuccess});

  final VoidCallback onSubmit;
  final VoidCallback onSuccess;

  @override
  State<_RegisterFormBody> createState() => _RegisterFormBodyState();
}

class _RegisterFormBodyState extends State<_RegisterFormBody> {
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    debugPrint("submit bosildi");

    final isValid = _formKey.currentState!.validate();
    debugPrint("form valid: $isValid");

    if (isValid) {
      final bloc = context.read<SignUpBloc>();

      debugPrint("password: ${bloc.passwordController.text}");
      debugPrint("confirm: ${bloc.passwordConfirmController.text}");

      if (bloc.passwordController.text.trim() !=
          bloc.passwordConfirmController.text.trim()) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Parollar mos emas")));
        return;
      }

      debugPrint("event yuborildi");
      bloc.add(SignUpSubmitted());
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SignUpBloc>();

    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state.status == SignUpStatus.success) {
          widget.onSuccess();
        }

        if (state.status == SignUpStatus.error) {
          showErrorDialog(context, state.errorMessage ?? "Xatolik yuz berdi");
        }
      },
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.h),
              AuthTextField(
                controller: bloc.fullNameController,
                type: AuthFieldType.name,
                labelText: "To'liq ismingiz",
              ),
              SizedBox(height: 15.h),
              AuthTextField(
                controller: bloc.emailController,
                type: AuthFieldType.email,
                labelText: "Email pochtangiz yoki telefon raqamingiz",
              ),

              SizedBox(height: 15.h),
              AuthTextField(
                controller: bloc.passwordController,
                type: AuthFieldType.password,
                labelText: "Parol",
                hintText: "Kamida 8 ta belgi",
              ),
              SizedBox(height: 15.h),
              AuthTextField(
                controller: bloc.passwordConfirmController,
                type: AuthFieldType.password,
                labelText: "Parolingizni tasdiqlang",
                hintText: "Parolni qayta kiriting",
                svgAsset: "assets/icons/circle_arrow.svg",
                validatorOverride: (value) {
                  if (value == null || value.isEmpty) {
                    return "Parolni tasdiqlash uchun qayta kiriting";
                  }
                  if (value != bloc.passwordController.text) {
                    return "Parollar mos emas";
                  }
                  return null;
                },
              ),
              SizedBox(height: 30.h),
              AppButton(
                height: 73.h,
                weight: 380.w,
                title: "Ro'yxatdan o'tish",
                voidCallback: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
