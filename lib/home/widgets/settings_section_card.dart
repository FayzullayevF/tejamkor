import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsSectionCard extends StatelessWidget {
  final String title;
  final List<SettingsItemData> items;
  final Color cardColor;
  final Color textColor;
  final Color subtitleColor;

  const SettingsSectionCard({
    super.key,
    required this.title,
    required this.items,
    required this.cardColor,
    required this.textColor,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: subtitleColor,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Column(
            children: List.generate(items.length, (index) {
              final item = items[index];
              return Column(
                children: [
                  _buildSettingsItem(context, item, isDark),
                  if (index < items.length - 1) _buildDivider(isDark),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(BuildContext context, SettingsItemData item, bool isDark) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(24.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE8F8F7),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: SvgPicture.asset(
                item.icon,
                colorFilter: const ColorFilter.mode(Color(0xFF058F9D), BlendMode.srcIn),
                height: 20.h,
                width: 20.w,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: subtitleColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            item.trailing ??
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade400,
                  size: 24.w,
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Padding(
      padding: EdgeInsets.only(left: 64.w, right: 16.w),
      child: Divider(
        height: 1,
        thickness: 1,
        color: isDark ? Colors.grey.shade600 : Colors.grey.shade200,
      ),
    );
  }
}

class SettingsItemData {
  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  SettingsItemData({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
  });
}
