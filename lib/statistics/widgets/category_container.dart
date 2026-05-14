import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CategoryContainer extends StatelessWidget {
  const CategoryContainer({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.amount,
    required this.percent,
    required this.progress,
    required this.containerColor,
    required this.sliderColor,
    required this.percentColor,
  });

  final String title;
  final String subtitle;
  final String icon;
  final double amount;
  final double percent;
  final double progress; // 0 → 1
  final Color containerColor, sliderColor, percentColor;

  @override
  Widget build(BuildContext context) {
    final isPositive = percent > 0;
    final isNegative = percent < 0;

    // 🔥 percent rang logikasi
    // Expense increase (+) is red, decrease (-) is green
    final displayPercentColor = isPositive
        ? const Color(0xffBA1A1A)
        : isNegative
            ? const Color(0xff0FBC5F)
            : Colors.grey;

    final percentPrefix = isPositive ? "+" : "";

    // 🔥 Icon handling: check if it's network or asset, and APPLY TINT
    Widget iconWidget;
    if (icon.startsWith('http')) {
      iconWidget = SvgPicture.network(
        icon,
        height: 22.w,
        colorFilter: ColorFilter.mode(sliderColor, BlendMode.srcIn),
      );
    } else {
      iconWidget = SvgPicture.asset(
        icon,
        height: 22.w,
        colorFilter: ColorFilter.mode(sliderColor, BlendMode.srcIn),
      );
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 48.w,
            width: 48.w,
            decoration: BoxDecoration(
              color: sliderColor.withOpacity( 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(child: iconWidget),
          ),

          SizedBox(width: 12.w),

          // Right Side: Details + Progress
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔤 TITLE + SUBTITLE
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            subtitle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xff70797B),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 💰 AMOUNT + %
                    SizedBox(width: 8.w),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "\$${NumberFormat('#,###.00').format(amount)}",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "$percentPrefix${percent.toStringAsFixed(1)}%",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: displayPercentColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10.h),

                // 🔥 PROGRESS BAR
                Container(
                  height: 6.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xffE5E9EA),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: sliderColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
