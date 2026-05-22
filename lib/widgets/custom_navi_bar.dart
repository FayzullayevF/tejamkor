import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tejamkor/core/routing/router.dart';
import 'package:tejamkor/core/utils/app_colors.dart';

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

    return Padding(
      padding: EdgeInsets.only(left: 27.w, right: 27.w, bottom: 36.h),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            height: 68.h,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(35.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity( 0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity( 0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
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
          Container(
            height: 80.w,
            width: 80.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.darkNavy, AppColors.cyanAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0ED2C9).withOpacity( 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: FloatingActionButton(
              heroTag: null,
              onPressed: () {
                context.push(Routers.addTransaction);
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              focusElevation: 0,
              highlightElevation: 0,
              shape: const CircleBorder(),
              child: Icon(Icons.add, color: Colors.white, size: 36.w),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, String assetPath) {
    final isSelected = currentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        onTap(index);
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
