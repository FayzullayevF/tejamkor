import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tejamkor/categories/data/models/category_model.dart';
import 'package:tejamkor/categories/data/repositories/category_repository.dart';

class TransactionCategoriesView extends StatefulWidget {
  const TransactionCategoriesView({super.key});

  @override
  State<TransactionCategoriesView> createState() =>
      _TransactionCategoriesViewState();
}

class _TransactionCategoriesViewState extends State<TransactionCategoriesView> {
  List<CategoryModel> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final repo = context.read<CategoryRepository>();
      final categories = await repo
          .getCategories(); // api/categories/default as requested
      if (mounted) {
        setState(() {
          _categories = categories;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Widget _buildIcon(String iconStr, String categoryName, {Color? color}) {
    String path = "car.svg";
    switch (categoryName.toLowerCase()) {
      case "oziq-ovqat":
      case "oziq ovqat":
        path = "basket.svg";
        break;
      case "kiyim-kechak":
      case "kiyinish":
        path = "shirt.svg";
        break;
      case "jamoat transporti":
      case "transport":
        path = "bus.svg";
        break;
      case "taxi":
      case "taksi":
        path = "car.svg";
        break;
      case "sayohat":
      case "sayohatlar":
        path = "flight.svg";
        break;
      case "kommunal to'lovlar":
        path = "payment.svg";
        break;
      case "sog'liq":
      case "salomatlik":
        path = "heart.svg";
        break;
      case "ta'lim":
        path = "statistic.svg";
        break;
      case "ijara":
        path = "home.svg";
        break;
      case "internet":
        path = "wifi.svg";
        break;
      case "ovqatlanish":
        path = "dish.svg";
        break;
      case "ko'ngilochar":
        path = "tv.svg";
        break;
      case "sport":
        path = "sport.svg";
        break;
      case "xizmatlar":
        path = "clock.svg";
        break;
      case "jarimalar":
        path = "warning.svg";
        break;
      case "mashina":
        path = "taxi.svg";
        break;
      case "o'tkazmalar":
        path = "send.svg";
        break;
      case "xayriya":
        path = "full_heart.svg";
        break;
      case "bolalar":
        path = "child.svg";
        break;
      case "o'yinlar":
        path = "play.svg";
        break;
      case "kosmetikalar":
        path = "cosmetic.svg";
        break;
      case "yoqilg'i":
        path = "fuel.svg";
        break;
      default:
        path = "basket.svg";
    }
    return SvgPicture.asset(
      "assets/icons/$path",
      width: 28.w,
      height: 28.w,
      colorFilter: color != null
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xffF3F3F3),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: textColor,
            size: 24.w,
          ),
        ),
        title: Text(
          "Barcha categoriyalar",
          style: TextStyle(
            color: textColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(0, 252, 252, 252),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF006673)),
            )
          : GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              physics: const BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 0.9,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final item = _categories[index];
                return GestureDetector(
                  onTap: () {
                    context.pop(item);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildIcon(
                          item.icon,
                          item.name,
                          color: const Color(0xFF058F9D),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          item.name,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
