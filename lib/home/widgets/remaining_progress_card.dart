import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tejamkor/core/utils/app_colors.dart';

class RemainingProgressCard extends StatelessWidget {
  const RemainingProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      // Qutidagi xatolikni oldini olish uchun (Spacer sababli pastki bo'shliq yetmay qolishi) ->
      // Endi ichki elementlarni to'g'ridan-to'g'ri Stack orqali boshqaramiz
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 1. Yuqori qismdagi ma'lumotlar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              children: [
                Center(
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/home_calendar.svg',
                        width: 33.w,
                        height: 33.w,
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Pulim qachongacha yetadi?",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Shu zaylda davom etsangiz:",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                const Text(
                  "20 kunga yetadi",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 12.h),
                Stack(
                  children: [
                    Container(
                      height: 8.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: 0.6,
                      child: Container(
                        height: 8.h,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [AppColors.cyanAccent, AppColors.darkNavy],
                          ),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                RichText(
                  text: const TextSpan(
                    text: "Bugun yana ",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      TextSpan(
                        text: "40 000 so'm",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          letterSpacing: -0.5,
                        ),
                      ),
                      TextSpan(text: " sarflash mumkin!"),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. Tejamkor Score va Dumaloq qismi aynan pastki qismda ushlab turiladi (bottom: 0)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Yashil chiziq
                Container(
                  width: double.infinity,
                  height: 56.h,
                  margin: EdgeInsets.only(right: 20.w),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  alignment: Alignment.centerLeft,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0FBC5F), Color(0xFF0B0D17)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: [0.1, 1],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      bottomLeft: Radius.circular(24),
                    ),
                  ),
                  child: const Text(
                    "Tejamkor Score",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                // Dumaloq 75 soni
                Positioned(
                  right: -10.w,
                  top: -27.h,
                  child: Container(
                    width: 110.h,
                    height: 110.h,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 15, 17, 28),
                          Color(0xFF0FBC5F),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Container(
                      width: 90.h,
                      height: 90.h,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF0FBC5F), Color(0xFF0B0D17)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: const Text(
                        "75",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                          height: 1.0,
                          letterSpacing: -1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
