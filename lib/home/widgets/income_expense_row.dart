import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tejamkor/core/utils/icon_mapper.dart';

class IncomeExpenseRow extends StatelessWidget {
  final double totalIncome;
  final double totalExpense;
  final String currency;

  const IncomeExpenseRow({
    super.key,
    required this.totalIncome,
    required this.totalExpense,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildMiniCard(
            title: "Xarajatlar",
            amount: "${totalExpense.toStringAsFixed(0)} $currency",
            isExpense: true,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildMiniCard(
            title: "Daromad",
            amount: "${totalIncome.toStringAsFixed(0)} $currency",
            isExpense: false,
          ),
        ),
      ],
    );
  }

  Widget _buildMiniCard({
    required String title,
    required String amount,
    required bool isExpense,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity( 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                isExpense ? 'assets/icons/xarajat_icon.svg' : 'assets/icons/daromad_icon.svg',
                colorFilter: ColorFilter.mode(isExpense ? Colors.red : Colors.green, BlendMode.srcIn),
                width: 14.w,
                height: 14.w,
              ),
              SizedBox(width: 4.w),
              Text(
                title,
                style: TextStyle(
                  color: isExpense ? Colors.red : Colors.green,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            amount,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
