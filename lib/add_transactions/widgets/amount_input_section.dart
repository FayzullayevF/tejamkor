import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tejamkor/categories/data/models/currency_model.dart';
import 'package:tejamkor/monthly_limit/widgets/edit_limit_dialog.dart';

class AmountInputSection extends StatefulWidget {
  final double amount;
  final int selectedCurrencyId;
  final List<CurrencyModel> allCurrencies;
  final String currencySymbol;
  final Color textColor;
  final double maxTransactionAmount;
  final Function(double) onAmountChanged;
  final Function(int) onCurrencyChanged;

  const AmountInputSection({
    super.key,
    required this.amount,
    required this.selectedCurrencyId,
    required this.allCurrencies,
    required this.currencySymbol,
    required this.textColor,
    required this.maxTransactionAmount,
    required this.onAmountChanged,
    required this.onCurrencyChanged,
  });

  @override
  State<AmountInputSection> createState() => _AmountInputSectionState();
}

class _AmountInputSectionState extends State<AmountInputSection> {
  late FixedExtentScrollController _scrollController;
  final displayCodes = ["EUR", "USD", "RUB", "UZS"];

  @override
  void initState() {
    super.initState();
    int initialIndex = 3; // Default to UZS (last index now)
    _scrollController = FixedExtentScrollController(initialItem: initialIndex);
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _formatAmount(double amount) {
    int intAmount = amount.toInt();
    final formatter = NumberFormat('#,###', 'en_US');
    return formatter.format(intAmount);
  }

  @override
  Widget build(BuildContext context) {
    String formattedAmount = _formatAmount(widget.amount);
    
    return Column(
      children: [
        Center(
          child: Text(
            "Mablag'ni kiriting",
            style: TextStyle(
              color: const Color(0xff7C7777),
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Scrollable Currency Selector
            SizedBox(
              width: 50.w,
              height: 100.h,
              child: ListWheelScrollView.useDelegate(
                controller: _scrollController,
                itemExtent: 32.h,
                physics: const FixedExtentScrollPhysics(),
                perspective: 0.005,
                diameterRatio: 1.2,
                onSelectedItemChanged: (index) {
                   final code = displayCodes[index];
                   final currency = widget.allCurrencies.where((c) => c.code == code).firstOrNull;
                   if (currency != null) {
                     widget.onCurrencyChanged(currency.id);
                   }
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: displayCodes.length,
                  builder: (context, index) {
                    final code = displayCodes[index];
                    final currency = widget.allCurrencies.where((c) => c.code == code).firstOrNull;
                    bool isSelected = currency != null && widget.selectedCurrencyId == currency.id;
                    
                    return Center(
                      child: Text(
                        code,
                        style: TextStyle(
                          color: const Color(0xFF006673).withValues(alpha: isSelected ? 1.0 : 0.3),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(width: 16.w),
            // Amount
            GestureDetector(
              onTap: () async {
                final newAmount = await showDialog<double>(
                  context: context,
                  builder: (context) => EditLimitDialog(
                    currentLimit: widget.amount,
                    currencySymbol: widget.currencySymbol,
                    maxLimit: widget.maxTransactionAmount,
                  ),
                );
                if (newAmount != null) {
                  widget.onAmountChanged(newAmount);
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    formattedAmount,
                    style: TextStyle(
                      color: widget.amount > widget.maxTransactionAmount ? Colors.red : const Color(0xFF1E1E1E),
                      fontSize: 56.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1.0,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    widget.currencySymbol,
                    style: TextStyle(
                      color: const Color(0xFF7C7777),
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (widget.amount > widget.maxTransactionAmount)
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Text(
              'Maksimal summa ${_formatAmount(widget.maxTransactionAmount)} ${widget.currencySymbol}',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
