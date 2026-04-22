import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsLogoutButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color cardColor;

  const SettingsLogoutButton({
    super.key,
    required this.onTap,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24.r),
      child: Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout,
              color: const Color(0xFFD32F2F),
              size: 20.w,
            ),
            SizedBox(width: 8.w),
            const Text(
              "Akauntdan chiqish",
              style: TextStyle(
                color: Color(0xFFD32F2F),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
