import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tejamkor/monthly_limit/widgets/edit_limit_dialog.dart';
import 'package:tejamkor/categories/data/models/currency_model.dart';

class AmountInputSection extends StatefulWidget {
  final double amount;
  final String currencySymbol;
  final Color textColor;
  final double maxTransactionAmount;
  final Function(double) onAmountChanged;
  final List<CurrencyModel> availableCurrencies;
  final int selectedCurrencyId;
  final Function(int) onCurrencyChanged;

  const AmountInputSection({
    super.key,
    required this.amount,
    required this.currencySymbol,
    required this.textColor,
    required this.maxTransactionAmount,
    required this.onAmountChanged,
    required this.availableCurrencies,
    required this.selectedCurrencyId,
    required this.onCurrencyChanged,
  });

  @override
  State<AmountInputSection> createState() => _AmountInputSectionState();
}

class _AmountInputSectionState extends State<AmountInputSection> {
  late FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    int initialIndex = widget.availableCurrencies.indexWhere((c) => c.id == widget.selectedCurrencyId);
    if (initialIndex == -1) initialIndex = 0;
    _scrollController = FixedExtentScrollController(initialItem: initialIndex);
  }

  @override
  void didUpdateWidget(AmountInputSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCurrencyId != widget.selectedCurrencyId) {
      int newIndex = widget.availableCurrencies.indexWhere((c) => c.id == widget.selectedCurrencyId);
      if (newIndex != -1 && _scrollController.selectedItem != newIndex) {
        _scrollController.animateToItem(
          newIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _formatAmount(double amount) {
    int intAmount = amount.toInt();
    final formatter = NumberFormat('#,###', 'en_US');
    return formatter.format(intAmount).replaceAll(',', ' ');
  }

  @override
  Widget build(BuildContext context) {
    String formattedAmount = _formatAmount(widget.amount);

    final selectedCurrency = widget.availableCurrencies.firstWhere(
      (c) => c.id == widget.selectedCurrencyId,
      orElse: () => widget.availableCurrencies.isNotEmpty 
          ? widget.availableCurrencies.first 
          : CurrencyModel(id: 0, code: 'UZS', name: "O'zbek so'mi", symbol: "so'm", rate: "1", isDefault: true),
    );

    return Column(
      children: [
        Center(
          child: Text(
            "Mablag'ni kiriting",
            style: TextStyle(
              color: const Color(0xff7C7777),
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Scrollable Currency Selector
            SizedBox(
              height: 160.h,
              width: 80.w,
              child: ListWheelScrollView.useDelegate(
                controller: _scrollController,
                itemExtent: 50.h,
                perspective: 0.005,
                diameterRatio: 1.2,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (index) {
                  widget.onCurrencyChanged(widget.availableCurrencies[index].id);
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  builder: (context, index) {
                    final currency = widget.availableCurrencies[index];
                    final isSelected = currency.id == widget.selectedCurrencyId;
                    return Center(
                      child: Text(
                        currency.code,
                        style: TextStyle(
                          color: isSelected 
                              ? const Color(0xFF006673) 
                              : const Color(0xFFADB5BD).withOpacity(0.5),
                          fontSize: isSelected ? 30.sp : 22.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  },
                  childCount: widget.availableCurrencies.length,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Fixed Amount Text with Underline
            GestureDetector(
              onTap: () async {
                final newAmount = await showDialog<double>(
                  context: context,
                  builder: (context) => EditLimitDialog(
                    currentLimit: widget.amount,
                    currencySymbol: selectedCurrency.symbol,
                    maxLimit: widget.maxTransactionAmount,
                  ),
                );
                if (newAmount != null) {
                  widget.onAmountChanged(newAmount);
                }
              },
              child: IntrinsicWidth(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      formattedAmount,
                      style: TextStyle(
                        color: widget.amount > widget.maxTransactionAmount
                            ? Colors.red
                            : widget.textColor,
                        fontSize: 48.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1.0,
                      ),
                    ),
                    Container(
                      height: 5.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0ED2C9),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (widget.amount > widget.maxTransactionAmount)
          Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: Text(
              'Maksimal summa ${_formatAmount(widget.maxTransactionAmount)} ${selectedCurrency.symbol}',
              style: TextStyle(
                color: Colors.red,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
