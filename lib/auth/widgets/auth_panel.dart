import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tejamkor/auth/widgets/auth_app_bar.dart';
import 'package:tejamkor/core/utils/app_colors.dart';
import 'auth_segmented.dart';

class AuthPanel extends StatelessWidget {
  final bool isLogin;
  final ValueChanged<bool> onChanged;
  final Widget child;

  const AuthPanel({
    super.key,
    required this.isLogin,
    required this.onChanged,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
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
        AuthAppBar(),

        SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(18.w, 55.h, 18.w, 0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isLogin
                        ? "Tizimga kirish\nuchun email pochta\nva parolingizni\nkiritishingiz lozim!"
                        : "Ro‘yxatdan o‘tish!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0,
                      height: 1
                    ),
                  ),
                  if(isLogin)...[
                    SizedBox(height: 15.h),
                    Text(
                      "Pullaringizni biz orqali tejang!",
                      style: TextStyle(
                        color: Color(0xffDCDCDC),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,

                      ),
                    ),
                  ]
                ],
              ),

            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Transform.translate(
            offset: Offset(0, isLogin ? 30 : 0),
            child: FractionallySizedBox(
              heightFactor: 0.75,
              widthFactor: 1,
              child: Container(
                padding:  EdgeInsets.all(18),
                decoration:  BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
                ),
                child: Column(
                  children: [
                    AuthSegmented(isLogin: isLogin, onChanged: onChanged),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration:  Duration(milliseconds: 160),
                        child: child,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

      ],
    );
  }
}
