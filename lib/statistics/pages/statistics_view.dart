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

            // Ensure 7 days are always present for the chart
            final weekDays = ["Du", "Se", "Chor", "Pay", "Ju", "Sha", "Yak"];
            final List<WeeklyData> chartData = [];

            for (var dayName in weekDays) {
              final dayData = stats.last7Days.firstWhere(
                (d) => d.dayName.toLowerCase().startsWith(
                  dayName.toLowerCase().substring(0, 2),
                ),
                orElse: () => Last7Days(
                  dayName: dayName,
                  date: "",
                  amount: 0,
                  currency: "",
                ),
              );
              chartData.add(WeeklyData(day: dayName, value: dayData.amount));
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
                        currencySymbol: stats.overall.currency,
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
                        currency: stats.dailyAverage.currency,
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
                          final iconPath = cat.categoryIcon.contains('/')
                              ? cat.categoryIcon
                              : IconMapper.getTejamkorIcon(cat.categoryName);

                          return CategoryContainer(
                            title: cat.categoryName,
                            subtitle: "${cat.transactionCount} tranzaksiya",
                            icon: iconPath,
                            percent:
                                double.tryParse(
                                  cat.percentageChange.replaceAll('%', ''),
                                ) ??
                                0.0,
                            amount: cat.amount,
                            // If backend returns 0-100, divide by 100. CategoryContainer expects 0-1.
                            progress: cat.progressPercent > 1
                                ? cat.progressPercent / 100
                                : cat.progressPercent,
                            containerColor: _parseColor(cat.categoryColor),
                            percentColor: const Color(0xffBA1A1A),
                            sliderColor: _parseColor(cat.categoryColor),
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
      bottomNavigationBar: CustomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
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
