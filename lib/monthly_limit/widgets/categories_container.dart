import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class CategoriesContainer extends StatelessWidget {
  const CategoriesContainer({
    super.key,
    required this.height,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.maxLimit,
    required this.onChanged,
    this.currencySymbol = '\$',
  });

  final double height;
  final Widget icon;
  final String title, subtitle;
  final double value;
  final double maxLimit;
  final String currencySymbol;
  final ValueChanged<double>? onChanged;

  @override
  Widget build(BuildContext context) {
    final double safeMax = maxLimit < value ? value : maxLimit;
    final double sliderMax = safeMax <= 0 ? 1.0 : safeMax;
    final bool isDisabled = maxLimit <= 0 && value <= 0;

    return Container(
      height: height,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 TOP QISM
          Row(
            children: [
              SizedBox(width: 40, height: 40, child: icon),
              SizedBox(width: 12.w),
              /// TEXTLAR
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xff3E494B),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "$currencySymbol${NumberFormat('#,###').format(value)}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          Slider(
            thumbColor: Color(0xff006673),
            inactiveColor: Color(0xffE5E9EA),
            value: value.clamp(0.0, sliderMax),
            min: 0,
            max: sliderMax,
            activeColor: Colors.teal,
            onChanged: isDisabled ? null : onChanged,
          ),
        ],
      ),
    );
  }
}