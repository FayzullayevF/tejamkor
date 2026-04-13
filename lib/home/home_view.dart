import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tejamkor/core/utils/app_colors.dart';
import 'widgets/home_header.dart';
import 'widgets/home_balance.dart';
import 'widgets/income_expense_row.dart';
import 'widgets/remaining_progress_card.dart';
import 'widgets/chart_card.dart';
import 'widgets/accounts_card.dart';
import 'widgets/currency_rates_card.dart';
import 'pages/settings_view.dart';
import 'package:tejamkor/widgets/custom_navi_bar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

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
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HomeHeader(),
          SizedBox(height: 16.h),
          HomeBalance(),
          SizedBox(height: 24.h),
          IncomeExpenseRow(),
          SizedBox(height: 16.h),
          RemainingProgressCard(),
          SizedBox(height: 35.h),
          ChartCard(),
          SizedBox(height: 24.h),
          AccountsCard(),
          SizedBox(height: 24.h),
          CurrencyRatesCard(),
          SizedBox(height: 120.h),
        ],
      ),
    );
  }
}
