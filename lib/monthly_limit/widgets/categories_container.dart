import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class CategoriesContainer extends StatefulWidget {
  const CategoriesContainer({
    super.key,
    required this.height,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  final double height;
  final String image;
  final String title, subtitle;

  @override
  State<CategoriesContainer> createState() => _CategoriesContainerState();
}

class _CategoriesContainerState extends State<CategoriesContainer> {
  double value = 1200;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
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
              SvgPicture.asset(widget.image, width: 40, height: 40),
              SizedBox(width: 12.w),

              /// TEXTLAR
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xff3E494B),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "\$${NumberFormat('#,###').format(value)}",
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
            value: value,
            min: 0,
            max: 5000, // max limit
            activeColor: Colors.teal,
            onChanged: (newValue) {
              setState(() {
                value = newValue;
              });
            },
          ),
        ],
      ),
    );
  }
}