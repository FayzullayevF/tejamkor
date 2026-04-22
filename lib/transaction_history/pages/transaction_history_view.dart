import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tejamkor/categories/blocs/currency/currency_bloc.dart';

import 'package:tejamkor/widgets/custom_navi_bar.dart';
import 'package:tejamkor/core/utils/icon_mapper.dart';
import 'package:tejamkor/add_transactions/blocs/add_transactions_bloc.dart';
import 'package:tejamkor/add_transactions/blocs/add_transactions_event.dart';
import 'package:tejamkor/add_transactions/blocs/add_transactions_state.dart';
import 'package:tejamkor/core/data/models/transactions/post_transactions.dart';

import '../widgets/history_search_bar.dart';
import '../widgets/transaction_card.dart';

class TransactionHistoryView extends StatefulWidget {
  const TransactionHistoryView({super.key});

  @override
  State<TransactionHistoryView> createState() => _TransactionHistoryViewState();
}

class _TransactionHistoryViewState extends State<TransactionHistoryView>
    with SingleTickerProviderStateMixin {
  int currentIndex = 1;
  late TabController _tabController;
  String _searchQuery = '';

  // Hisoblangan summalar — tab o'zgarganda top card yangilanishi uchun
  double _expenseTotal = 0;
  double _incomeTotal = 0;

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

  // Tranzaksiyalarni sana bo'yicha guruhlash
  Map<String, List<TransactionModel>> _groupByDate(
    List<TransactionModel> list,
  ) {
    final Map<String, List<TransactionModel>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (final tx in list) {
      final txDate = DateTime(
        tx.dateTime.year,
        tx.dateTime.month,
        tx.dateTime.day,
      );
      String label;
      if (txDate == today) {
        label = 'BUGUN';
      } else if (txDate == yesterday) {
        label = 'KECHA';
      } else {
        label = DateFormat('d MMMM, yyyy').format(tx.dateTime);
      }
      grouped.putIfAbsent(label, () => []).add(tx);
    }
    return grouped;
  }

  // Qidiruv filtri
  List<TransactionModel> _applySearch(List<TransactionModel> list) {
    if (_searchQuery.isEmpty) return list;
    final q = _searchQuery.toLowerCase();
    return list
        .where(
          (tx) =>
              (tx.categoryName ?? '').toLowerCase().contains(q) ||
              tx.note.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xffF3F3F3),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          List<TransactionModel> allList = [];
          bool isLoading = false;
          String? errorMsg;

          if (state is TransactionsLoading) {
            isLoading = true;
          } else if (state is TransactionsLoadSuccess) {
            allList = state.transactions;
          } else if (state is TransactionError) {
            errorMsg = state.message;
          }

          // Type bo'yicha ajratish va qidiruv
          final expenseList = _applySearch(
            allList.where((t) => t.type == 'expense').toList(),
          );
          final incomeList = _applySearch(
            allList.where((t) => t.type == 'income').toList(),
          );

          // Jami summalar
          _expenseTotal = expenseList.fold(
            0.0,
            (s, t) => s + (double.tryParse(t.amount) ?? 0),
          );
          _incomeTotal = incomeList.fold(
            0.0,
            (s, t) => s + (double.tryParse(t.amount) ?? 0),
          );

          return SafeArea(
            bottom: false,
            child: Column(
              children: [
                // ── Top summary card ──
                _buildTopCard(),

                SizedBox(height: 16.h),

                // ── Tab (Xarajat / Daromad) ──
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: _buildTabBar(),
                ),

                SizedBox(height: 16.h),

                // ── Search ──
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: HistorySearchBar(
                    onChanged: (q) => setState(() => _searchQuery = q),
                  ),
                ),

                SizedBox(height: 16.h),

                // ── Tranzaksiya ro'yxati ──
                Expanded(
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF006673),
                          ),
                        )
                      : errorMsg != null
                      ? _buildError(errorMsg)
                      : TabBarView(
                          controller: _tabController,
                          children: [
                            _buildTransactionList(expenseList, isIncome: false),
                            _buildTransactionList(incomeList, isIncome: true),
                          ],
                        ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
      ),
    );
  }

  // ─────────────────── Top card ───────────────────
  Widget _buildTopCard() {
    final isExpTab = _tabController.index == 0;
    final total = isExpTab ? _expenseTotal : _incomeTotal;
    final label = isExpTab ? "Oylik xarajat" : "Oylik daromad";
    final gradColors = isExpTab
        ? [const Color(0xFF261214), const Color(0xFFE53945)]
        : [const Color(0xFF0A2418), const Color(0xFF0FBC5F)];

    // Global valyuta belgisini olamiz
    final currencyState = context.watch<CurrencyBloc>().state;
    final globalSymbol =
        currencyState.response?.currencyDetail?.symbol ?? 'so\'m';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 0),
      height: 130.h,
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
              _formatAmount(total, symbol: globalSymbol),
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────── Tab bar ───────────────────
  Widget _buildTabBar() {
    return Container(
      height: 44.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: const Color(0xFF006673),
          borderRadius: BorderRadius.circular(30.r),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black54,
        labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
        unselectedLabelStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: "Xarajat"),
          Tab(text: "Daromad"),
        ],
      ),
    );
  }

  // ─────────────────── Transaction list ───────────────────
  Widget _buildTransactionList(
    List<TransactionModel> list, {
    required bool isIncome,
  }) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isIncome
                  ? Icons.account_balance_wallet_outlined
                  : Icons.receipt_long_outlined,
              size: 64.w,
              color: Colors.grey.shade300,
            ),
            SizedBox(height: 16.h),
            Text(
              isIncome ? "Daromadlar topilmadi" : "Xarajatlar topilmadi",
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    // Eng yangi sana yuqorida
    final sorted = List<TransactionModel>.from(list)
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

    final grouped = _groupByDate(sorted);
    final sortedKeys = grouped.keys.toList();

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 120.h),
      physics: const BouncingScrollPhysics(),
      itemCount: sortedKeys.length,
      itemBuilder: (context, groupIdx) {
        final dateLabel = sortedKeys[groupIdx];
        final txList = grouped[dateLabel]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateHeader(dateLabel),
            ...txList.map((tx) => _buildTxCard(tx, isIncome)),
          ],
        );
      },
    );
  }

  // ─────────────────── Single transaction card ───────────────────
  // ─────────────────── Single transaction card ───────────────────
  Widget _buildTxCard(TransactionModel tx, bool isIncome) {
    final catName = tx.categoryName ?? '';
    final timeStr = DateFormat('HH:mm').format(tx.dateTime);
    final amt = double.tryParse(tx.amount) ?? 0.0;

    // Model dagi symbol dan foydalanamiz
    final symbol = tx.currencySymbol ?? 'so\'m';
    final amtStr = isIncome
        ? '+${_formatAmount(amt, symbol: symbol)}'
        : '-${_formatAmount(amt, symbol: symbol)}';

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
      iconBgColor: isIncome
          ? const Color(0xffD1FAE5)
          : _getCategoryColor(catName),
      title: displayTitle.isNotEmpty
          ? displayTitle
          : (isIncome ? 'Daromad' : 'Xarajat'),
      subtext: '$catName • $timeStr',
      amount: amtStr,
      isIncome: isIncome,
    );
  }

  // ─────────────────── Helpers ───────────────────
  Color _getCategoryColor(String catName) {
    final lower = catName.toLowerCase();
    if (lower.contains('oziq') || lower.contains('ovqat')) {
      return const Color(0xffFFF4E5);
    } else if (lower.contains('transport') || lower.contains('taksi')) {
      return const Color(0xffE0F7FA);
    } else if (lower.contains('salomatlik') || lower.contains('sport')) {
      return const Color(0xffFCE4EC);
    } else if (lower.contains('sayohat')) {
      return const Color(0xffE8EAF6);
    } else if (lower.contains('kiyinish') || lower.contains('kosmetika')) {
      return const Color(0xffFFF0F5);
    }
    return const Color(0xffE8F5E9);
  }

  Widget _buildDateHeader(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildError(String? msg) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off_rounded, size: 56.w, color: Colors.grey.shade300),
          SizedBox(height: 12.h),
          Text(
            "Ma'lumotlarni yuklab bo'lmadi",
            style: TextStyle(color: Colors.grey.shade500, fontSize: 15.sp),
          ),
          if (msg != null) ...[
            SizedBox(height: 6.h),
            Text(
              msg,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 11.sp),
              textAlign: TextAlign.center,
            ),
          ],
          SizedBox(height: 8.h),
          TextButton(
            onPressed: () =>
                context.read<TransactionBloc>().add(GetAllTransactionsEvent()),
            child: const Text(
              "Qayta urinish",
              style: TextStyle(color: Color(0xFF006673)),
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(double amount, {String symbol = 'so\'m'}) {
    final formatter = NumberFormat('#,###', 'en_US');
    return '${formatter.format(amount.toInt()).replaceAll(',', ' ')} $symbol';
  }
}
