import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tejamkor/monthly_limit/widgets/budget_row.dart';
import 'package:tejamkor/monthly_limit/widgets/main_container.dart';
import 'package:tejamkor/statistics/widgets/category_by_week_month_year.dart';
import 'package:tejamkor/statistics/widgets/daily_average.dart';
import 'package:tejamkor/statistics/widgets/weekly_data.dart';
import 'package:tejamkor/statistics/widgets/weekly_statistic.dart';
import 'package:tejamkor/widgets/additional_app_bar.dart';

import '../../widgets/custom_navi_bar.dart';
import '../widgets/category_container.dart';

class StatisticsView extends StatefulWidget {
  StatisticsView({super.key});

  @override
  State<StatisticsView> createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  int currentIndex = 1;
  final List items = [
    CategoryContainer(
      title: "Ovqat & Ichimliklar",
      subtitle: "42 tranzaksiya",
      icon: "assets/icons/color_dish.svg",
      percent: 4.3,
      amount: 1120,
      progress: 50,
      containerColor: Color(0xffFFF4E5),
      percentColor: Color(0xffBA1A1A),
      sliderColor: Color(0xffFF9800),
    ),
    CategoryContainer(
      title: "Transport",
      subtitle: "18 tranzaksiya",
      icon: "assets/icons/color_car.svg",
      percent: 15.8,
      amount: 450,
      progress: 20,
      containerColor: Color(0xffE0F7FA),
      percentColor: Color(0xff4CAF50),
      sliderColor: Color(0xff00BCD4),
    ),
    CategoryContainer(
      title: "Ijara & Komunal",
      subtitle: "5 tranzaksiya",
      icon: "assets/icons/color_home.svg",
      percent: 4.3,
      amount: 1180,
      progress: 65,
      containerColor: Color(0xffE8EAF6),
      percentColor: Color(0xff3E494B),
      sliderColor: Color(0xff3F51B5),
    ),
    CategoryContainer(
      title: "Shopping",
      subtitle: "12 tranzaksiya",
      icon: "assets/icons/color_dish.svg",
      percent: 4.3,
      amount: 915.25,
      progress: 80,
      containerColor: Color(0xffFCE4EC),
      percentColor: Color(0xff4CAF50),
      sliderColor: Color(0xffE91E63),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: "Statistikalar"),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
              child: Column(
                children: [
                  MainContainer(
                    height: 200.h,
                    width: double.infinity,
                    text: "UMUMIY XARAJAT",
                    sum: 4285.5,
                    color_one: Color(0xff0B0D17),
                    color_two: Color(0xff0FBC5F),
                    sizeBox1: 4.h,
                    sizeBox2: 16.h,
                  ),
                  SizedBox(height: 32.h),
                  BudgetRow(
                    title: "Xarajatlar tarixi",
                    buttonTitle: "So'ngi 7 kun",
                    callback: () {},
                  ),
                  SizedBox(height: 16.h),
                  WeeklyChart(data: fakeData),
                  SizedBox(height: 32.h),
                  DailyAverage(),
                  SizedBox(height: 32.h),
                  CategoryByWeekMonthYear(),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return items[index];
                    },
                  ),
                  SizedBox(height: 120.h),
                ],
              ),
            ),
          ),
          CustomNavBar(
            currentIndex: currentIndex,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ],
      ),
    );
  }
}
