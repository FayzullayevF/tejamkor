import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tejamkor/core/routing/router.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.15),
          radius: 20.r,
          child: GestureDetector(
            onTap: () {
              context.push(Routers.settings);
            },
            child: Icon(
              Icons.settings_outlined,
              color: Colors.white,
              size: 20.w,
            ),
          ),
        ),
        Text(
          "Hayrli kun, Daler",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.15),
          radius: 20.r,
          child: Icon(
            Icons.notifications_none_outlined,
            color: Colors.white,
            size: 20.w,
          ),
        ),
      ],
    );
  }
}
