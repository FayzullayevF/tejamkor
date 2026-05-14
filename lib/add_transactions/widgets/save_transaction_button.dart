import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tejamkor/add_transactions/blocs/add_transactions_bloc.dart';
import 'package:tejamkor/add_transactions/blocs/add_transactions_event.dart';
import 'package:tejamkor/add_transactions/blocs/add_transactions_state.dart';

class SaveTransactionButton extends StatelessWidget {
  final VoidCallback? onSave;
  final bool isSubmitting;

  const SaveTransactionButton({
    super.key,
    this.onSave,
    this.isSubmitting = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isSubmitting ? null : onSave,
      child: Container(
        height: 62.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32.r),
          gradient: isSubmitting
              ? const LinearGradient(colors: [Color(0xFFEEEEEE), Color(0xFFBDBDBD)])
              : const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFF0ED2C9),
                    Color(0xFF031D20),
                  ],
                ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0ED2C9).withOpacity( 0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: isSubmitting
              ? SizedBox(
                  width: 24.w,
                  height: 24.h,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  "Tranzaktsiyani saqlash",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
        ),
      ),
    );
  }
}
