import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tejamkor/categories/data/models/currency_model.dart';

class CurrencyRatesCard extends StatelessWidget {
  final List<CurrencyModel> rates;
  final List<CurrencyModel> otherCurrencies;
  final String baseCurrencySymbol;
  final String baseCurrencyCode;
  final VoidCallback onAddClick;
  final Function(CurrencyModel) onCurrencySelected;
  final Function(CurrencyModel) onDelete;

  const CurrencyRatesCard({
    super.key,
    required this.rates,
    required this.otherCurrencies,
    required this.baseCurrencySymbol,
    required this.baseCurrencyCode,
    required this.onAddClick,
    required this.onCurrencySelected,
    required this.onDelete,
  });

  String _getFlagAsset(String code) {
    switch (code) {
      case 'UZS':
        return "assets/icons/uzb_flag.svg";
      case 'RUB':
        return "assets/icons/rus_flag.svg";
      case 'USD':
        return "assets/icons/usa_flag.svg";
      case 'EUR':
        return "assets/icons/euro_flag.svg";
      default:
        return "assets/icons/uzb_flag.svg";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Valyuta kurslari",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 20.h),
          ...rates.map((rate) => _buildCurrencyItem(context, rate)),
          SizedBox(height: 12.h),
          _buildAddButton(context),
        ],
      ),
    );
  }

  Widget _buildCurrencyItem(BuildContext context, CurrencyModel currency) {
    return GestureDetector(
      onLongPress: () {
        _showDeleteMenu(context, currency);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(40.r),
          border: Border.all(color: const Color(0xFFE9ECEF), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: SvgPicture.asset(
                  _getFlagAsset(currency.code),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currency.name,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    "${currency.code} to $baseCurrencyCode",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFADB5BD),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              "${currency.rate} $baseCurrencyCode",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteMenu(BuildContext context, CurrencyModel currency) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 24.h),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Text(
                "Valyutani o'chirish",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "${currency.name} valyutasini dashboard'dan o'chirasizmi?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF7C7777),
                ),
              ),
              SizedBox(height: 32.h),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 56.h,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE9ECEF)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: Text(
                          "Bekor qilish",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: SizedBox(
                      height: 56.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF4D4F),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        onPressed: () {
                          onDelete(currency);
                          Navigator.pop(context);
                        },
                        child: Text(
                          "O'chirish",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: PopupMenuButton<CurrencyModel>(
        onOpened: onAddClick,
        onSelected: onCurrencySelected,
        offset: const Offset(0, 45),
        elevation: 8,
        color: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        itemBuilder: (context) {
          if (otherCurrencies.isEmpty) {
            return [
              PopupMenuItem(
                enabled: false,
                child: Center(
                  child: Text(
                    "Hamma valyutalar qo'shilgan",
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                  ),
                ),
              )
            ];
          }
          return otherCurrencies.map((c) {
            return PopupMenuItem<CurrencyModel>(
              value: c,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFE9ECEF)),
                ),
                child: Row(
                  children: [
                    ClipOval(
                      child: SvgPicture.asset(
                        _getFlagAsset(c.code),
                        width: 28.w,
                        height: 28.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        "${c.name} (${c.code})",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Icon(Icons.add_circle_outline, size: 20.w, color: const Color(0xFF0ED2C9)),
                  ],
                ),
              ),
            );
          }).toList();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.transparent, // Ensures the whole area is clickable
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Valyuta qo'shish ",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Icon(Icons.add, size: 20.w, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}
