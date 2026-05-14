import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tejamkor/categories/blocs/currency/currency_bloc.dart';
import 'package:tejamkor/categories/blocs/currency/currency_event.dart';
import 'package:tejamkor/categories/blocs/currency/currency_state.dart';
import 'package:tejamkor/categories/data/models/currency_model.dart';

class CurrencyView extends StatefulWidget {
  const CurrencyView({super.key});

  @override
  State<CurrencyView> createState() => _CurrencyViewState();
}

class _CurrencyViewState extends State<CurrencyView> {
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    context.read<CurrencyBloc>().add(CurrencyFetched());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrencyBloc, CurrencyState>(
      builder: (context, state) {
        if (state.status == CurrencyStatus.loading) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFF0ED2C9)));
        }

        if (state.status == CurrencyStatus.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.errorMessage ?? "Xatolik yuz berdi"),
                ElevatedButton(
                  onPressed: () =>
                      context.read<CurrencyBloc>().add(CurrencyFetched()),
                  child: const Text("Qayta urinish"),
                ),
              ],
            ),
          );
        }

        final currencies = state.response?.availableCurrencies ?? [];
        final filteredCurrencies = currencies.where((c) {
          return c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              c.code.toLowerCase().contains(_searchQuery.toLowerCase());
        }).toList();

        return Column(
          children: [
            // Search Bar
            Container(
              height: 73.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3F3),
                borderRadius: BorderRadius.circular(40.r),
                border: Border.all(color: const Color(0xFF7C7777).withOpacity(0.3)),
              ),
              child: TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: "Qidiruv",
                  hintStyle: TextStyle(
                    color: const Color(0xFF7C7777),
                    fontSize: 18.sp,
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: SvgPicture.asset(
                      "assets/icons/search.svg",
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF7C7777),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 20.h),
                ),
              ),
            ),
            SizedBox(height: 32.h),

            // Currency List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: filteredCurrencies.length,
                itemBuilder: (context, index) {
                  final currency = filteredCurrencies[index];
                  final isSelected = state.selectedCurrencyId == currency.id;
                  return _buildCurrencyItem(currency, isSelected);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCurrencyItem(CurrencyModel currency, bool isSelected) {
    String flagAsset = "";
    switch (currency.code) {
      case 'UZS':
        flagAsset = "assets/icons/uzb_flag.svg";
        break;
      case 'RUB':
        flagAsset = "assets/icons/rus_flag.svg";
        break;
      case 'USD':
        flagAsset = "assets/icons/usa_flag.svg";
        break;
      case 'EUR':
        flagAsset = "assets/icons/euro_flag.svg";
        break;
      default:
        flagAsset = "assets/icons/uzb_flag.svg";
    }

    return GestureDetector(
      onTap: () {
        context.read<CurrencyBloc>().add(CurrencySelected(currency.id));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE2F9EB).withOpacity(0.3) : Colors.white,
          borderRadius: BorderRadius.circular(40.r),
          border: Border.all(
            color: isSelected ? const Color(0xFF0FBC5F) : const Color(0xFFF3F3F3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(flagAsset, width: 60.w, height: 60.w),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currency.name,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    currency.code,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF7C7777),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF0FBC5F) : const Color(0xFFD1D1D1),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 16.w,
                        height: 16.w,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0FBC5F),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.check, color: Colors.white, size: 12.w),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
