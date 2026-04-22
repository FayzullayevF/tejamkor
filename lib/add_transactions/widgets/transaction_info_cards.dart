import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:tejamkor/home/widgets/custom_date_dialog.dart';
import 'package:tejamkor/home/widgets/custom_note_dialog.dart';

class TransactionInfoCards extends StatelessWidget {
  final DateTime selectedDate;
  final String note;
  final Color cardColor;
  final Color textColor;
  final Color subtitleColor;
  final Function(DateTime) onDateChanged;
  final Function(String) onNoteChanged;

  const TransactionInfoCards({
    super.key,
    required this.selectedDate,
    required this.note,
    required this.cardColor,
    required this.textColor,
    required this.subtitleColor,
    required this.onDateChanged,
    required this.onNoteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final date = await showDialog<DateTime>(
                context: context,
                builder: (context) =>
                    CustomDateDialog(initialDate: selectedDate),
              );
              if (date != null) onDateChanged(date);
            },
            child: _buildInfoCard(
              context: context,
              icon: "assets/icons/new_calendar.svg",
              title: "SANA",
              subtitle: DateFormat('MMM dd, yyyy').format(selectedDate),
              cardColor: cardColor,
              textColor: textColor,
              subtitleColor: subtitleColor,
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final noteResult = await showDialog<String>(
                context: context,
                builder: (context) => CustomNoteDialog(initialNote: note),
              );
              if (noteResult != null && noteResult.isNotEmpty) {
                onNoteChanged(noteResult);
              }
            },
            child: _buildInfoCard(
              context: context,
              icon: "assets/icons/new_data.svg",
              title: "NOTE",
              subtitle: note.isEmpty || note == "Add note"
                  ? "Add note"
                  : (note.length > 10
                        ? '${note.substring(0, 10)}...'
                        : note),
              cardColor: cardColor,
              textColor: textColor,
              subtitleColor: subtitleColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required String icon,
    required String title,
    required String subtitle,
    required Color cardColor,
    required Color textColor,
    required Color subtitleColor,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE8F8F7),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              icon,
              width: 16.w,
              height: 16.w,
              colorFilter: const ColorFilter.mode(
                Color(0xFF058F9D),
                BlendMode.srcIn,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: subtitleColor,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
