import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tejamkor/core/routing/router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tejamkor/auth/widgets/auth_app_bar.dart';
import 'package:tejamkor/categories/blocs/category/category_bloc.dart';
import 'package:tejamkor/categories/blocs/category/category_event.dart';
import 'package:tejamkor/categories/blocs/currency/currency_bloc.dart';
import 'package:tejamkor/categories/blocs/currency/currency_event.dart';
import 'package:tejamkor/widgets/app_button.dart';
import 'package:tejamkor/categories/widgets/header.dart';
import 'currency_view.dart';
import 'categories_view.dart';
import 'income_view.dart';

class AllCategoriesView extends StatefulWidget {
  const AllCategoriesView({super.key});

  @override
  State<AllCategoriesView> createState() => _AllCategoriesViewState();
}

class _AllCategoriesViewState extends State<AllCategoriesView> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(CategoriesFetched());
    context.read<CurrencyBloc>().add(CurrencyFetched());
  }

  void _nextPage() {
    FocusScope.of(context).unfocus();
    if (_currentIndex < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go(Routers.home);
    }
  }

  void _previousPage() {
    FocusScope.of(context).unfocus();
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go(Routers.login);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AuthAppBar(voidCallback: _previousPage),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        child: Column(
          children: [
            Header(currentPage: _currentIndex),
            SizedBox(height: 24.h),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: [
                  const CategoriesView(),
                  const ExpenseView(),
                  const IncomeView(),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            AppButton(
              height: 73.h,
              weight: double.infinity,
              title: "Keyingi sahifaga o'tish",
              voidCallback: _nextPage,
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
