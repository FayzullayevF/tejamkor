import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tejamkor/core/routing/router.dart';
import 'package:tejamkor/core/secure_storage.dart';

class HomeHeader extends StatelessWidget {
  final String greeting;
  const HomeHeader({super.key, required this.greeting});

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
          greeting,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w400,
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
