import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tejamkor/home/bloc/dashboard_bloc.dart';

class ChartCard extends StatelessWidget {
  final Map<String, dynamic> monthlyCategories;
  final String currency;
  final bool isExpense;
  final Function(bool) onToggle;

  const ChartCard({
    super.key,
    required this.monthlyCategories,
    required this.currency,
    required this.isExpense,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (!isExpense) {
                        onToggle(true);
                        context.read<DashboardBloc>().add(LoadDashboardEvent(transactionType: 'expense'));
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      decoration: BoxDecoration(
                        color: isExpense
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(30.r),
                        boxShadow: isExpense
                            ? [BoxShadow(color: Colors.black12, blurRadius: 4)]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          "Xarajat",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: isExpense
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isExpense
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (isExpense) {
                        onToggle(false);
                        context.read<DashboardBloc>().add(LoadDashboardEvent(transactionType: 'income'));
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      decoration: BoxDecoration(
                        color: !isExpense
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(30.r),
                        boxShadow: !isExpense
                            ? [BoxShadow(color: Colors.black12, blurRadius: 4)]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          "Daromad",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: !isExpense
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: !isExpense
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30.h),
          SizedBox(
            height: 300.w,
            width: 300.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Mart oyi uchun",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      monthlyCategories['total']?.toString() ?? "0\n$currency",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 32,
                      ),
                    ),
                  ],
                ),
                Positioned.fill(
                  child: CustomPaint(
                    painter: DonutChartPainter(
                      categories: monthlyCategories['categories'] ?? [],
                      isExpense: isExpense,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 47.h),
          if (monthlyCategories['categories'] != null)
            ...(monthlyCategories['categories'] as List).take(3).toList().asMap().entries.map((entry) {
              final int index = entry.key;
              final category = entry.value;
              
              final List<Color> expenseColors = [
                const Color(0xffFF6B6B),
                const Color(0xffFFD93D),
                const Color(0xffFF9248),
                const Color(0xff6BCB77),
                const Color(0xff4D96FF),
              ];

              final List<Color> incomeColors = [
                const Color(0xff4CAF50),
                const Color(0xff8BC34A),
                const Color(0xffCDDC39),
                const Color(0xff00BCD4),
                const Color(0xff009688),
              ];

              final colors = isExpense ? expenseColors : incomeColors;

              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _buildChartListItem(
                  iconSrc: "assets/icons/car.svg", // Ideally this should come from category data
                  bgColor: colors[index % colors.length],
                  title: category['name'] ?? "Kategoriya",
                  subtext: "${category['percentage'] ?? 0}%",
                  amount: "${category['amount'] ?? 0} $currency",
                ),
              );
            })
          else
            const Text("Ma'lumot yo'q"),
        ],
      ),
    );
  }

  Widget _buildChartListItem({
    required String iconSrc,
    required Color bgColor,
    required String title,
    required String subtext,
    required String amount,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 5.h),
      height: 59.h,
      decoration: BoxDecoration(
        color: const Color(0xffF3F3F3),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 49.w,
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: SvgPicture.asset(iconSrc, color: Colors.white),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              Text(
                subtext,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            amount,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
        ],
      ),
    );
  }
}

class DonutChartPainter extends CustomPainter {
  final List<dynamic> categories;
  final bool isExpense;

  DonutChartPainter({required this.categories, required this.isExpense});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 14;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24.w
      ..strokeCap = StrokeCap.butt;
    final rect = Rect.fromCircle(center: center, radius: radius);

    if (categories.isEmpty) {
      paint.color = isExpense ? const Color(0xffFF6B6B).withOpacity(0.2) : const Color(0xff4CAF50).withOpacity(0.2);
      canvas.drawCircle(center, radius, paint);
      return;
    }

    double startAngle = -pi / 2;

    final List<Color> expenseColors = [
      const Color(0xffFF6B6B),
      const Color(0xffFFD93D),
      const Color(0xffFF9248),
      const Color(0xff6BCB77),
      const Color(0xff4D96FF),
    ];

    final List<Color> incomeColors = [
      const Color(0xff4CAF50),
      const Color(0xff8BC34A),
      const Color(0xffCDDC39),
      const Color(0xff00BCD4),
      const Color(0xff009688),
    ];

    final colors = isExpense ? expenseColors : incomeColors;

    for (int i = 0; i < categories.length; i++) {
      final category = categories[i];
      final double percentage = (category['percentage'] as num?)?.toDouble() ?? 0.0;
      if (percentage <= 0) continue;
      final sweepAngle = (percentage / 100) * 2 * pi;

      paint.color = colors[i % colors.length];
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant DonutChartPainter oldDelegate) =>
      oldDelegate.categories != categories || oldDelegate.isExpense != isExpense;
}
