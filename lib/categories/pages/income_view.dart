import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tejamkor/categories/blocs/category/category_bloc.dart';
import 'package:tejamkor/categories/blocs/category/category_state.dart';
import 'package:tejamkor/categories/widgets/category_card.dart';
import 'package:tejamkor/core/utils/icon_mapper.dart';

class IncomeView extends StatelessWidget {
  const IncomeView({super.key, required this.selectedIds, required this.onToggle});

  final Set<int> selectedIds;
  final Function(int) onToggle;

  Widget _buildIcon(String categoryName) {
    return SvgPicture.asset(IconMapper.getTejamkorIcon(categoryName));
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

        final incomes = state.categories.where((c) => c.type == 'income').take(20).toList();

        if (incomes.isEmpty) {
          return const Center(child: Text("Hech qanday daromad kategoriyasi yo'q"));
        }

        return Column(
          children: [
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16.h,
                  crossAxisSpacing: 16.w,
                  childAspectRatio: 1,
                ),
                itemCount: incomes.length,
                itemBuilder: (context, index) {
                  final item = incomes[index];
                  final title = item.name;
                  return CategoryCard(
                    title: title,
                    icon: _buildIcon(title),
                    isSelected: selectedIds.contains(item.id),
                    onTap: () {
                      onToggle(item.id);
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: const Color(0xffDFF9FA),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                "Keyinchalik sozlamalarda kategoriyalarni\ntahrirlash va yangilarini qo'shishingiz mumkin",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
