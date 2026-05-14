import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tejamkor/statistics/widgets/weekly_data_model.dart';

class WeeklyChart extends StatefulWidget {
  final List<WeeklyData> data;

  const WeeklyChart({super.key, required this.data});

  @override
  State<WeeklyChart> createState() => _WeeklyChartState();
}

class _WeeklyChartState extends State<WeeklyChart> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    double maxValue = 0;
    if (widget.data.isNotEmpty) {
      maxValue = widget.data.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    }
    // If max is 0, set to 1 so bars are just at the bottom
    if (maxValue == 0) maxValue = 1;

    const activeColor = Color(0xFF008C9E);
    const inactiveColor = Color(0xFF006673);
    const trackBgColor = Color(0xFFE8F5F8);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.r),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 215.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(widget.data.length, (index) {
                final e = widget.data[index];
                final percent = e.value / maxValue;
                
                final isSelected = _selectedIndex == index;
                final isLast = index == widget.data.length - 1;
                
                // Highlight logic: if selected, or if nothing selected and it's today
                final highlight = isSelected || (isLast && _selectedIndex == null);
                
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_selectedIndex == index) {
                          _selectedIndex = null;
                        } else {
                          _selectedIndex = index;
                        }
                      });
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        // Tooltip (Amount display)
                        if (isSelected)
                          Positioned(
                            top: 0,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: activeColor,
                                borderRadius: BorderRadius.circular(12.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: activeColor.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: Text(
                                "${e.value.toInt()} ${e.currency}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                        // Full Height Track
                        Padding(
                          padding: EdgeInsets.only(top: 35.h),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            decoration: BoxDecoration(
                              color: trackBgColor,
                              borderRadius: BorderRadius.circular(50.r),
                            ),
                          ),
                        ),

                        // Active Value Bar
                        Padding(
                          padding: EdgeInsets.only(top: 35.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeOutCubic,
                                height: (180.h * percent).clamp(36.h, 180.h),
                                margin: EdgeInsets.symmetric(horizontal: 4.w),
                                decoration: BoxDecoration(
                                  color: highlight ? activeColor : inactiveColor.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(50.r),
                                  boxShadow: highlight ? [
                                    BoxShadow(
                                      color: activeColor.withOpacity(0.3),
                                      blurRadius: 15,
                                      offset: const Offset(0, 5),
                                    )
                                  ] : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: List.generate(widget.data.length, (index) {
              final e = widget.data[index];
              final isSelected = _selectedIndex == index;
              final isLast = index == widget.data.length - 1;
              final highlight = isSelected || (isLast && _selectedIndex == null);

              return Expanded(
                child: Center(
                  child: Text(
                    e.day,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: highlight ? FontWeight.w700 : FontWeight.w500,
                      color: highlight ? activeColor : const Color(0xff70797B),
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