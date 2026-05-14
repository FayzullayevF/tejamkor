import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/utils/app_colors.dart';

class Header extends StatelessWidget {
  const Header({super.key, required this.currentPage});

  final int currentPage;

  @override
  Widget build(BuildContext context) {
    final titles = [
      "Pul birligingizni sozlang!",
      "Xarajatlar toifalarini tanlang!",
      "Daromadlar toifalarini tanlang!",
    ];
    final subtitle = [
      "Ilovada xarajat va daromadlaringizni oson kuzatib borish uchun foydalanmoqchi bo'lgan pul birligingizni tanlang!",
      "Odatda sarflaydigan xarajatlaringizni tanlang",
      "Odatda oladigan daromadlar toifasini tanlang",
    ];
    return Column(
      children: [
        Text(
          titles[currentPage],
          style: TextStyle(
            color: Colors.black,
            fontSize: 36,
            fontWeight: FontWeight.w700,
            height: 1,
            letterSpacing: -1
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          subtitle[currentPage],
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w400,
              height: 1

          ),
        ),
        SizedBox(height: 26.h),
        Row(
          children: [
            Text(
              "${currentPage + 1} ",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            SizedBox(width: 7.w),
            Expanded(
              child: Container(
                height: 11.h,
                decoration: BoxDecoration(
                  color: const Color(0xffF3F3F3),
                  borderRadius: BorderRadius.circular(35),
                ),
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: (currentPage + 1) / 3,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          AppColors.cyanAccent,
                          AppColors.darkNavy,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 7.w),
            Text(
              "3",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
          ],
        ),

      ],
    );
  }
}
