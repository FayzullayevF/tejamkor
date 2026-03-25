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

            /// 🔥 SEARCH ICON NI O‘NGROQ QILISH
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 16.w, right: 8.w),
              child: Icon(Icons.search, color: Colors.grey.shade600, size: 22),
            ),

            suffixIcon: _searchQuery.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = "";
                      });
                    },
                    child: SvgPicture.asset('assets/icons/search.svg'),
                  )
                : null,

            border: InputBorder.none,

            contentPadding: EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 22.h, // heightga moslashtirdik
            ),
          ),
        ),
      ),
    );
  }
}
