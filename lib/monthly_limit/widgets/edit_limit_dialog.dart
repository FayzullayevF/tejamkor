import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tejamkor/core/utils/app_colors.dart';

class EditLimitDialog extends StatefulWidget {
  final double currentLimit;
  final ValueChanged<double>? onSaved;
  const EditLimitDialog({super.key, required this.currentLimit, this.onSaved});

  @override
  State<EditLimitDialog> createState() => _EditLimitDialogState();
}

class _EditLimitDialogState extends State<EditLimitDialog> {
  String _amountStr = '';

  @override
  void initState() {
    super.initState();
    if (widget.currentLimit > 0) {
      if (widget.currentLimit == widget.currentLimit.toInt()) {
        _amountStr = widget.currentLimit.toInt().toString();
      } else {
        _amountStr = widget.currentLimit.toString();
      }
    }
  }

  void _onKeyPress(String key) {
    setState(() {
      if (key == '<') {
        if (_amountStr.isNotEmpty) {
          _amountStr = _amountStr.substring(0, _amountStr.length - 1);
        }
      } else if (key == '.') {
        if (!_amountStr.contains('.')) {
          _amountStr += _amountStr.isEmpty ? '0.' : '.';
        }
      } else {
        if (_amountStr.contains('.')) {
           List<String> parts = _amountStr.split('.');
           if (parts.length > 1 && parts[1].length >= 2) return;
        }
        if (_amountStr.length < 10) {
          if (_amountStr == '0' && key == '0') return;
          if (_amountStr == '0' && key != '0') {
             _amountStr = key;
             return;
          }
          _amountStr += key;
        }
      }
    });
  }

  String _getFormattedAmount() {
    if (_amountStr.isEmpty) return "0.00";
    
    List<String> parts = _amountStr.split('.');
    String whole = parts[0];
    String formattedWhole = whole.isEmpty ? "0" : NumberFormat('#,###', 'en_US').format(int.parse(whole));
    
    if (parts.length > 1) {
      return "$formattedWhole.${parts[1]}";
    } else {
      return formattedWhole;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 32.h, bottom: 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Limitni o'zgartirish",
              style: TextStyle(
                color: AppColors.darkNavy,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Oylik limitingizni ushbu joydan sozlang!",
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            _buildAmountContainer(),
            SizedBox(height: 24.h),
            _buildNumpad(),
            SizedBox(height: 24.h),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountContainer() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        color: Color(0xFFF3F5F7), // Similar to figma background
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            "SUMMA KIRITING",
            style: TextStyle(
              color: Color(0xFF007A8A), // Teal
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: Text(
                  "\$ ",
                  style: TextStyle(
                    color: AppColors.darkNavy.withOpacity(0.6),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                _getFormattedAmount(),
                style: TextStyle(
                  color: AppColors.darkNavy,
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                height: 32.h,
                width: 2.5.w,
                decoration: BoxDecoration(
                  color: Color(0xFF007A8A),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumpad() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumpadButton('1'),
              _buildNumpadButton('2'),
              _buildNumpadButton('3'),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumpadButton('4'),
              _buildNumpadButton('5'),
              _buildNumpadButton('6'),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumpadButton('7'),
              _buildNumpadButton('8'),
              _buildNumpadButton('9'),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumpadButton('.'),
              _buildNumpadButton('0'),
              _buildNumpadButton('<', isIcon: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumpadButton(String label, {bool isIcon = false}) {
    return GestureDetector(
      onTap: () => _onKeyPress(label),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60.w,
        height: 60.h,
        child: Center(
          child: isIcon
              ? Icon(Icons.backspace_outlined, color: AppColors.darkNavy, size: 26.sp)
              : Text(
                  label,
                  style: TextStyle(
                    color: AppColors.darkNavy,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (_amountStr.isNotEmpty) {
              final val = double.tryParse(_amountStr) ?? 0.0;
              if (widget.onSaved != null) {
                widget.onSaved!(val);
              }
              Navigator.pop(context, val);
            } else {
              if (widget.onSaved != null) {
                widget.onSaved!(0.0);
              }
              Navigator.pop(context, 0.0);
            }
          },
          borderRadius: BorderRadius.circular(28),
          child: Container(
            width: double.infinity,
            height: 56.h,
            decoration: BoxDecoration(
              color: Color(0xFF007A8A), // Solid teal
              borderRadius: BorderRadius.circular(28),
            ),
            alignment: Alignment.center,
            child: Text(
              "O'zgarishlarni saqlash",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(28),
          child: Container(
            width: double.infinity,
            height: 48.h,
            alignment: Alignment.center,
            child: Text(
              "Bekor qilish",
              style: TextStyle(
                color: AppColors.darkNavy,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
