import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChartCard extends StatefulWidget {
  const ChartCard({super.key});

  @override
  State<ChartCard> createState() => _ChartCardState();
}

class _ChartCardState extends State<ChartCard> {
  bool isExpenseSelected = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        children: [
          // Segmented Toggle
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isExpenseSelected = true),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      decoration: BoxDecoration(
                        color: isExpenseSelected
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(30.r),
                        boxShadow: isExpenseSelected
                            ? [BoxShadow(color: Colors.black12, blurRadius: 4)]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          "Xarajat",
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: isExpenseSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isExpenseSelected
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isExpenseSelected = false),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      decoration: BoxDecoration(
                        color: !isExpenseSelected
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(30.r),
                        boxShadow: !isExpenseSelected
                            ? [BoxShadow(color: Colors.black12, blurRadius: 4)]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          "Daromad",
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: !isExpenseSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: !isExpenseSelected
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30.h),
          // Donut Chart Mock
          SizedBox(
            height: 200.w,
            width: 200.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Inner texts
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Mart oyi uchun",
                      style: TextStyle(color: Colors.black54, fontSize: 11.sp),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "5 000 000\nUZS",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),
                    ),
                  ],
                ),
                // Painter bounds
                Positioned.fill(
                  child: CustomPaint(painter: DonutChartPainter()),
                ),
              ],
            ),
          ),
          SizedBox(height: 30.h),
          // List Items below chart
          _buildChartListItem(
            iconSrc: "assets/icons/car.svg",
            bgColor: const Color(0xff0ED2C9),
            title: "Taksi",
            subtext: "35%",
            amount: "1 200 000 UZS",
          ),
          SizedBox(height: 12.h),
          _buildChartListItem(
            iconSrc: "assets/icons/heart.svg",
            bgColor: const Color(0xffFFA000),
            title: "Salomatlik",
            subtext: "55%",
            amount: "2 200 000 UZS",
          ),
          SizedBox(height: 12.h),
          _buildChartListItem(
            iconSrc: "assets/icons/home.svg",
            bgColor: const Color(0xffAB47BC),
            title: "Ijara",
            subtext: "25%",
            amount: "800 000 UZS",
          ),
        ],
      ),
    );
  }

  Widget _buildChartListItem({
    required String iconSrc,
    required Color bgColor,
    required String title,
    required String subtext,
    required String amount,
  }) {
    return Row(
      children: [
        Container(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            iconSrc,
            color: Colors.white,
            width: 22.w,
            height: 22.w,
          ),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp),
            ),
            Text(
              subtext,
              style: TextStyle(color: Colors.grey, fontSize: 11.sp),
            ),
          ],
        ),
        const Spacer(),
        Text(
          amount,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
        ),
      ],
    );
  }
}

// A straightforward replica of the 3-section donut chart seen in the design
class DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 14;

    final paint =Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: center, radius: radius);

    // Cyan (Top/Right, biggest) ~ 40%
    paint.color = const Color(0xff0ED2C9);
    canvas.drawArc(rect, -pi / 2, pi, false, paint);

    // Orange (Bottom/Right) ~ 40%
    paint.color = const Color(0xffFFA000);
    canvas.drawArc(rect, pi / 2 + 0.2, pi * 0.7, false, paint);

    // Purple (Bottom/Left) ~ 20%
    paint.color = const Color(0xffAB47BC);
    canvas.drawArc(rect, pi * 1.3, pi * 0.4, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
