import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeBalance extends StatelessWidget {
  const HomeBalance({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Umumiy hisob",
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          "23 000 000 UZS",
          style: TextStyle(
            color: Colors.white,
            fontSize: 32.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
