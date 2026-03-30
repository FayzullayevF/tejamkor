import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tejamkor/core/utils/app_colors.dart';
import 'widgets/home_header.dart';
import 'widgets/home_balance.dart';
import 'widgets/income_expense_row.dart';
import 'widgets/remaining_progress_card.dart';
import 'widgets/chart_card.dart';
import 'widgets/accounts_card.dart';
import 'widgets/currency_rates_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F3F3),
      extendBody: true,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.cyanAccent,
                  AppColors.darkNavy,
                  Color(0xffF3F3F3),
                ],
                stops: [0.0, 0.7, 1.0],
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HomeHeader(),
                  SizedBox(height: 16.h),
                  HomeBalance(),
                  SizedBox(height: 24.h),
                  IncomeExpenseRow(),
                  SizedBox(height: 16.h),
                  RemainingProgressCard(),
                  SizedBox(height: 24.h),
                  ChartCard(),
                  SizedBox(height: 24.h),
                  AccountsCard(),
                  SizedBox(height: 24.h),
                  CurrencyRatesCard(),
                  SizedBox(height: 120.h), // nav bar uchun joy
                ],
              ),
            ),
          ),

          // Yangi Floating Custom Nav Bar
          _buildCustomNavBar(),
        ],
      ),
    );
  }

  Widget _buildCustomNavBar() {
    return Positioned(
      bottom: 36.h,
      left: 27.w,
      right: 27.w,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            height: 68.h,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(35.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(0, 'assets/icons/house.svg'),
                _buildNavItem(1, 'assets/icons/time.svg'),
                SizedBox(width: 70.w), // O'rtadagi bo'shliq
                _buildNavItem(2, 'assets/icons/shield.svg'),
                _buildNavItem(3, 'assets/icons/menu.svg'),
              ],
            ),
          ),

          // Plus button (Kattaroq qilib o'rtada tursin)
          Container(
            height:
                80.w, // Kattaroq qildim, shunda tepa va pastga ko'proq chiqadi
            width: 80.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.cyanAccent, AppColors.darkNavy],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0ED2C9).withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.transparent,
              elevation: 0,
              focusElevation: 0,
              highlightElevation: 0,
              shape: const CircleBorder(),
              child: Icon(Icons.add, color: Colors.white, size: 36.w),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String assetPath) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF3F3F3) : Colors.transparent,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: SvgPicture.asset(
          assetPath,
          width: 24.w,
          height: 24.w,
          colorFilter: ColorFilter.mode(
            isSelected ? Colors.black : const Color(0xFFACACAC),
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
