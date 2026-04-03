import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tejamkor/core/routing/router.dart';

class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AuthAppBar({
    super.key,
    this.voidCallback,
    this.route,
    this.isPush = false,
    this.backArrowColor = Colors.white,
  });

  final VoidCallback? voidCallback;
  final String? route;
  final bool isPush;
  final Color backArrowColor;

  static const backArrow =
      ''' <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M3 12L8 17M3 12L8 7M3 12H21" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  @override
  Size get preferredSize => Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 60,
      // toolbarHeight: 56,
      leading: Padding(
        padding: EdgeInsets.only(left: 12.w),
        child: Center(
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () {
              if (voidCallback != null) {
                voidCallback!();
              } else if (route != null) {
                if (isPush) {
                  context.push(route!);
                } else {
                  context.go(route!);
                }
              } else {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(Routers.login);
                }
              }
            },
            child: Container(
              height: 24.h,
              width: 24.w,
              alignment: Alignment.center,
              child: SvgPicture.asset(
                "assets/icons/back-arrow.svg",
                color: backArrowColor,
                height: 18.h,
                width: 18.w,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
