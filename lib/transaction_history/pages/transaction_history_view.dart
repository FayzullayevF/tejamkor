import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tejamkor/widgets/additional_app_bar.dart';
import 'package:tejamkor/widgets/custom_navi_bar.dart';

class TransactionHistoryView extends StatefulWidget {
  const TransactionHistoryView({super.key});

  @override
  State<TransactionHistoryView> createState() => _TransactionHistoryViewState();
}

class _TransactionHistoryViewState extends State<TransactionHistoryView> {
  int currentIndex = 1;
  int selectedChipIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xffF3F3F3),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTopCard(),
              SizedBox(height: 24.h),
              _buildSearchBar(),
              SizedBox(height: 20.h),
              _buildFilters(),
              SizedBox(height: 10.h),
              _buildDateHeader("BUGUN"),
              _buildTransactionItemSVG(
                iconSrc: "assets/icons/green_shop.svg",
                iconBgColor: const Color(0xffE0F7FA),
                title: "MX Master 4",
                subtext: "Texnika • 2:14 PM",
                amount: "-\$1,299.00",
                isIncome: false,
              ),
              _buildTransactionItemSVG(
                iconSrc: "assets/icons/brown_dish.svg",
                iconBgColor: const Color(0xffFFF4E5),
                title: "Turk koftes",
                subtext: "Ovqat & Ichimlik • 10:45 AM",
                amount: "-\$18.50",
                isIncome: false,
              ),
              _buildDateHeader("KECHA"),
              _buildTransactionItemSVG(
                iconSrc: "assets/icons/green_salary.svg",
                iconBgColor: const Color(0xffD1FAE5),
                title: "Oylik maosh",
                subtext: "Daromad • 10:45 AM",
                amount: "+\$18.50",
                isIncome: true,
              ),
              _buildTransactionItemSVG(
                iconSrc: "assets/icons/bus_car.svg",
                iconBgColor: const Color(0xffE0F7FA),
                title: "Yandex Taxi",
                subtext: "Transport • 06:30 PM",
                amount: "-\$24.20",
                isIncome: false,
              ),
              _buildTransactionItemIcon(
                iconData: Icons.fitness_center_rounded,
                iconColor: const Color(0xff008C9E),
                iconBgColor: const Color(0xffE0F7FA),
                title: "Equinox Gym",
                subtext: "Sog'liq • 08:15 AM",
                amount: "-\$150.00",
                isIncome: false,
              ),
              SizedBox(height: 120.h), // space for bottom nav bar
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildTopCard() {
    return Container(
      height: 180.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF261214), Color(0xFFE53945)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Oylik xarajat",
            style: TextStyle(color: Colors.white70, fontSize: 13.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            "\$4,285.50",
            style: TextStyle(
              color: Colors.white,
              fontSize: 36.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.trending_up, color: Colors.white, size: 14.sp),
                SizedBox(width: 4.w),
                Text(
                  "12.4% o'tgan oydan ko'proq",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      height: 52.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26.r),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey, size: 24.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Tranzaksiyalarni qidirish",
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14.sp,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    final filters = [
      "Barchasi",
      "Shopping",
      "Ovqatlanish",
      "Yandex Taxi",
    ]; // 🔥 YANGI

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(filters.length, (index) {
          return Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: _buildChip(
              filters[index],
              selectedChipIndex == index, // 🔥 SHU QO‘SHILDI
              () {
                setState(() {
                  selectedChipIndex = index; // 🔥 SHU QO‘SHILDI
                });
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildChip(String text, bool isSelected, VoidCallback callBack) {
    return GestureDetector(
      onTap: callBack,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF006673) : Colors.white,
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildDateHeader(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 24.h, bottom: 12.h),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTransactionItemSVG({
    required String iconSrc,
    required Color iconBgColor,
    required String title,
    required String subtext,
    required String amount,
    required bool isIncome,
  }) {
    return _buildTransactionCard(
      iconWidget: SvgPicture.asset(iconSrc, width: 24.w, height: 24.h),
      iconBgColor: iconBgColor,
      title: title,
      subtext: subtext,
      amount: amount,
      isIncome: isIncome,
    );
  }

  Widget _buildTransactionItemIcon({
    required IconData iconData,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtext,
    required String amount,
    required bool isIncome,
  }) {
    return _buildTransactionCard(
      iconWidget: Icon(iconData, color: iconColor, size: 24.w),
      iconBgColor: iconBgColor,
      title: title,
      subtext: subtext,
      amount: amount,
      isIncome: isIncome,
    );
  }

  Widget _buildTransactionCard({
    required Widget iconWidget,
    required Color iconBgColor,
    required String title,
    required String subtext,
    required String amount,
    required bool isIncome,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        children: [
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: iconWidget,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtext,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: isIncome ? const Color(0xFF0FBC5F) : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
