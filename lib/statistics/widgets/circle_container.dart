import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CircleContainer extends StatelessWidget {
  const CircleContainer({super.key, required this.color, required this.image});

  final Color color;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      width: 48.w,
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: SvgPicture.asset(image),
    );
  }
}
