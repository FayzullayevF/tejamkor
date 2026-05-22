// lib/transaction_history/pages/transaction_history_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:tejamkor/add_transactions/blocs/add_transactions_bloc.dart';
import 'package:tejamkor/add_transactions/blocs/add_transactions_event.dart';
import 'package:tejamkor/add_transactions/blocs/add_transactions_state.dart';
import 'package:tejamkor/core/data/models/transactions/post_transactions.dart';
import 'package:tejamkor/core/utils/icon_mapper.dart';
import 'package:tejamkor/transaction_history/widgets/transaction_card.dart';

import 'package:tejamkor/widgets/custom_navi_bar.dart';

class TransactionHistoryView extends StatefulWidget {
  const TransactionHistoryView({super.key});

  @override
  State<TransactionHistoryView> createState() => _TransactionHistoryViewState();
}

class _TransactionHistoryViewState extends State<TransactionHistoryView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  TransactionSummary? _currentSummary;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
    context.read<TransactionBloc>().add(GetAllTransactionsEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Grouping transactions by date
  Map<String, List<TransactionModel>> _groupByDate(List<TransactionModel> list) {
    final Map<String, List<TransactionModel>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var tx in list) {
      final txDate = DateTime(tx.dateTime.year, tx.dateTime.month, tx.dateTime.day);
      String key;
      if (txDate == today) {
        key = "Bugun";
      } else if (txDate == yesterday) {
        key = "Kecha";
      } else {
        try {
          key = DateFormat('d MMMM, y', 'uz').format(tx.dateTime);
        } catch (e) {
          key = DateFormat('d MMMM, y').format(tx.dateTime);
        }
      }

      if (grouped[key] == null) grouped[key] = [];
      grouped[key]!.add(tx);
    }
    return grouped;
  }

  List<TransactionModel> _applySearch(List<TransactionModel> list) {
    if (_searchQuery.isEmpty) return list;
    return list.where((t) {
      final note = t.note.toLowerCase();
      final cat = t.categoryName.toLowerCase();
      return note.contains(_searchQuery.toLowerCase()) || 
             cat.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F3F3),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          bool isLoading = false;
          List<TransactionModel> allResults = [];
          TransactionSummary? summary;
          String? errorMsg;

          if (state is TransactionsLoading) {
            isLoading = true;
          } else if (state is TransactionsLoadSuccess) {
            allResults = List<TransactionModel>.from(state.response.results);
            // Sort by date descending (newest first)
            allResults.sort((a, b) => b.dateTime.compareTo(a.dateTime));
            summary = state.response.summary;
          } else if (state is TransactionError) {
            errorMsg = state.message;
          }

          final expenseList = _applySearch(allResults.where((t) => t.type.toLowerCase() == 'expense').toList());
          final incomeList = _applySearch(allResults.where((t) => t.type.toLowerCase() == 'income').toList());

          return SafeArea(
            bottom: false,
            child: Column(
              children: [
                // ── Top summary card ──
                _buildTopCard(summary: summary),

                SizedBox(height: 16.h),

                // ── Search & Filter ──
                _buildSearchAndTabs(),

                // ── Transaction List ──
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator(color: Color(0xFF0ED2C9)))
                      : errorMsg != null
                          ? _buildError(errorMsg)
                          : RefreshIndicator(
                              onRefresh: () async {
                                context.read<TransactionBloc>().add(GetAllTransactionsEvent());
                                // Wait for the state to change from Loading back to Success
                                await context.read<TransactionBloc>().stream.firstWhere(
                                  (state) => state is TransactionsLoadSuccess || state is TransactionError,
                                );
                              },
                              child: _buildTransactionList(
                                _tabController.index == 0 ? expenseList : incomeList,
                                _tabController.index == 1,
                              ),
                            ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ─────────────────── Top card ───────────────────
  Widget _buildTopCard({TransactionSummary? summary}) {
    _currentSummary = summary; // Store for use in cards
    final isExpTab = _tabController.index == 0;
    
    // Backend'dan kelgan tayyor summary ma'lumotlarini ishlatamiz
    final String amountStr = isExpTab 
        ? (summary?.totalExpense ?? "0") 
        : (summary?.totalIncome ?? "0");
    
    final String percentStr = isExpTab
        ? (summary?.expenseChangePercent ?? "0")
        : (summary?.incomeChangePercent ?? "0");

    final label = isExpTab ? "Jami xarajat" : "Jami daromad";
    final gradColors = isExpTab
        ? [const Color(0xFF261214), const Color(0xFFE53945)]
        : [const Color(0xFF0A2418), const Color(0xFF0FBC5F)];

    final double percentVal = double.tryParse(percentStr) ?? 0.0;
    final bool isIncrease = percentVal > 0;
    final String symbol = summary?.currencySymbol ?? "so'm";

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 0),
      height: 160.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: LinearGradient(
          colors: gradColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.white70, fontSize: 13.sp),
          ),
          SizedBox(height: 6.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "$amountStr $symbol",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          // Percentage badge from backend
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isIncrease ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                  color: Colors.white,
                  size: 14.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  "${percentVal.abs().toStringAsFixed(1)}% o'tgan oydan ${isIncrease ? "ko'proq" : "kamroq"}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────── Search & Tabs ───────────────────
  Widget _buildSearchAndTabs() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          // Search Field
          Container(
            height: 50.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: "Qidirish...",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          // Tab Bar
          _buildTabBar(),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 50.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFFECECEC),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.black,
        unselectedLabelColor: const Color(0xFF7C7777),
        labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
        unselectedLabelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: "Xarajat"),
          Tab(text: "Daromad"),
        ],
      ),
    );
  }

  // ─────────────────── Transaction List ───────────────────
  Widget _buildTransactionList(List<TransactionModel> list, bool isIncome) {
    if (list.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: 400.h,
          child: Center(
            child: Text(
              isIncome ? "Daromadlar topilmadi" : "Xarajatlar topilmadi",
              style: TextStyle(color: Colors.grey, fontSize: 16.sp),
            ),
          ),
        ),
      );
    }

    final grouped = _groupByDate(list);
    final sortedKeys = grouped.keys.toList();

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
      itemCount: sortedKeys.length,
      itemBuilder: (context, index) {
        final dateKey = sortedKeys[index];
        final txs = grouped[dateKey]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Text(
                dateKey,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...txs.map((tx) => _buildTxCard(tx, isIncome)),
          ],
        );
      },
    );
  }

  Widget _buildTxCard(TransactionModel tx, bool isIncome) {
    final catName = tx.categoryName;
    final timeStr = DateFormat('HH:mm').format(tx.dateTime);
    final symbol = tx.currencySymbol ?? (_currentSummary?.currencySymbol ?? "so'm");
    final amtStr = isIncome ? "+${tx.amount} $symbol" : "-${tx.amount} $symbol";
    final displayTitle = tx.note.isNotEmpty ? tx.note : catName;

    return TransactionCard(
      iconWidget: SvgPicture.asset(
        IconMapper.getTejamkorIcon(catName),
        width: 24.w,
        height: 24.w,
        colorFilter: ColorFilter.mode(
          isIncome ? const Color(0xFF0FBC5F) : const Color(0xFF006673),
          BlendMode.srcIn,
        ),
      ),
      iconBgColor: isIncome ? const Color(0xffD1FAE5) : _getCategoryColor(catName),
      title: displayTitle.isNotEmpty ? displayTitle : (isIncome ? 'Daromad' : 'Xarajat'),
      subtext: '$catName • $timeStr',
      amount: amtStr,
      isIncome: isIncome,
    );
  }

  Color _getCategoryColor(String name) {
    // Add logic if specific colors are needed per category
    return const Color(0xFFF1F5F9);
  }

  Widget _buildError(String msg) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          SizedBox(height: 16.h),
          Text(msg, textAlign: TextAlign.center),
          TextButton(
            onPressed: () => context.read<TransactionBloc>().add(GetAllTransactionsEvent()),
            child: const Text("Qayta urinish"),
          ),
        ],
      ),
    );
  }
}
