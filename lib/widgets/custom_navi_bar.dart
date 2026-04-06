import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tejamkor/core/routing/router.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Positioned(
      bottom: 36.h,
      left: 27.w,
      right: 27.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 68.h,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(35.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(context, 0, 'assets/icons/house.svg'),
                _buildNavItem(context, 1, 'assets/icons/time.svg'),
                SizedBox(width: 70.w),
                _buildNavItem(context, 2, 'assets/icons/shield.svg'),
                _buildNavItem(context, 3, 'assets/icons/menu.svg'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 MANA SHU YERGA YOZASAN
  Widget _buildNavItem(BuildContext context, int index, String assetPath) {
    final isSelected = currentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        onTap(index);

        switch (index) {
          case 0:
            context.go(Routers.home);
            break;
          case 1:
            context.go(Routers.transactionHistory);
            break;
          case 2:
            context.go(Routers.addTransaction);
            break;
          case 3:
            context.go(Routers.monthlyLimit);
            break;
          case 4:
            context.go(Routers.statistics);
            break;
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.white24 : const Color(0xFFF3F3F3))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: SvgPicture.asset(
          assetPath,
          width: 24.w,
          height: 24.w,
          colorFilter: ColorFilter.mode(
            isSelected
                ? (isDark ? Colors.white : Colors.black)
                : const Color(0xFFACACAC),
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}