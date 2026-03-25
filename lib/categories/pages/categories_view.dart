import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tejamkor/auth/widgets/auth_app_bar.dart';
import 'package:tejamkor/categories/widgets/currency_card.dart';
import 'package:tejamkor/categories/widgets/header.dart';
import 'package:tejamkor/categories/widgets/search_card.dart';
import 'package:tejamkor/widgets/app_button.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  final PageController controller = PageController();
  int currentPage = 0;

  void nextPage() {
    if (currentPage < 2) {
      controller.animateToPage(
        currentPage,
        duration: Duration(seconds: 2),
        curve: Curves.easeInOut,
      );
      setState(() {});
    } else {
      print("Done");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AuthAppBar(),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 36.w),
        child: Column(
          children: [
            Header(currentPage: currentPage),
            SizedBox(height: 31.h),
           SearchCard(),
            SizedBox(height: 31.h),
            AppButton(height: 73.h, weight: 366.w, title: "Keyingi sahifaga o'tish", voidCallback: (){})
          ],
        ),
      ),
    );
  }
}
