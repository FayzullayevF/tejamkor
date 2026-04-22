import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tejamkor/categories/widgets/currency_card.dart';
import 'package:tejamkor/categories/widgets/search_card.dart';
import 'package:tejamkor/categories/blocs/currency/currency_bloc.dart';
import 'package:tejamkor/categories/blocs/currency/currency_event.dart';
import 'package:tejamkor/categories/blocs/currency/currency_state.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key, this.onNext});

  final VoidCallback? onNext;

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  String? selectedCurrencyCode;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CurrencyBloc, CurrencyState>(
      listener: (context, state) {
        if (state.status == CurrencyStatus.updated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Valyuta muvaffaqiyatli saqlandi!"),
              backgroundColor: Colors.green,
            ),
          );
        }
        if (state.status == CurrencyStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Xatolik: ${state.errorMessage}"),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.status == CurrencyStatus.loading ||
            state.status == CurrencyStatus.idle) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF0ED2C9)),
          );
        }

        final currencies = state.response?.availableCurrencies ?? [];

        if (state.status == CurrencyStatus.error && currencies.isEmpty) {
          return Center(child: Text("Xatolik: ${state.errorMessage}"));
        }

        // Agar tanlangan valyuta API dan kelgan bo'lsa va local state hali tanlanmagan bo'lsa
        if (selectedCurrencyCode == null &&
            state.response?.currencyDetail != null) {
          selectedCurrencyCode = state.response!.currencyDetail!.code;
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SearchCard(),
              SizedBox(height: 20.h),
              if (currencies.isEmpty)
                const Center(child: Text("Hech qanday valyuta topilmadi"))
              else
                ...currencies.map((currency) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 15.h),
                    child: CurrencyCard(
                      title: currency.name.isNotEmpty
                          ? currency.name
                          : currency.code,
                      subtitle: currency.code,
                      flagSvg: _getFlagSvg(currency.code),
                      activeColor: _getActiveColor(currency.code),
                      activeBgColor: _getActiveBgColor(currency.code),
                      isSelected: selectedCurrencyCode == currency.code,
                      onTap: () {
                        setState(() {
                          selectedCurrencyCode = currency.code;
                        });
                        context.read<CurrencyBloc>().add(
                          CurrencyUpdated(currency),
                        );
                      },
                    ),
                  );
                }),
              SizedBox(height: 25.h),
            ],
          ),
        );
      },
    );
  }

  String _getFlagSvg(String code) {
    switch (code) {
      case "UZS":
        return "assets/icons/uzb_flag.svg";
      case "RUB":
        return "assets/icons/rus_flag.svg";
      case "USD":
        return "assets/icons/usa_flag.svg";
      case "EUR":
        return "assets/icons/euro_flag.svg";
      default:
        return "assets/icons/uzb_flag.svg"; // fallback
    }
  }

  Color _getActiveColor(String code) {
    switch (code) {
      case "UZS":
        return const Color(0xFF0ED2C9); // Yashilroq
      case "RUB":
        return const Color(0xffE91E63); // Pushti
      case "USD":
        return const Color(0xff2196F3); // Ko'k
      case "EUR":
        return const Color(0xff9C27B0); // Binafsha
      default:
        return const Color(0xFF0ED2C9);
    }
  }

  Color _getActiveBgColor(String code) {
    switch (code) {
      case "UZS":
        return const Color(0xFF0ED2C9).withValues(alpha: 0.1);
      case "RUB":
        return const Color(0xffFCE4EC);
      case "USD":
        return const Color(0xffE3F2FD);
      case "EUR":
        return const Color(0xffF3E5F5);
      default:
        return const Color(0xFF0ED2C9).withValues(alpha: 0.1);
    }
  }
}
