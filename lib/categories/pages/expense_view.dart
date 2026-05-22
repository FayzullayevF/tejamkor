import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tejamkor/categories/blocs/category/category_bloc.dart';
import 'package:tejamkor/categories/blocs/category/category_state.dart';
import 'package:tejamkor/categories/widgets/category_card.dart';
import 'package:tejamkor/core/utils/icon_mapper.dart';

class ExpenseView extends StatelessWidget {
  final Set<int> selectedIds;
  final Function(int) onToggle;

  const ExpenseView({
    super.key,
    required this.selectedIds,
    required this.onToggle,
  });

  Widget _buildIcon(String categoryName) {
    return SvgPicture.asset(IconMapper.getTejamkorIcon(categoryName));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state.status == CategoryStatus.loading ||
            state.status == CategoryStatus.idle) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF0ED2C9)),
          );
        }

        if (state.status == CategoryStatus.error) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                state.errorMessage ??
                    "Kategoriyalarni yuklashda xatolik yuz berdi",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        final expenses = state.categories
            .where((c) => c.type == 'expense')
            .toList();

        if (expenses.isEmpty) {
          return const Center(
            child: Text("Hech qanday xarajat kategoriyasi yo'q"),
          );
        }

        return GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 16.h,
            crossAxisSpacing: 16.w,
            childAspectRatio: 1.1,
          ),
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            final item = expenses[index];
            final title = item.name;
            return CategoryCard(
              key: ValueKey(item.id),
              title: title,
              icon: _buildIcon(title),
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
