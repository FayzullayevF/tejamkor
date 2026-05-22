import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tejamkor/core/routing/router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tejamkor/auth/widgets/auth_app_bar.dart';
import 'package:tejamkor/categories/blocs/currency/currency_bloc.dart';
import 'package:tejamkor/categories/blocs/currency/currency_event.dart';
import 'package:tejamkor/categories/blocs/currency/currency_state.dart';
import 'package:tejamkor/categories/blocs/category/category_bloc.dart';
import 'package:tejamkor/categories/blocs/category/category_event.dart';

import 'package:tejamkor/widgets/app_button.dart';
import 'package:tejamkor/categories/widgets/header.dart';
import 'package:tejamkor/categories/data/repositories/category_repository.dart';
import 'package:tejamkor/categories/data/repositories/currency_repository.dart';

import 'package:tejamkor/widgets/app_snackbar.dart';

import 'package:tejamkor/categories/pages/currency_view.dart';
import 'package:tejamkor/categories/pages/expense_view.dart';
import 'package:tejamkor/categories/pages/income_view.dart';

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
    if (_currentIndex == 0) {
      final currencyState = context.read<CurrencyBloc>().state;
      if (currencyState.selectedCurrencyId != null) {
        setState(() => _isLoading = true);
        try {
          // We can use the repository directly to ensure it completes before moving on
          final repo = context.read<CurrencyRepository>();
          await repo.updateUserCurrency(currencyState.selectedCurrencyId!);
          
          // Also update the bloc state so other components know
          if (mounted) {
            context.read<CurrencyBloc>().add(CurrencyFetched());
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        } catch (e) {
          if (mounted) {
            AppSnackbar.showError(context, "Valyutani saqlashda xatolik: $e");
          }
        } finally {
          if (mounted) setState(() => _isLoading = false);
        }
      } else {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else if (_currentIndex < 2) {
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
          if (mounted) context.go(Routers.home);
        } catch (e) {
          AppSnackbar.showError(
            context,
            e.toString().replaceAll("Exception: ", ""),
          );
        } finally {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        }
      } else {
        if (mounted) context.go(Routers.home);
      }
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Header(currentPage: _currentIndex),
                SizedBox(height: 24.h),
                SizedBox(
                  height: 450.h, // Give the PageView a fixed height to work with scroll
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      if (_currentIndex != index) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            setState(() {
                              _currentIndex = index;
                            });
                          }
                        });
                      }
                    },
                    children: [
                      const CurrencyView(),
                      ExpenseView(
                        selectedIds: _selectedIds,
                        onToggle: _toggleSelection,
                      ),
                      IncomeView(
                        selectedIds: _selectedIds,
                        onToggle: _toggleSelection,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
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
        ),
      ),
    );
  }
}
