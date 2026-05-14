import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class DailyAverage extends StatelessWidget {
  final double averageAmount;
  final double dailyLimit;
  final String currency;

  const DailyAverage({
    super.key,
    required this.averageAmount,
    required this.dailyLimit,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffF0F4F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xff008C9E),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(width: 24.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "KUNLIK O‘RTACHA",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xff3E494B),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "$currency${NumberFormat('#,###.00').format(averageAmount)}",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "$currency${NumberFormat('#,###.00').format(dailyLimit)} kunlik sarflash limiti",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xff006673),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ⚡ ICON (o‘ng taraf)
          Container(
            height: 48,
            width: 48,
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset("assets/icons/leaf.svg"),
          ),
        ],
      ),
    );
  }
}
