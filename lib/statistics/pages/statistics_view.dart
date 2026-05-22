import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tejamkor/core/utils/icon_mapper.dart';
import 'package:tejamkor/monthly_limit/widgets/budget_row.dart';
import 'package:tejamkor/monthly_limit/widgets/main_container.dart';
import 'package:tejamkor/statistics/bloc/statistics_bloc.dart';
import 'package:tejamkor/statistics/bloc/statistics_event.dart';
import 'package:tejamkor/statistics/bloc/statistics_state.dart';
import 'package:tejamkor/statistics/data/models/statistics_model.dart';
import 'package:tejamkor/statistics/widgets/category_by_week_month_year.dart';
import 'package:tejamkor/statistics/widgets/daily_average.dart';
import 'package:tejamkor/statistics/widgets/weekly_data_model.dart';
import 'package:tejamkor/statistics/widgets/weekly_statistic.dart';
import 'package:tejamkor/widgets/additional_app_bar.dart';

import '../../widgets/custom_navi_bar.dart';
import '../widgets/category_container.dart';

class StatisticsView extends StatefulWidget {
  const StatisticsView({super.key});

  @override
  State<StatisticsView> createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  int currentIndex = 3;

  @override
  void initState() {
    super.initState();
    context.read<StatisticsBloc>().add(LoadStatistics());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: SimpleAppBar(title: "Statistikalar"),
      body: BlocBuilder<StatisticsBloc, StatisticsState>(
        builder: (context, state) {
          if (state is StatisticsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is StatisticsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<StatisticsBloc>().add(LoadStatistics()),
                      child: const Text("Qayta urinish"),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is StatisticsLoaded) {
            final stats = state.statistics;

            // Ensure exactly 7 days are shown, with today on the right
            final List<String> uzDays = ["Du", "Se", "Chor", "Pay", "Ju", "Sha", "Yak"];
            final now = DateTime.now();
            final List<WeeklyData> chartData = [];

            for (int i = 6; i >= 0; i--) {
              final date = now.subtract(Duration(days: i));
              final dayIndex = date.weekday - 1; // 0-indexed Monday
              final dayName = uzDays[dayIndex];

              // Try to find match in API data
              final apiDay = stats.last7Days.where((d) {
                final dName = d.dayName.toLowerCase();
                return dName.startsWith(dayName.toLowerCase().substring(0, 2));
              }).firstOrNull;

              chartData.add(WeeklyData(
                day: dayName,
                value: apiDay?.amount ?? 0.0,
                currency: stats.currencySymbol,
              ));
            }

            final isNegative = stats.overall.percentageChange.startsWith('-');

            return RefreshIndicator(
              onRefresh: () async {
                context.read<StatisticsBloc>().add(LoadStatistics());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 16.h,
                    horizontal: 24.w,
                  ),
                  child: Column(
                    children: [
                      MainContainer(
                        height: 200.h,
                        width: double.infinity,
                        text: "UMUMIY XARAJAT",
                        sum: stats.overall.totalAmount,
                        currencySymbol: stats.currencySymbol,
                        color_one: const Color(0xff0B0D17),
                        color_two: const Color(0xff0FBC5F),
                        sizeBox1: 4.h,
                        sizeBox2: 16.h,
                        subtitleBadge:
                            "${stats.overall.percentageChange} O'tgan oydan",
                        isPositiveBadge: !isNegative,
                      ),
                      SizedBox(height: 32.h),
                      BudgetRow(
                        title: "Xarajatlar tarixi",
                        buttonTitle: "So'ngi 7 kun",
                        callback: () {},
                      ),
                      SizedBox(height: 16.h),
                      WeeklyChart(data: chartData),
                      SizedBox(height: 32.h),
                      DailyAverage(
                        averageAmount: stats.dailyAverage.averageAmount,
                        dailyLimit: stats.dailyAverage.dailyLimit,
                        currency: stats.currencySymbol,
                      ),
                      SizedBox(height: 32.h),
                      CategoryByWeekMonthYear(
                        currentFilter: stats.filterType,
                        onChanged: (newFilter) {
                          context.read<StatisticsBloc>().add(LoadStatistics(filterType: newFilter));
                        },
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: stats.categories.length,
                        itemBuilder: (context, index) {
                          final cat = stats.categories[index];
                          
                          // Use icon from API if available, else map by name
                          final iconPath = cat.categoryIcon.isNotEmpty 
                              ? (cat.categoryIcon.contains('/') ? cat.categoryIcon : IconMapper.getTejamkorIcon(cat.categoryName))
                              : IconMapper.getTejamkorIcon(cat.categoryName);

                          final catColor = _parseColor(cat.categoryColor);

                          return CategoryContainer(
                            title: cat.categoryName,
                            subtitle: "${cat.transactionCount} tranzaksiya",
                            icon: iconPath,
                            percent: double.tryParse(
                                  cat.percentageChange.replaceAll('%', '').replaceAll('+', ''),
                                ) ?? 0.0,
                            amount: cat.amount,
                            progress: cat.progressPercent > 1
                                ? cat.progressPercent / 100
                                : cat.progressPercent,
                            containerColor: catColor,
                            sliderColor: catColor,
                            percentColor: Colors.transparent, // Handled internally now
                          );
                        },
                      ),
                      SizedBox(height: 120.h),
                    ],
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Color _parseColor(String colorStr) {
    try {
      if (colorStr.isEmpty) return Colors.grey;
      if (colorStr.startsWith('#')) {
        return Color(int.parse(colorStr.replaceFirst('#', '0xff')));
      }
      if (colorStr.startsWith('0x')) {
        return Color(int.parse(colorStr));
      }
      // If it's a raw int string
      return Color(int.tryParse(colorStr) ?? 0xff808080);
    } catch (e) {
      return Colors.grey;
    }
  }
}
