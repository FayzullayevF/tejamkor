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
import 'package:tejamkor/categories/data/repositories/category_repository.dart';
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
  final Set<int> _selectedIds = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(CategoriesFetched());
    context.read<CurrencyBloc>().add(CurrencyFetched());
  }

  void _toggleSelection(int id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  Future<void> _nextPage() async {
    FocusScope.of(context).unfocus();
    if (_currentIndex < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      if (_selectedIds.isNotEmpty) {
        setState(() {
          _isLoading = true;
        });
        try {
          final repo = context.read<CategoryRepository>();
          await repo.selectDefaultCategories(_selectedIds.toList());
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      }
      if (mounted) context.go(Routers.home);
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
      appBar: AuthAppBar(
        voidCallback: _previousPage,
        backArrowColor: Colors.black,
      ),
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
                  const CategoriesView(), // This is the generic view, wait what is CategoriesView in this context?
                  ExpenseView(selectedIds: _selectedIds, onToggle: _toggleSelection),
                  IncomeView(selectedIds: _selectedIds, onToggle: _toggleSelection),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            _isLoading 
                ? const CircularProgressIndicator(color: Color(0xFF0ED2C9))
                : AppButton(
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
