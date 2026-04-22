import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:tejamkor/add_transactions/data/models/wallet_model.dart';

class WalletSelectionCard extends StatelessWidget {
  final List<WalletModel> wallets;
  final int selectedAccountId;
  final Color cardColor;
  final Color textColor;
  final Color subtitleColor;
  final bool isDark;
  final Function(int) onAccountSelected;

  const WalletSelectionCard({
    super.key,
    required this.wallets,
    required this.selectedAccountId,
    required this.cardColor,
    required this.textColor,
    required this.subtitleColor,
    required this.isDark,
    required this.onAccountSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (wallets.isEmpty) return const SizedBox.shrink();

    final selectedWallet = wallets.firstWhere(
      (w) => w.id == selectedAccountId,
      orElse: () => wallets.first,
    );

    return GestureDetector(
      onTap: () => _showWalletBottomSheet(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: const BoxDecoration(
                color: Color(0xFFFCE8F3),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                selectedWallet.icon,
                width: 24.w,
                height: 24.w,
                colorFilter: const ColorFilter.mode(
                  Color(0xFFE91E63),
                  BlendMode.srcIn,
                ),
              ),
            ),
            SizedBox(width: 16.w),

            /// 🔥 TEXT O‘ZGARMAS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hisoblar",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    selectedWallet.name,
                    style: TextStyle(color: subtitleColor, fontSize: 12.sp),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${_formatNumber(selectedWallet.balance).replaceAll(',', ' ')} ${selectedWallet.code}",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Icon(Icons.keyboard_arrow_down_rounded, color: subtitleColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showWalletBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Hisobni tanlang",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h),

                  /// 🔥 ANIMATED LIST
                  Expanded(
                    child: ListView.builder(
                      itemCount: wallets.length,
                      itemBuilder: (context, index) {
                        final w = wallets[index];
                        bool isSelected = selectedAccountId == w.id;

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOut,
                          margin: EdgeInsets.only(bottom: 8.h),
                          transform: Matrix4.identity()
                            ..scale(isSelected ? 1.02 : 1.0), // 🔥 scale effect
                          child: GestureDetector(
                            onTap: () {
                              onAccountSelected(w.id);
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 12.h,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF1E1E1E)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFFB7E4C7)
                                      : Colors.grey.withValues(alpha: 0.1),
                                  width: isSelected ? 1.5 : 1,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: Colors.green.withValues(
                                            alpha: 0.15,
                                          ),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Row(
                                children: [
                                  _itemItems(w.icon, isSelected),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Text(
                                      w.name,
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "${_formatNumber(w.balance).replaceAll(',', ' ')}",
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Text(
                                        w.code,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 11.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 10.h),

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F3F3),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 20.w),
                        SizedBox(width: 8.w),
                        Text(
                          "Hisob qo'shish",
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _itemItems(String icon, bool isSelected) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 48.w,
          width: 48.w,
          decoration: const BoxDecoration(
            color: Color(0xffFCE8F3),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              icon,
              width: 24.w,
              height: 24.w,
              colorFilter: const ColorFilter.mode(
                Color(0xFFE91E63),
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        if (isSelected)
          const Positioned(
            top: 2,
            right: 0,
            child: Icon(Icons.check_circle, color: Color(0xFFE91E63), size: 14),
          ),
      ],
    );
  }

  String _formatNumber(double number) {
    final formatter = NumberFormat('#,###', 'en_US');
    return formatter.format(number.toInt());
  }
}
