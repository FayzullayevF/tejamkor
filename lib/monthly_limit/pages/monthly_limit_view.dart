import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tejamkor/categories/data/models/category_model.dart';
import 'package:tejamkor/categories/data/repositories/category_repository.dart';
import 'package:tejamkor/core/utils/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tejamkor/monthly_limit/widgets/budget_row.dart';
import 'package:tejamkor/monthly_limit/widgets/button.dart';
import 'package:tejamkor/monthly_limit/widgets/categories_container.dart';
import 'package:tejamkor/monthly_limit/widgets/main_container.dart';
import 'package:tejamkor/monthly_limit/widgets/total_container.dart';
import 'package:tejamkor/widgets/additional_app_bar.dart';
import 'package:tejamkor/widgets/custom_navi_bar.dart';
import 'package:tejamkor/monthly_limit/widgets/edit_limit_dialog.dart';
import 'package:tejamkor/categories/blocs/currency/currency_bloc.dart';
import 'package:tejamkor/categories/blocs/currency/currency_event.dart';
import 'package:tejamkor/categories/blocs/currency/currency_state.dart';

class MonthlyLimitView extends StatefulWidget {
  const MonthlyLimitView({super.key});

  @override
  State<MonthlyLimitView> createState() => _MonthlyLimitViewState();
}

class _MonthlyLimitViewState extends State<MonthlyLimitView> {
   int currentIndex = 2;
   double _monthlyLimit = 5000.0;
   List<double> _categoryValues = [];
   List<CategoryModel> _userCategories = [];
   bool _isLoading = true;

   @override
   void initState() {
     super.initState();
     _loadSavedData();
     _fetchUserCategories();
     final currencyBloc = context.read<CurrencyBloc>();
     if (currencyBloc.state.status == CurrencyStatus.idle) {
       currencyBloc.add(CurrencyFetched());
     }
   }

   Future<void> _loadSavedData() async {
     final prefs = await SharedPreferences.getInstance();
     setState(() {
       _monthlyLimit = prefs.getDouble('saved_monthly_limit') ?? 5000.0;
     });
   }

   Future<void> _fetchUserCategories() async {
     try {
       final repo = context.read<CategoryRepository>();
       final categories = await repo.getUserCategories();
       final expenses = categories.where((c) => c.type == 'expense').toList();
       if (mounted) {
         final prefs = await SharedPreferences.getInstance();
         List<double> loadedValues = [];
         for (var cat in expenses) {
           loadedValues.add(prefs.getDouble('cat_limit_${cat.id}') ?? 0.0);
         }
         setState(() {
           _userCategories = expenses;
           _categoryValues = loadedValues;
           _isLoading = false;
         });
       }
     } catch (e) {
       if (mounted) {
         setState(() {
           _isLoading = false;
         });
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
       }
     }
   }

  Widget _buildIcon(String iconStr, String categoryName) {
    String path = "car.svg"; 
    switch (categoryName.toLowerCase()) {
      case "oziq-ovqat":
      case "oziq ovqat": path = "basket.svg"; break;
      case "kiyim-kechak":
      case "kiyinish": path = "shirt.svg"; break;
      case "jamoat transporti":
      case "transport": path = "bus.svg"; break;
      case "taxi":
      case "taksi": path = "car.svg"; break;
      case "sayohat":
      case "sayohatlar": path = "flight.svg"; break;
      case "kommunal to'lovlar": path = "payment.svg"; break;
      case "sog'liq":
      case "salomatlik": path = "heart.svg"; break;
      case "ta'lim": path = "statistic.svg"; break;
      case "ijara": path = "home.svg"; break;
      case "internet": path = "wifi.svg"; break;
      case "ovqatlanish": path = "dish.svg"; break;
      case "ko'ngilochar": path = "tv.svg"; break;
      case "sport": path = "sport.svg"; break;
      case "xizmatlar": path = "clock.svg"; break;
      case "jarimalar": path = "warning.svg"; break;
      case "mashina": path = "taxi.svg"; break;
      case "o'tkazmalar": path = "send.svg"; break;
      case "xayriya": path = "full_heart.svg"; break;
      case "bolalar": path = "child.svg"; break;
      case "o'yinlar": path = "play.svg"; break;
      case "kosmetikalar": path = "cosmetic.svg"; break;
      case "yoqilg'i": path = "fuel.svg"; break;
      default: path = "basket.svg";
    }
    return SvgPicture.asset("assets/icons/$path");
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Color(0xffE5E9EA),
        body: Center(child: CircularProgressIndicator(color: AppColors.cyanAccent)),
      );
    }

    final currencyState = context.watch<CurrencyBloc>().state;
    final currencySymbol = currencyState.response?.currencyDetail?.symbol ?? '\$';

    double totalAllocated = _categoryValues.fold(0, (sum, item) => sum + item);
    double remainingLimit = _monthlyLimit - totalAllocated;

    return Scaffold(
      extendBody: true,
      appBar: SimpleAppBar(title: "Oylik limit"),
      backgroundColor: Color(0xffE5E9EA),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                MainContainer(
                  height: 205.h,
                  width: double.infinity,
                  text: "Umumiy limit maqsadi",
                  sum: _monthlyLimit,
                  color_one: AppColors.darkNavy,
                  color_two: AppColors.cyanAccent,
                  sizeBox1: 8,
                  sizeBox2: 24,
                  currencySymbol: currencySymbol,
                  onTap: () async {
                    final newLimit = await showDialog<double>(
                      context: context,
                      builder: (context) => EditLimitDialog(currentLimit: _monthlyLimit, currencySymbol: currencySymbol),
                    );
                    if (newLimit != null && newLimit > 0) {
                      setState(() {
                        _monthlyLimit = newLimit;
                      });
                    }
                  },
                ),
                SizedBox(height: 32.h),
                BudgetRow(title: "Kategoriya bo'yicha byujet",buttonTitle: "Yana qo'shish",callback: (){},),
                SizedBox(height: 32.h),
                _userCategories.isEmpty 
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Text("Hozircha hech qanday kategoriya qo'shilmagan", style: TextStyle(fontSize: 16)),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _userCategories.length,
                      separatorBuilder: (context, index) => SizedBox(height: 16.h),
                      itemBuilder: (context, index) {
                        bool isDisabled = _categoryValues[index] <= 0 && remainingLimit <= 0;
                        final cat = _userCategories[index];

                        return CategoriesContainer(
                          height: 145.h,
                          icon: _buildIcon(cat.icon, cat.name),
                          title: cat.name,
                          subtitle: "Oylik xarajatlar", // Using static string as there's no subtitle in the model
                          value: _categoryValues[index],
                          maxLimit: _monthlyLimit,
                          currencySymbol: currencySymbol,
                          onChanged: isDisabled ? null : (val) {
                            double currentVal = _categoryValues[index];
                            double maxAllowed = currentVal + (remainingLimit > 0 ? remainingLimit : 0);
                            
                            double finalVal = val;
                            if (val > maxAllowed) {
                              finalVal = maxAllowed;
                            }
                            
                            setState(() {
                              _categoryValues[index] = finalVal;
                            });
                          },
                        );
                      },
                    ),
                SizedBox(height: 32.h,),
                TotalContainer(
                  allocated: totalAllocated,
                  remaining: remainingLimit > 0 ? remainingLimit : 0,
                  currencySymbol: currencySymbol,
                ),
                SizedBox(height: 24.h,),
                LimitButton(
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setDouble('saved_monthly_limit', _monthlyLimit);
                    for (int i = 0; i < _userCategories.length; i++) {
                      await prefs.setDouble('cat_limit_${_userCategories[i].id}', _categoryValues[i]);
                    }
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Oylik limit va kategoriyalar saqlandi"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                ),
                SizedBox(height: 120.h)
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
