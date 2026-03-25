import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthSegmented extends StatelessWidget {
  final bool isLogin;
  final ValueChanged<bool> onChanged;

  const AuthSegmented({
    super.key,
    required this.isLogin,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 71.h,
      padding:  EdgeInsets.symmetric(vertical: 5.h,horizontal: 5.w),
      decoration: BoxDecoration(
        color:  Color(0xFFF1F2F4),
        borderRadius: BorderRadius.circular(35),
      ),
      child: Row(
        children: [
          _item("Tizimga kirish", isLogin, () => onChanged(true)),
          _item("Ro’yxatdan o’tish", !isLogin, () => onChanged(false)),
        ],
      ),
    );
  }

  Widget _item(String text, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 61.h,
          width: 183.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(35),
          ),
          child: Text(text,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: active ? Colors.black : Colors.black45)),
        ),
      ),
    );
  }
}
