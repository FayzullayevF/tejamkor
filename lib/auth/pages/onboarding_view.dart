import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tejamkor/core/routing/router.dart';
import 'package:tejamkor/widgets/app_button.dart';
import 'package:tejamkor/core/utils/app_colors.dart';

import 'package:tejamkor/home/widgets/home_balance.dart';
import 'package:tejamkor/home/widgets/income_expense_row.dart';
import 'package:tejamkor/home/widgets/remaining_progress_card.dart';
import 'package:tejamkor/home/data/models/dashboard_model.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Top Background Gradient
          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.darkNavy, AppColors.cyanAccent],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                Expanded(flex: 2, child: Container(color: Colors.white)),
              ],
            ),
          ),

          // 2. The Phone Mockup, positioned
          Positioned(
            top: 50.h,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: Transform.scale(scale: 0.95, child: const _PhoneMockup()),
            ),
          ),

          // 3. Fading white overlay covering bottom part of mockup
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.0),
                    Colors.white,
                    Colors.white,
                  ],
                  stops: const [0.0, 0.45, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // 4. Bottom Texts and Buttons
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pulingizni tejamkor\nbilan tejashni\nbugundan boshlang!",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 36,
                        height: 1.1,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Center(
                      child: AppButton(
                        height: 73.h,
                        weight: 380.w,
                        title: "Boshlash",
                        voidCallback: () {
                          context.push(Routers.login);
                        },
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhoneMockup extends StatelessWidget {
  const _PhoneMockup();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 330.w, // Approximate phone width
      height: 700.h, // Slightly taller so it blends in properly
      decoration: BoxDecoration(
        color: Colors.black, // Phone bezel
        borderRadius: BorderRadius.circular(45.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
        border: Border.all(color: Colors.grey.shade800, width: 2),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.w), // Inner screen border width
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            38.r,
          ), // Inner screen border radius
          child: Container(
            color: const Color(0xffF3F3F3), // App background
            child: Stack(
              children: [
                // App background gradient
                Container(
                  height: 350.h,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.cyanAccent, AppColors.darkNavy],
                      stops: [0.0, 0.8],
                    ),
                  ),
                ),

                // App content (wrapped in NeverScrollableScrollPhysics to prevent overflow)
                Positioned.fill(
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          SizedBox(height: 14.h), // Status bar space
                          // Fake Status Bar
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 12.w),
                                child: Text(
                                  "09:41",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              // Dynamic island mock
                              Container(
                                width: 90.w,
                                height: 24.h,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.signal_cellular_4_bar,
                                    color: Colors.white,
                                    size: 14.w,
                                  ),
                                  SizedBox(width: 4.w),
                                  Icon(
                                    Icons.wifi,
                                    color: Colors.white,
                                    size: 14.w,
                                  ),
                                  SizedBox(width: 4.w),
                                  Icon(
                                    Icons.battery_full,
                                    color: Colors.white,
                                    size: 16.w,
                                  ),
                                  SizedBox(width: 8.w),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(height: 10.h),
                          // Fake Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white.withOpacity(0.15),
                                radius: 16.r,
                                child: Icon(
                                  Icons.settings_outlined,
                                  color: Colors.white,
                                  size: 16.w,
                                ),
                              ),
                              Text(
                                "Hayrli kun, Daler",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.white.withOpacity(0.15),
                                radius: 16.r,
                                child: Icon(
                                  Icons.notifications_none_outlined,
                                  color: Colors.white,
                                  size: 16.w,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 10.h),
                          const HomeBalance(balance: 23000000, currency: "UZS"),

                          SizedBox(height: 12.h),
                          const IncomeExpenseRow(
                            totalIncome: 25000000,
                            totalExpense: 5000000,
                            currency: "uzs",
                          ),

                          SizedBox(height: 8.h),
                          Transform.scale(
                            scale: 0.9,
                            child: RemainingProgressCard(
                              tejamkorScore: TejamkorScore(
                                score: 75,
                                status: '',
                                message: '',
                              ),
                              moneyRunway: const {
                                'days': 20,
                                'daily_limit': '40 000',
                              },
                            ),
                          ),

                          SizedBox(height: 20.h),
                          // Bottom Segmented Control Mockup
                          Container(
                            width: 200.w,
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16.r),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Xarajat",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.h,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Daromad",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
