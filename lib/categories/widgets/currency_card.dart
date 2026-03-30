
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CurrencyCard extends StatelessWidget {
  const CurrencyCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.flagSvg,
    this.activeColor,
    this.activeBgColor,
    this.isSelected = false,
    this.onTap,
  });

  final String title, subtitle, flagSvg;
  final bool isSelected;
  final VoidCallback? onTap;
  final Color? activeColor;
  final Color? activeBgColor;

  @override
  Widget build(BuildContext context) {
    final Color mainActive = activeColor ?? const Color(0xff0DC871);
    final Color mainBgActive = activeBgColor ?? const Color(0xffF0FDF4);
    
    final Color bgColor = isSelected ? mainBgActive : const Color(0xffF3F3F3);
    final Color bColor = isSelected ? mainActive : Colors.transparent;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 366.w,
        height: 73.h,
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(47),
          border: Border.all(color: bColor, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(flagSvg, width: 53.w, height: 53.h),
                SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            height: 1.2
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Color(0xff7C7777),
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            height: 1.2
                          ),
                        ),
                      ],
                    ),



              ],
            ),
            Transform.scale(
              scale: 1.2,
              child: Checkbox(
                value: isSelected,
                onChanged: (_) => onTap?.call(),
                shape: CircleBorder(),
                activeColor: mainActive,
                checkColor: Colors.white,
                side: BorderSide(
                  color: isSelected ? mainActive : const Color(0xffB5B5B5), 
                  width: 1,
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
