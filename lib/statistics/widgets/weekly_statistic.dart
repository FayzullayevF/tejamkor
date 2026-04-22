import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tejamkor/statistics/widgets/weekly_data_model.dart';

class WeeklyChart extends StatelessWidget {
  final List<WeeklyData> data;

  const WeeklyChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    double maxValue = 0;
    if (data.isNotEmpty) {
      maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    }
    if (maxValue == 0) maxValue = 1;

    const lightTeal = Color(0xff008C9E);
    const darkTeal = Color(0xff006673);
    final bgColor = const Color(0xff008C9E).withValues(alpha: 0.1);

    return Container(
      height: 220.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(data.length, (index) {
                final e = data[index];
                final percent = e.value / maxValue;
                // Alternating colors: Du, Chor, Ju, Yak vs Se, Pay, Sha
                final isLight = index % 2 == 0;
                final activeColor = isLight ? lightTeal : darkTeal;
                
                // Special highlight for 'Chor' (Wednesday) as in the screenshot
                final isChor = e.day == "Chor";

                return Expanded(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    clipBehavior: Clip.none,
                    children: [
                      // Background Bar
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 1.w),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                        ),
                      ),

                      // Active Bar
                      Container(
                        height: 120.h * percent,
                        margin: EdgeInsets.symmetric(horizontal: 1.w),
                        decoration: BoxDecoration(
                          color: activeColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                          boxShadow: isChor ? [
                            BoxShadow(
                              color: activeColor.withValues(alpha: 0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ] : null,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: List.generate(data.length, (index) {
                final e = data[index];
                final isChor = e.day == "Chor";
                return Expanded(
                  child: Center(
                    child: Text(
                      e.day,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: isChor ? FontWeight.w700 : FontWeight.w500,
                        color: isChor ? const Color(0xff006673) : const Color(0xff3E494B),
                      ),
                    ),
                  ),
                );
            }),
          ),
        ],
      ),
    );
  }
}