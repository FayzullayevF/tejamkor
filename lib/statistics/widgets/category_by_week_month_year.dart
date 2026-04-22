import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryByWeekMonthYear extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String currentFilter;

  const CategoryByWeekMonthYear({
    super.key,
    required this.onChanged,
    required this.currentFilter,
  });

  @override
  State<CategoryByWeekMonthYear> createState() =>
      _CategoryByWeekMonthYearState();
}

class _CategoryByWeekMonthYearState
    extends State<CategoryByWeekMonthYear> {
  late int selectedIndex;

  final List<String> items = ["Hafta", "Oy", "Yil"];
  final List<String> filterTypes = ["week", "month", "year"];

  @override
  void initState() {
    super.initState();
    selectedIndex = filterTypes.indexOf(widget.currentFilter);
    if (selectedIndex == -1) selectedIndex = 1; // Default to 'Oy'
  }

  @override
  void didUpdateWidget(CategoryByWeekMonthYear oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentFilter != oldWidget.currentFilter) {
      setState(() {
        selectedIndex = filterTypes.indexOf(widget.currentFilter);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Kategoriya bo'yicha",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),

        // 🔥 SEGMENTED CONTAINER
        Container(
          height: 32.h,
          width: 175.w,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: const Color(0xffE5E9EA),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: List.generate(items.length, (index) {
              final isActive = selectedIndex == index;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (selectedIndex != index) {
                      setState(() {
                        selectedIndex = index;
                      });
                      widget.onChanged(filterTypes[index]);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.white
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      items[index],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                        color: isActive
                            ? const Color(0xff006673)
                            : const Color(0xff3E494B),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}