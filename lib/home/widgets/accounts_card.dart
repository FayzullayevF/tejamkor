import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountsCard extends StatelessWidget {
  const AccountsCard({super.key});

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
            "Hisoblar",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
          ),
          SizedBox(height: 16.h),
          _buildAccountListItem(
            Icons.account_balance_wallet_outlined,
            "Naqd pul UZS",
            "1 200 000 UZS",
          ),
          SizedBox(height: 12.h),
          _buildAccountListItem(
            Icons.account_balance_wallet_outlined,
            "Naqd pul USD",
            "250 USD",
          ),
          SizedBox(height: 12.h),
          _buildAccountListItem(
            Icons.credit_card_outlined,
            "HAMKORBANK",
            "3 000 000 UZS",
          ),
          SizedBox(height: 16.h),
          Text(
            "Barchasi",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountListItem(IconData icon, String title, String amount) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xffF9F9F9),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54, size: 22.w),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.sp),
            ),
          ),
          Text(
            amount,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
          ),
        ],
      ),
    );
  }
}
