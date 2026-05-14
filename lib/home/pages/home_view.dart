import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tejamkor/categories/blocs/currency/currency_bloc.dart';
import 'package:tejamkor/core/utils/app_colors.dart';
import '../widgets/home_header.dart';
import '../widgets/home_balance.dart';
import '../widgets/income_expense_row.dart';
import '../widgets/remaining_progress_card.dart';
import '../widgets/chart_card.dart';
import '../widgets/accounts_card.dart';
import '../widgets/currency_rates_card.dart';
import 'settings_view.dart';
import 'package:tejamkor/widgets/custom_navi_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tejamkor/home/bloc/dashboard_bloc.dart';
import 'package:tejamkor/home/data/models/dashboard_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;
  bool _isExpenseSelected = true;

  @override
  void initState() {
    super.initState();
    final currencyCode = context
        .read<CurrencyBloc>()
        .state
        .response
        ?.currencyDetail
        .code;
    context.read<DashboardBloc>().add(
      LoadDashboardEvent(currency: currencyCode),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xffF3F3F3),
      extendBody: true,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.cyanAccent,
                  AppColors.darkNavy,
                  Color(0xffF3F3F3),
                ],
                stops: [0.0, 0.7, 1.0],
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: IndexedStack(
              index: _currentIndex,
              children: [
                _buildHomeDashboard(),
                const Center(child: Text("Tab 1")),
                const Center(child: Text("Tab 2")),
                const SettingsView(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildHomeDashboard() {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DashboardError) {
          return Center(
            child: Text(state.message, style: TextStyle(color: Colors.red)),
          );
        } else if (state is DashboardLoaded) {
          final dashboard = state.dashboard;
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HomeHeader(greeting: dashboard.greeting),
                SizedBox(height: 16.h),
                HomeBalance(
                  balance: dashboard.overallBalance,
                  currency: dashboard.currencySymbol,
                ),
                SizedBox(height: 24.h),
                IncomeExpenseRow(
                  totalIncome: dashboard.totalIncome,
                  totalExpense: dashboard.totalExpense,
                  currency: dashboard.currencySymbol,
                ),
                SizedBox(height: 16.h),
                RemainingProgressCard(
                  tejamkorScore: dashboard.tejamkorScore,
                  moneyRunway: dashboard.moneyRunway,
                ),
                SizedBox(height: 35.h),
                ChartCard(
                  monthlyCategories: dashboard.monthlyCategories,
                  currency: dashboard.currencySymbol,
                  isExpense: _isExpenseSelected,
                  onToggle: (val) {
                    setState(() {
                      _isExpenseSelected = val;
                    });
                  },
                ),
                SizedBox(height: 24.h),
                AccountsCard(accounts: dashboard.accounts),
                SizedBox(height: 24.h),
                CurrencyRatesCard(
                  rates: state.dashboardCurrencies,
                  otherCurrencies: state.otherCurrencies,
                  baseCurrencySymbol: dashboard.currencySymbol,
                  baseCurrencyCode: dashboard.currencyCode,
                  onAddClick: () {
                    context.read<DashboardBloc>().add(
                      FetchOtherCurrenciesEvent(),
                    );
                  },
                  onCurrencySelected: (currency) {
                    context.read<DashboardBloc>().add(
                      AddCurrencyToDashboardEvent(currency),
                    );
                  },
                  onDelete: (currency) {
                    context.read<DashboardBloc>().add(
                      RemoveCurrencyFromDashboardEvent(currency),
                    );
                  },
                ),
                SizedBox(height: 120.h),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
