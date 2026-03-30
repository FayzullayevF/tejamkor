import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tejamkor/categories/widgets/category_card.dart';

class IncomeView extends StatefulWidget {
  const IncomeView({super.key, this.onNext});

  final VoidCallback? onNext;

  @override
  State<IncomeView> createState() => _IncomeViewState();
}

class _IncomeViewState extends State<IncomeView> {
  final List<Map<String, dynamic>> incomes = [
    {"title": "Avans", "icon": SvgPicture.asset("assets/icons/dollar.svg")},
    {"title": "Ish haqi", "icon": SvgPicture.asset("assets/icons/salary.svg")},
    {"title": "Keshbek", "icon": SvgPicture.asset("assets/icons/percent.svg")},
    {"title": "Pensiya", "icon": SvgPicture.asset("assets/icons/pension.svg")},
    {
      "title": "Invetitsiya",
      "icon": SvgPicture.asset("assets/icons/statistic.svg"),
    },
    {
      "title": "O'tkazmalar",
      "icon": SvgPicture.asset("assets/icons/pilot.svg"),
    },
    {
      "title": "Omonatlar",
      "icon": SvgPicture.asset("assets/icons/deposit.svg"),
    },
    {"title": "Kredit", "icon": SvgPicture.asset("assets/icons/wallet.svg")},
    {
      "title": "Qo'shimcha\ndaromad",
      "icon": SvgPicture.asset("assets/icons/additional.svg"),
    },
  ];

  final Set<String> _selectedCards = {};

  @override
  Widget build(BuildContext context) {
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
              final title = item["title"] as String;
              return CategoryCard(
                title: title,
                icon: item["icon"],
                isSelected: _selectedCards.contains(title),
                onTap: () {
                  setState(() {
                    if (_selectedCards.contains(title)) {
                      _selectedCards.remove(title);
                    } else {
                      _selectedCards.add(title);
                    }
                  });
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
  }
}
