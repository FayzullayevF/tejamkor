import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tejamkor/core/data/models/accounts/account_model.dart';
import 'package:tejamkor/core/utils/icon_mapper.dart';

class AccountsCard extends StatelessWidget {
  final List<AccountModel> accounts;

  const AccountsCard({super.key, required this.accounts});

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
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
          ),
          SizedBox(height: 10.h),
          if (accounts.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Text("Hali hisoblar qo'shilmagan"),
            )
          else
            ...accounts.take(6).map((account) {
              return Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: _buildAccountListItem(
                  IconMapper.getTejamkorIcon(account.type),
                  account.name,
                  "${account.balance} ${account.currencyCode}",
                ),
              );
            }),
          SizedBox(height: 10.h),
          Text(
            "Barchasi",
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

  Widget _buildAccountListItem(String icon, String title, String amount) {
    return Container(
      height: 59.h,
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: const Color(0xffF9F9F9),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 49.h,
            width: 49.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                icon,
                color: Colors.black54,
                height: 16.h,
                width: 24.w,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
          Text(
            amount,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
