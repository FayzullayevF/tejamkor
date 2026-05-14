import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tejamkor/monthly_limit/widgets/container_inside_container.dart';

class MainContainer extends StatelessWidget {
  const MainContainer({
    super.key,
    required this.height,
    required this.width,
    required this.text,
    required this.sum,
    required this.color_one,
    required this.color_two,
    required this.sizeBox1,
    required this.sizeBox2,
    this.currencySymbol = '\$',
    this.onTap,
    this.subtitleBadge,
    this.isPositiveBadge,
  });

  final double height, width;
  final String text;
  final double sum, sizeBox1, sizeBox2;
  final String currencySymbol;
  final Color color_one, color_two;
  final VoidCallback? onTap;
  final String? subtitleBadge;
  final bool? isPositiveBadge;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      constraints: BoxConstraints(minHeight: height),
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 30.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color_one, color_two],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(height: sizeBox1.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  currencySymbol,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 32,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  NumberFormat('#,###.00').format(sum),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 48,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: sizeBox2.h),
          if (subtitleBadge != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity( 0.15),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    (isPositiveBadge ?? true)
                        ? Icons.arrow_outward
                        : Icons.arrow_downward,
                    color: Colors.white,
                    size: 14.sp,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    subtitleBadge!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          else
            ContainerInsideContainer(
              height: 28.h,
              width: 200.w,
              title: "O'zgartirish uchun bosing",
              image: "assets/icons/pan.svg",
              onTap: onTap,
            ),
        ],
      ),
    );
  }
}
