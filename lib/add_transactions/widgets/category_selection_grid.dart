import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tejamkor/categories/data/models/category_model.dart';
import 'package:tejamkor/core/utils/icon_mapper.dart';

class CategorySelectionGrid extends StatelessWidget {
  final List<CategoryModel> categories;
  final int selectedIndex;
  final Color cardColor;
  final Color textColor;
  final Function(int) onCategorySelected;
  final VoidCallback onSeeAll;

  const CategorySelectionGrid({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.cardColor,
    required this.textColor,
    required this.onCategorySelected,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    // 2 qator: har bir karta ~100h, oralig' 16h => 2*100 + 1*16 = 216h
    final double gridHeight = 100.h * 2 + 16.h;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Kategoriyani tanlang",
              style: TextStyle(
                color: textColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            GestureDetector(
              onTap: onSeeAll,
              child: Text(
                "Hammasi",
                style: TextStyle(
                  color: const Color(0xFF006673),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),

        // Fixed height scroll container — hamyon va button pastga surilmaydi
        SizedBox(
          height: gridHeight,
          child: categories.isEmpty
              ? Center(
                  child: Text(
                    "Kategoriyalar topilmadi",
                    style: TextStyle(color: textColor, fontSize: 13.sp),
                  ),
                )
              : GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final item = categories[index];
                    return _CategoryCard(
                      item: item,
                      isSelected: selectedIndex == index,
                      cardColor: cardColor,
                      textColor: textColor,
                      onTap: () => onCategorySelected(index),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CategoryModel item;
  final bool isSelected;
  final Color cardColor;
  final Color textColor;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.item,
    required this.isSelected,
    required this.cardColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF006673) : cardColor,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF006673).withOpacity( 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIcon(item.name,
                color: isSelected ? Colors.white : const Color(0xFF058F9D)),
            SizedBox(height: 12.h),
            Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isSelected ? Colors.white : textColor,
                fontSize: 13.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(String categoryName, {Color? color}) {
    return SvgPicture.asset(
      IconMapper.getTejamkorIcon(categoryName),
      width: 28.w,
      height: 28.w,
      colorFilter: color != null
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : null,
    );
  }
}
