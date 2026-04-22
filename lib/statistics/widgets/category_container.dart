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
    final percentColor = isPositive
        ? Colors.red
        : isNegative
        ? Colors.green
        : Colors.grey;

    final percentPrefix = isPositive ? "+" : "";
    
    // 🔥 Icon handling: check if it's network or asset
    Widget iconWidget;
    if (icon.startsWith('http')) {
      iconWidget = SvgPicture.network(icon, height: 22);
    } else {
      iconWidget = SvgPicture.asset(icon, height: 22);
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 48.w,
            width: 48.w,
            decoration: BoxDecoration(
              color: containerColor.withValues(alpha: 0.15),
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
                              color: Colors.grey,
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
                            "$percentPrefix$percent%",
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              color: percentColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10.h),

                // 🔥 PROGRESS BAR
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Adjust progress if > 1.0
                      final adjustedProgress = progress > 1 ? progress / 100 : progress;
                      return Stack(
                        children: [
                          // background
                          Container(
                            height: 6.h,
                            width: double.infinity,
                            color: const Color(0xffE5E9EA),
                          ),

                          // progress
                          Container(
                            height: 6.h,
                            width: constraints.maxWidth * adjustedProgress.clamp(0.0, 1.0),
                            color: sliderColor,
                          ),
                        ],
                      );
                    },
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
