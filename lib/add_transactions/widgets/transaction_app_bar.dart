import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransactionAppBar extends StatelessWidget {
  final Color textColor;
  final VoidCallback onBack;

  const TransactionAppBar({
    super.key,
    required this.textColor,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onBack,
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: textColor,
            size: 20.w,
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          "Tranzaksiya qo'shish",
          style: TextStyle(
            color: textColor,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
