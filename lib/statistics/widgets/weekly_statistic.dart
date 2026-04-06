import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tejamkor/statistics/widgets/weekly_data_model.dart';

class WeeklyChart extends StatelessWidget {
  final List<WeeklyData> data;

  const WeeklyChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final maxValue =
    data.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    const activeColor1 = Color(0xff008C9E);
    const activeColor2 = Color(0xff006673);
    const bgColor = Color(0xffF0F4F5);

    return Container(
      height: 192.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(data.length, (index) {
          final e = data[index];

          final percent = e.value / maxValue;

          final activeHeight = 100.h * percent;
          final inactiveHeight = 100.h * (1 - percent);

          final activeColor =
          index % 2 == 0 ? activeColor1 : activeColor2;

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // 🔥 BAR
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // inactive (yuqori qism)
                    Container(
                      height: inactiveHeight,
                      width: 26.w,
                      color: bgColor,
                    ),

                    // active (pastki qism)
                    Container(
                      height: activeHeight,
                      width: 26.w,
                      color: activeColor,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 8.h),

              // 🔤 DAY TEXT
              Text(
                e.day,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}