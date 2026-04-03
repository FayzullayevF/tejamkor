import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tejamkor/core/utils/app_colors.dart';
import 'package:tejamkor/monthly_limit/widgets/budget_row.dart';
import 'package:tejamkor/monthly_limit/widgets/button.dart';
import 'package:tejamkor/monthly_limit/widgets/categories_container.dart';
import 'package:tejamkor/monthly_limit/widgets/main_container.dart';
import 'package:tejamkor/monthly_limit/widgets/total_container.dart';
import 'package:tejamkor/widgets/additional_app_bar.dart';

class MonthlyLimitView extends StatelessWidget {
   MonthlyLimitView({super.key});
   final List items = [CategoriesContainer(
     height: 145.h,
     image: "assets/icons/c_dish.svg",
     title: "Oziq & Ovqat",
     subtitle: "Mahsulotlar & Ovqatlanish",
   ),
     CategoriesContainer(
       height: 145.h,
       image: "assets/icons/c_car.svg",
       title: "Transport",
       subtitle: "Yoqilg'i,Metro,Yandex",
     ),
     CategoriesContainer(
       height: 145.h,
       image: "assets/icons/c_home.svg",
       title: "Ijara",
       subtitle: "Oylik ijara haqqi",
     ),
     CategoriesContainer(
       height: 145.h,
       image: "assets/icons/c_shop.svg",
       title: "Shoping",
       subtitle: "Kiyimlar & Texnika",
     ),];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: "Oylik limit"),
      backgroundColor: Color(0xffE5E9EA),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                MainContainer(
                  height: 205.h,
                  width: double.infinity,
                  text: "Umumiy limit maqsadi",
                  sum: 5000,
                  color_one: AppColors.darkNavy,
                  color_two: AppColors.cyanAccent,
                  sizeBox1: 8,
                  sizeBox2: 24,
                ),
                SizedBox(height: 32.h),
                BudgetRow(title: "Kategoriya bo'yicha byujet",buttonTitle: "Yana qo'shish",callback: (){},),
                SizedBox(height: 32.h),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (context, index) => SizedBox(height: 16.h),
                  itemBuilder: (context, index) => items[index],
                ),
                SizedBox(height: 32.h,),
                TotalContainer(),
                SizedBox(height: 24.h,),
                LimitButton()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
