import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CurrencyRatesCard extends StatelessWidget {
  const CurrencyRatesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        children: [
          Text(
            "Valyuta kurslari",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          SizedBox(height: 10.h),
          _buildCurrencyListItem(
            "assets/icons/rus_flag.svg",
            "Rossiya rubli",
            "RUB to UZS",
            "153.08 UZS",
          ),
          SizedBox(height: 5.h),
          _buildCurrencyListItem(
            "assets/icons/usa_flag.svg",
            "AQSH Dollari",
            "USD to UZS",
            "12 102.39 UZS",
          ),
          SizedBox(height: 5.h),
          _buildCurrencyListItem(
            "assets/icons/euro_flag.svg",
            "Yevro",
            "EUR to UZS",
            "13 990.36 UZS",
          ),
          SizedBox(height: 10.h),
          Text(
            "Valyuta qo'shish +",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyListItem(
    String flagPath,
    String title,
    String subTitle,
    String rate,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xffF9F9F9),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        children: [
          ClipOval(
            child: SvgPicture.asset(
              flagPath,
              width: 50.w,
              height: 49.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                Text(
                  subTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            rate,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
