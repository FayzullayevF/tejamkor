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
    this.onTap,
  });

  final double height, width;
  final String text;
  final double sum, sizeBox1, sizeBox2;
  final Color color_one, color_two;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          SizedBox(height: sizeBox1.h),
          Row(
            children: [
              Text(
                "\$",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                NumberFormat('#,###').format(sum),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 48,
                ),
              ),
            ],
          ),
          SizedBox(height: sizeBox2.h),
          ContainerInsideContainer(
            height: 24.h,
            width: 175.w,
            title: "O'zgartirish uchun bosing",
            image: "assets/icons/pan.svg",
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
