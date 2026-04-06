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
    required this.progress, required this.containerColor, required this.sliderColor, required this.percentColor,
  });

  final String title;
  final String subtitle;
  final String icon;
  final double amount;
  final double percent;
  final double progress; // 0 → 1
  final Color containerColor,sliderColor,percentColor;

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

    // 🔥 icon logikasi
    final percentIcon = isPositive
        ? Icons.arrow_upward
        : isNegative
        ? Icons.arrow_downward
        : Icons.remove;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 48.w,
                width: 48.w,
                decoration: BoxDecoration(
                  color: containerColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    icon,
                    height: 22,
                  ),
                ),
              ),

              SizedBox(width: 12.w),

              // 🔤 TITLE + SUBTITLE
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              // 💰 AMOUNT + %
              Column(
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
                  Row(
                    children: [
                      Icon(
                        percentIcon,
                        size: 14,
                        color: percentColor,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        "${percent.abs()}%",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: percentColor,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),

          SizedBox(height: 10.h),

          // 🔥 PROGRESS BAR
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LayoutBuilder(
              builder: (context, constraints) {
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
                      width: constraints.maxWidth * progress,
                      color: sliderColor,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}