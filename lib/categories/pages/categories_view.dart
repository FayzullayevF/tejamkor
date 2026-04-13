import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tejamkor/categories/blocs/category/category_bloc.dart';
import 'package:tejamkor/categories/blocs/category/category_state.dart';
import 'package:tejamkor/categories/widgets/category_card.dart';

class ExpenseView extends StatelessWidget {
  const ExpenseView({super.key, required this.selectedIds, required this.onToggle});

  final Set<int> selectedIds;
  final Function(int) onToggle;

  // API faqat FontAwesome class nomlarini (fa-utensils) jo'natyapti.
  // Lekin sizda chiroyli qilingan o'zingizni SVG fayllaringiz (assets/icons/...) papkasida yotibdi.
  // Shuning uchun API ni ismidan ushlab, uni sizning local SVG faylingizga to'g'irlab olamiz.
  Widget _buildIcon(String iconStr, String categoryName) {
    if (iconStr.startsWith('http')) {
      return SvgPicture.network(iconStr);
    }

    String path = "car.svg"; // Default fallback (topolmasa shu chiqadi)

    // Backenddagi ismlar -> Sizdagi fayllar xaritasi
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
        path = "statistic.svg"; // Talim uchun alohida svg yoq bo'lsa
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
        // Nom topilmasa terminalni qizartirmaslik uchun aniq mavjud bo'lgan "basket.svg" ni qaytaramiz
        path = "basket.svg";
    }

    // Biz uni assets/icons/ papkangizdan qidiramiz
    return SvgPicture.asset("assets/icons/$path");
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state.status == CategoryStatus.loading || state.status == CategoryStatus.idle) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF0ED2C9)));
        }

        if (state.status == CategoryStatus.error) {
          return Center(child: Text("Xatolik: ${state.errorMessage}"));
        }

        final expenses = state.categories.where((c) => c.type == 'expense').toList();

        if (expenses.isEmpty) {
          return const Center(child: Text("Hech qanday xarajat kategoriyasi yo'q"));
        }

        return GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 16.h,
            crossAxisSpacing: 16.w,
            childAspectRatio: 1,
          ),
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            final item = expenses[index];
            final title = item.name;
            return CategoryCard(
              title: title,
              icon: _buildIcon(item.icon, title),
              isSelected: selectedIds.contains(item.id),
              onTap: () {
                onToggle(item.id);
              },
            );
          },
        );
      },
    );
  }
}
