import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class TotalContainer extends StatelessWidget {
  const TotalContainer({super.key, required this.allocated, required this.remaining});

  final double allocated;
  final double remaining;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: Color(0xffF0F4F5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: SizedBox(
        height: 55.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "UMUMIY AJRATILGAN",
                  style: TextStyle(
                    color: Color(0xff3E494B),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  "\$${NumberFormat('#,###.00', 'en_US').format(allocated)}",
                  style: TextStyle(
                    color: Color(0xff006673),
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "QOLGAN",
                  style: TextStyle(
                    color: Color(0xff3E494B),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  "\$${NumberFormat('#,###.00', 'en_US').format(remaining)}",
                  style: TextStyle(
                    color: Color(0xff006673),
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
