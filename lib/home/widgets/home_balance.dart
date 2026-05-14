import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeBalance extends StatelessWidget {
  final double balance;
  final String currency;
  const HomeBalance({super.key, required this.balance, required this.currency});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Umumiy hisob",
          style: TextStyle(
            color: Colors.white.withOpacity( 0.8),
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          "${balance.toStringAsFixed(0)} $currency",
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
