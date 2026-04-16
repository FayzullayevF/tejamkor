import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tejamkor/core/routing/router.dart';
import 'package:tejamkor/categories/blocs/currency/currency_bloc.dart';
import 'package:tejamkor/core/routing/router.dart';
import '../../monthly_limit/widgets/edit_limit_dialog.dart';
import '../widgets/custom_date_dialog.dart';
import '../widgets/custom_note_dialog.dart';

class AddTransactionView extends StatefulWidget {
  const AddTransactionView({super.key});

  @override
  State<AddTransactionView> createState() => _AddTransactionViewState();
}

class _CategoryItem {
  final String icon;
  final String name;

  _CategoryItem(this.icon, this.name);
}

class _AddTransactionViewState extends State<AddTransactionView> {
  int _selectedIndex = 2; // Default to 'Salomallik' as in the design
  double _amount = 0.0;
  DateTime _selectedDate = DateTime.now();
  String _note = "Add note";

  final List<_CategoryItem> _categories = [
    _CategoryItem("assets/icons/new_car.svg", "Taksi"),
    _CategoryItem("assets/icons/new_home.svg", "Ijara"),
    _CategoryItem("assets/icons/new_greeting.svg", "Salomallik"),
    _CategoryItem("assets/icons/new_food.svg", "Food"),
    _CategoryItem("assets/icons/new_shop.svg", "Shop"),
    _CategoryItem("assets/icons/new_fun.svg", "Fun"),
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
        currencyState.response?.currencyDetail?.symbol ?? '\$';

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xffF3F3F3),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20.h),
                // App Bar
                Row(
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
                ),
                SizedBox(height: 32.h),
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      final newAmount = await showDialog<double>(
                        context: context,
                        builder: (context) => EditLimitDialog(
                          currentLimit: _amount,
                          currencySymbol: currencySymbol,
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
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 6.h),
                      child: Text(
                        currencySymbol,
                        style: TextStyle(
                          color: const Color(0xFF006673),
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      _amount.toStringAsFixed(0),
                      style: TextStyle(
                        color: textColor,
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32.h),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final date = await showDialog<DateTime>(
                            context: context,
                            builder: (context) =>
                                CustomDateDialog(initialDate: _selectedDate),
                          );
                          if (date != null) {
                            setState(() {
                              _selectedDate = date;
                            });
                          }
                        },
                        child: _buildInfoCard(
                          icon: "assets/icons/new_calendar.svg",
                          title: "SANA",
                          subtitle: DateFormat(
                            'MMM dd, yyyy',
                          ).format(_selectedDate),
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
                            builder: (context) =>
                                CustomNoteDialog(initialNote: _note),
                          );
                          if (noteResult != null && noteResult.isNotEmpty) {
                            setState(() {
                              _note = noteResult;
                            });
                          }
                        },
                        child: _buildInfoCard(
                          icon: "assets/icons/new_data.svg",
                          title: "NOTE",
                          subtitle: _note.isEmpty
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
                ),
                SizedBox(height: 32.h),
                Row(
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
                ),
                SizedBox(height: 20.h),
                Wrap(
                  spacing: 16.w,
                  runSpacing: 16.h,
                  children: List.generate(_categories.length, (index) {
                    return _buildCategoryCard(
                      item: _categories[index],
                      isSelected: _selectedIndex == index,
                      cardColor: cardColor,
                      textColor: textColor,
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                    );
                  }),
                ),
                SizedBox(height: 32.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
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
                          color: isDark
                              ? const Color(0xFF2C2C2C)
                              : const Color(0xFFE8F8F7),
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
                              "Shaxsiy hamyon",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "BALANS: \$4,250.00",
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: subtitleColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down_rounded, color: textColor),
                    ],
                  ),
                ),
                SizedBox(height: 32.h),

                // Save Button
                GestureDetector(
                  onTap: () {
                    // Save action
                  },
                  child: Container(
                    height: 68.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9999),
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 38, 187, 210),
                          Color.fromARGB(255, 17, 28, 44),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        // stops: [0.3, 1],
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
                      child: Text(
                        "Tranzaktsiyani saqlash",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
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

  Widget _buildCategoryCard({
    required _CategoryItem item,
    required bool isSelected,
    required Color cardColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final paddingWidth = 48.w; // 24 * 2
    final spacingWidth = 32.w; // 16 * 2
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
}
