import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/routing/router.dart';
import '../../../categories/blocs/currency/currency_bloc.dart';
import '../../../monthly_limit/widgets/edit_limit_dialog.dart';
import '../../../home/widgets/custom_date_dialog.dart';
import '../../../home/widgets/custom_note_dialog.dart';
import '../blocs/add_transactions_bloc.dart';
import '../blocs/add_transactions_event.dart';
import '../blocs/add_transactions_state.dart';

class AddTransactionView extends StatefulWidget {
  const AddTransactionView({super.key});

  @override
  State<AddTransactionView> createState() => _AddTransactionViewState();
}

class _CategoryItem {
  final String icon;
  final String name;
  final int categoryId;

  _CategoryItem(this.icon, this.name, this.categoryId);
}

class _AddTransactionViewState extends State<AddTransactionView> {
  int _selectedIndex = 2;
  double _amount = 0.0;
  DateTime _selectedDate = DateTime.now();
  String _note = "Add note";
  String _transactionType = "expense";
  int _selectedAccount = 1;

  final List<_CategoryItem> _categories = [
    _CategoryItem("assets/icons/new_car.svg", "Taksi", 1),
    _CategoryItem("assets/icons/new_home.svg", "Ijara", 2),
    _CategoryItem("assets/icons/new_greeting.svg", "Salomallik", 3),
    _CategoryItem("assets/icons/new_food.svg", "Food", 4),
    _CategoryItem("assets/icons/new_shop.svg", "Shop", 5),
    _CategoryItem("assets/icons/new_fun.svg", "Fun", 6),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDark ? Colors.white : Colors.black;
    final Color subtitleColor = isDark
        ? Colors.white54
        : const Color(0xFF7C7777);
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    final currencyState = context.watch<CurrencyBloc>().state;
    final currencySymbol =
        currencyState.response?.currencyDetail?.symbol ?? 'so‘m';

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xffF3F3F3),
      body: BlocListener<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state is TransactionSubmitSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tranzaksiya muvaffaqiyatli qo\'shildi!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
            context.read<TransactionBloc>().add(ResetTransactionStateEvent());
            context.go(Routers.home);
          } else if (state is TransactionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Xatolik: ${state.message}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20.h),
                  _buildAppBar(textColor),
                  SizedBox(height: 32.h),
                  _buildAmountInput(currencySymbol, textColor),
                  SizedBox(height: 32.h),
                  _buildInfoCards(cardColor, textColor, subtitleColor),
                  SizedBox(height: 32.h),
                  _buildCategorySection(textColor),
                  SizedBox(height: 20.h),

                  _buildCategoriesGrid(cardColor, textColor),
                  SizedBox(height: 32.h),
                  _buildWalletCard(cardColor, textColor, subtitleColor, isDark),
                  SizedBox(height: 32.h),
                  _buildSaveButton(),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(Color textColor) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.go(Routers.home),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: textColor,
            size: 24.w,
          ),
        ),
        SizedBox(width: 16.w),
        Text(
          "Tranzaktsiya qo'shish",
          style: TextStyle(
            color: textColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  static const double maxTransactionAmount = 100000000;

  Widget _buildAmountInput(String currencySymbol, Color textColor) {
    String formattedAmount = _formatAmount(_amount);
    return Column(
      children: [
        Center(
          child: GestureDetector(
            onTap: () async {
              final newAmount = await showDialog<double>(
                context: context,
                builder: (context) => EditLimitDialog(
                  currentLimit: _amount,
                  currencySymbol: currencySymbol,
                  maxLimit: maxTransactionAmount, // Pass max limit
                ),
              );
              if (newAmount != null) {
                setState(() {
                  _amount = newAmount;
                });
              }
            },
            child: Text(
              "Mablag'ni kiriting",
              style: TextStyle(
                color: Color(0xff3E494B),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        if (_amount > maxTransactionAmount)
          Container(
            margin: EdgeInsets.only(bottom: 8.h),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              'Maksimal summa ${_formatAmount(maxTransactionAmount)} so‘m',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Text(
                currencySymbol,
                style: const TextStyle(
                  color: Color(0xFF006673),
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              formattedAmount,
              style: TextStyle(
                color: _amount > maxTransactionAmount ? Colors.red : textColor,
                fontSize: 48,
                fontWeight: FontWeight.w700,
                letterSpacing: -1.0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatAmount(double amount) {
    int intAmount = amount.toInt();
    final formatter = NumberFormat('#,###', 'en_US');
    return formatter.format(intAmount);
  }

  Widget _buildInfoCards(
    Color cardColor,
    Color textColor,
    Color subtitleColor,
  ) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final date = await showDialog<DateTime>(
                context: context,
                builder: (context) =>
                    CustomDateDialog(initialDate: _selectedDate),
              );
              if (date != null) setState(() => _selectedDate = date);
            },
            child: _buildInfoCard(
              icon: "assets/icons/new_calendar.svg",
              title: "SANA",
              subtitle: DateFormat('MMM dd, yyyy').format(_selectedDate),
              cardColor: cardColor,
              textColor: textColor,
              subtitleColor: subtitleColor,
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final noteResult = await showDialog<String>(
                context: context,
                builder: (context) => CustomNoteDialog(initialNote: _note),
              );
              if (noteResult != null && noteResult.isNotEmpty) {
                setState(() => _note = noteResult);
              }
            },
            child: _buildInfoCard(
              icon: "assets/icons/new_data.svg",
              title: "NOTE",
              subtitle: _note.isEmpty || _note == "Add note"
                  ? "Add note"
                  : (_note.length > 10
                        ? '${_note.substring(0, 10)}...'
                        : _note),
              cardColor: cardColor,
              textColor: textColor,
              subtitleColor: subtitleColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String icon,
    required String title,
    required String subtitle,
    required Color cardColor,
    required Color textColor,
    required Color subtitleColor,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE8F8F7),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              icon,
              width: 16.w,
              height: 16.w,
              colorFilter: const ColorFilter.mode(
                Color(0xFF058F9D),
                BlendMode.srcIn,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: subtitleColor,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Kategoriyani tanlang",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Text(
            "Barchasini ko'rish",
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF006673),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesGrid(Color cardColor, Color textColor) {
    return Wrap(
      spacing: 16.w,
      runSpacing: 16.h,
      children: List.generate(_categories.length, (index) {
        return _buildCategoryCard(
          item: _categories[index],
          isSelected: _selectedIndex == index,
          cardColor: cardColor,
          textColor: textColor,
          onTap: () => setState(() => _selectedIndex = index),
        );
      }),
    );
  }

  Widget _buildCategoryCard({
    required _CategoryItem item,
    required bool isSelected,
    required Color cardColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final paddingWidth = 48.w;
    final spacingWidth = 32.w;
    final cardWidth = (screenWidth - paddingWidth - spacingWidth) / 3;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: cardWidth,
        padding: EdgeInsets.symmetric(vertical: 24.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF006673) : cardColor,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF058F9D).withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            SvgPicture.asset(
              item.icon,
              width: 28.w,
              height: 28.w,
              colorFilter: ColorFilter.mode(
                isSelected ? Colors.white : const Color(0xFF058F9D),
                BlendMode.srcIn,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              item.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Colors.white : textColor,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletCard(
    Color cardColor,
    Color textColor,
    Color subtitleColor,
    bool isDark,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE8F8F7),
            ),
            child: SvgPicture.asset(
              "assets/icons/new_wallet.svg",
              width: 20.w,
              height: 20.w,
              colorFilter: const ColorFilter.mode(
                Color(0xFF058F9D),
                BlendMode.srcIn,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hamyonlar",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "BALANS: \$4,250.00",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: subtitleColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            child: Icon(Icons.keyboard_arrow_down_rounded, color: textColor),
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.5,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10.h),
                          Center(
                            child: Container(
                              width: 40,
                              height: 4,
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5.h),

                                // 🔹 Title + cancel
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Hisobni tanlang",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),

                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: SvgPicture.asset(
                                        "assets/icons/x.svg",
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.h),
                                _item(
                                  'Naqd pul UZS',
                                  -22222,  // string sum
                                  'UZS',
                                  -24000,
                                  'assets/icons/sum.svg',
                                ),
                                _item(
                                  'Naqd pul USD',
                                  2345,  // string sum
                                  'USD',
                                  24000,
                                  'assets/icons/dollar.svg',
                                ),_item(
                                  'Naqd pul RUB',
                                  4444,  // string sum
                                  'RUB',
                                  24000,
                                  'assets/icons/rubl.svg',
                                ),_item(
                                  'Naqd pul EUR',
                                  3333,  // string sum
                                  'EUR',
                                  24000,
                                  'assets/icons/euro.svg',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: state is TransactionSubmitting
              ? null
              : () {
                  if (_amount <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Iltimos, summani kiriting'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                    return;
                  }

                  context.read<TransactionBloc>().add(
                    SubmitTransactionEvent(
                      type: _transactionType,
                      amount: _amount,
                      note: _note,
                      currency: 0,
                      // UZS uchun 0
                      account: _selectedAccount,
                      category: _categories[_selectedIndex].categoryId,
                      dateTime: _selectedDate,
                    ),
                  );
                },
          child: Container(
            height: 68.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9999),
              gradient: state is TransactionSubmitting
                  ? const LinearGradient(colors: [Colors.grey, Colors.grey])
                  : const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 38, 187, 210),
                        Color.fromARGB(255, 17, 28, 44),
                      ],
                    ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF058F9D).withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: state is TransactionSubmitting
                  ? SizedBox(
                      width: 24.w,
                      height: 24.h,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      "Tranzaktsiyani saqlash",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _item(
      String text,
      double sum,  // double sum o'zgartirildi
      String sumCurrencyType,
      double? sumDifferences,
      String icon,
      ) {
    String formattedSum = _formatNumber(sum);
    bool isNegative = sum < 0;
    String sign = isNegative ? '- ' : '+ ';
    String absoluteSum = formattedSum.replaceFirst('-', '');
    String? formattedDifference;
    if (sumDifferences != null) {
      formattedDifference = _formatNumber(sumDifferences.abs());
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _itemItems(icon),
          SizedBox(width: 16.w),
          Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(width: 18.w),
          Text(
            sign,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          Text(
            absoluteSum,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          SizedBox(width: 4.w),
          // if (sumDifferences != null && sumDifferences != 0)
          //   Padding(
          //     padding: EdgeInsets.only(top: 4.h),
          //     child: Row(
          //       children: [
          //         Icon(
          //           sumDifferences < 0 ? Icons.arrow_downward : Icons.arrow_upward,
          //           size: 12.sp,
          //           color: sumDifferences < 0 ? Colors.red : Colors.green,
          //         ),
          //         SizedBox(width: 4.w),
          //         Text(
          //           _formatNumber(sumDifferences.abs()),
          //           style: TextStyle(
          //             color: sumDifferences < 0 ? Colors.red : Colors.green,
          //             fontWeight: FontWeight.w500,
          //             fontSize: 12.sp,
          //           ),
          //         ),
          //         SizedBox(width: 4.w),
          //         Text(
          //           sumCurrencyType,
          //           style: TextStyle(
          //             color: sumDifferences < 0 ? Colors.red : Colors.green,
          //             fontWeight: FontWeight.w500,
          //             fontSize: 12.sp,
          //           ),
          //         ),
          //         Text(
          //           ' (${sumDifferences < 0 ? 'kamaydi' : 'ko\'paydi'})',
          //           style: TextStyle(
          //             color: Colors.grey,
          //             fontWeight: FontWeight.w400,
          //             fontSize: 11.sp,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
        ],
      ),
    );
  }
  String _formatNumber(double number) {
    final formatter = NumberFormat('#,###', 'en_US');
    return formatter.format(number.toInt());
  }

  Widget _itemItems(String icon) {
    return Container(
      height: 48.h,
      width: 48.w,
      decoration: BoxDecoration(
        color: Color(0xffFCE8F3),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Center(child: SvgPicture.asset(icon)),
    );
  }
}
