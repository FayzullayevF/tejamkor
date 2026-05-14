import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tejamkor/categories/data/models/category_model.dart';
import 'package:tejamkor/core/utils/icon_mapper.dart';
import 'package:tejamkor/categories/data/repositories/category_repository.dart';
import 'package:tejamkor/widgets/app_snackbar.dart';

class TransactionCategoriesView extends StatefulWidget {
  final List<int> hiddenCategoryIds;
  final bool multiSelect;

  const TransactionCategoriesView({
    super.key,
    this.hiddenCategoryIds = const [],
    this.multiSelect = false,
  });

  @override
  State<TransactionCategoriesView> createState() =>
      _TransactionCategoriesViewState();
}

class _TransactionCategoriesViewState extends State<TransactionCategoriesView> {
  List<CategoryModel> _categories = [];
  List<CategoryModel> _selectedCategories = [];
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
          _categories = categories.where((cat) => !widget.hiddenCategoryIds.contains(cat.id)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        AppSnackbar.showError(context, e.toString());
      }
    }
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
        actions: [
          if (widget.multiSelect)
            TextButton(
              onPressed: () {
                context.pop(_selectedCategories);
              },
              child: Text(
                "Saqlash",
                style: TextStyle(
                  color: const Color(0xFF007A8A),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
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
                final isSelected = _selectedCategories.any((c) => c.id == item.id);
                return GestureDetector(
                  onTap: () {
                    if (widget.multiSelect) {
                      setState(() {
                        if (isSelected) {
                          _selectedCategories.removeWhere((c) => c.id == item.id);
                        } else {
                          _selectedCategories.add(item);
                        }
                      });
                    } else {
                      context.pop(item);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF007A8A).withOpacity(0.1) : cardColor,
                      borderRadius: BorderRadius.circular(24.r),
                      border: isSelected ? Border.all(color: const Color(0xFF007A8A), width: 2) : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildIcon(
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
