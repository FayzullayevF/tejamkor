import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tejamkor/monthly_limit/widgets/budget_row.dart';
import 'package:tejamkor/monthly_limit/widgets/main_container.dart';
import 'package:tejamkor/widgets/additional_app_bar.dart';

class StatisticsView extends StatelessWidget {
  const StatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: "Statistikalar"),
      body: SingleChildScrollView(
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
            ],
          ),
        ),
      ),
    );
  }
}
