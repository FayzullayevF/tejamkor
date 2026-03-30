import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchCard extends StatefulWidget {
  const SearchCard({super.key});

  @override
  State<SearchCard> createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchCard> {
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 366.w,
      height: 73.h,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(47),
          border: Border.all(color: Color(0xff7C7777), width: 1),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          decoration: InputDecoration(
            hintText: "Qidiruv",
            hintStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 20,
              color: Color(0xff7C7777),
            ),

            prefixIcon: Container(
              padding: EdgeInsets.only(left: 24.w, right: 14.w),
              child: SvgPicture.asset(
                'assets/icons/search.svg',
                width: 24.w,
                height: 24.w,
                colorFilter: const ColorFilter.mode(Color(0xff7C7777), BlendMode.srcIn),
              ),
            ),
            prefixIconConstraints: BoxConstraints(
              minWidth: 62.w, // left(24) + width(24) + right(14) = 62
              minHeight: 24.w,
            ),

            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.close, color: const Color(0xff7C7777), size: 24.w),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = "";
                      });
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 22.h,
            ),
          ),
        ),
      ),
    );
  }
}
