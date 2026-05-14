import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IncomePlaceholder extends StatelessWidget {
  const IncomePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 480.h,
      margin: EdgeInsets.symmetric(vertical: 32.h),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity( 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance_wallet_outlined, size: 64.w, color: const Color(0xFFEEEEEE)),
            SizedBox(height: 16.h),
            Text(
              "Daromad bo'limi\ntayyorlanmoqda...",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFFBDBDBD),
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
