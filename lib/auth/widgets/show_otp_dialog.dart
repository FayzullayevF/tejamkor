import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tejamkor/auth/blocs/forgot_password/forgot_password_bloc.dart';
import 'package:tejamkor/auth/blocs/forgot_password/forgot_password_event.dart';
import 'package:tejamkor/auth/blocs/forgot_password/forgot_password_state.dart';
import 'package:tejamkor/core/routing/router.dart';

Future<String?> showOtpDialog({
  required BuildContext context,
  required String email,
  required ForgotPasswordBloc bloc,
}) async {
  final result = await showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (_) => BlocProvider.value(
      value: bloc,
      child: OtpVerifyDialog(email: email),
    ),
  );
  return result;
}

class OtpVerifyDialog extends StatefulWidget {
  const OtpVerifyDialog({super.key, required this.email});

  final String email;

  @override
  State<OtpVerifyDialog> createState() => _OtpVerifyDialogState();
}

class _OtpVerifyDialogState extends State<OtpVerifyDialog> {
  static const int _otpLen = 6;

  late List<TextEditingController> ctrl;
  late List<FocusNode> nodes;

  Timer? _timer;
  int _secondsLeft = 300;

  String? _currentOtp;

  @override
  void initState() {
    super.initState();
    ctrl = List.generate(_otpLen, (_) => TextEditingController());
    nodes = List.generate(_otpLen, (_) => FocusNode());
    _generateAndStart();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in ctrl) c.dispose();
    for (final n in nodes) n.dispose();
    super.dispose();
  }

  void _generateAndStart() {
    _timer?.cancel();
    _secondsLeft = 60;

    for (final c in ctrl) c.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) nodes.first.requestFocus();
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        _secondsLeft--;
        if (_secondsLeft <= 0) {
          _secondsLeft = 0;
          t.cancel();
        }
      });
    });

    setState(() {});
  }

  String get _enteredOtp => ctrl.map((e) => e.text.trim()).join();

  bool get _expired => _secondsLeft == 0;

  void _onChanged(int i, String v) {
    if (v.length > 1) {
      ctrl[i].text = v.characters.last;
      ctrl[i].selection = TextSelection.fromPosition(
        TextPosition(offset: ctrl[i].text.length),
      );
    }

    if (v.isNotEmpty) {
      if (i < _otpLen - 1) {
        nodes[i + 1].requestFocus();
      } else {
        FocusScope.of(context).unfocus();
      }
    }
  }

  void _onBackspace(int i, RawKeyEvent e) {
    if (e is! RawKeyDownEvent) return;
    if (e.logicalKey.keyLabel == 'Backspace') {
      if (ctrl[i].text.isEmpty && i > 0) {
        nodes[i - 1].requestFocus();
        ctrl[i - 1].clear();
      }
    }
  }

  void _confirm() {
    if (_expired) {
      _snack("Kod eskirdi. Qayta yuboring.");
      return;
    }
    if (_enteredOtp.length != _otpLen ||
        _enteredOtp.contains(RegExp(r'[^0-9]'))) {
      _snack("Kodni to‘liq kiriting.");
      return;
    }
    final bloc = context.read<ForgotPasswordBloc>();
    bloc.add(
      ForgotPasswordVerifyEvent(
        verifyToken: bloc.state.verifyToken!,
        code: _enteredOtp,
      ),
    );
    context.go(Routers.enterPassword);
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state.status == ForgotPasswordStatus.verified) {
          Navigator.of(context).pop();
          context.go(Routers.login);
        }
        if (state.status == ForgotPasswordStatus.error) {
          _snack(state.error ?? "Xatolik");
        }
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 18.w),
        child: Container(
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(width: 3, color: const Color(0xFF24B7C8)),
            boxShadow: [
              BoxShadow(
                blurRadius: 30,
                offset: const Offset(0, 18),
                color: Colors.black.withOpacity(0.25),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64.w,
                height: 64.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFF2F3F5),
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/otp.svg',
                      height: 103,
                      width: 103,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      right: 12.w,
                      top: 12.w,
                      child: Container(
                        width: 18.w,
                        height: 18.w,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2ECC71),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          size: 12.w,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "Akauntingizni tasdiqlang",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                "Emailingizga $_otpLen raqamli kod yubordik:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFAAA9A9),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4.h),
              Text(
                widget.email,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 14.h),
              LayoutBuilder(
                builder: (context, c) {
                  const double gap = 10;
                  final maxW = c.maxWidth;
                  final boxSize = ((maxW - (_otpLen - 1) * gap) / _otpLen)
                      .clamp(38.0, 52.0);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_otpLen, (i) {
                      return Padding(
                        padding: EdgeInsets.only(
                          right: i == _otpLen - 1 ? 0 : gap,
                        ),
                        child: SizedBox(
                          width: boxSize,
                          height: boxSize,
                          child: RawKeyboardListener(
                            focusNode: FocusNode(),
                            onKey: (e) => _onBackspace(i, e),
                            child: TextField(
                              controller: ctrl[i],
                              focusNode: nodes[i],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w800,
                              ),
                              decoration: InputDecoration(
                                counterText: "",
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.zero,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE0E5EB),
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF24B7C8),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              onChanged: (v) => _onChanged(i, v),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),

              SizedBox(height: 12.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _expired
                        ? "Kod eskirdi"
                        : "00:${_secondsLeft.toString().padLeft(2, '0')}",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: _expired ? Colors.red : const Color(0xFF97A0AA),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  TextButton(
                    onPressed: _expired ? () {
                      final bloc = context.read<ForgotPasswordBloc>();
                      bloc.add(ForgotPasswordRequestEvent(widget.email));
                      // _generateAndStart();
                    }: null,
                    child: Text(
                      "Qayta yuborish",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF24B7C8),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10.h),

              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFF24B7C8), Color(0xFF1A2433)],
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: _confirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    child: Text(
                      "Tasdiqlang",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 6.h),

              TextButton(
                onPressed: () {
                  Future.microtask(() => context.pop());
                },
                child: Text(
                  "Bekor qilish",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF97A0AA),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
