import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tejamkor/core/data/repos/auth_repository.dart';
import 'package:tejamkor/core/routing/router.dart';
import 'package:tejamkor/core/theme_notifier.dart';
import 'package:tejamkor/core/utils/app_colors.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDark ? Colors.white : Colors.black;
    final Color subtitleColor = isDark
        ? Colors.white54
        : const Color(0xFF7C7777);
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xffF3F3F3),
      extendBody: true,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 10.h),
                    Center(
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomCenter,
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 106.w,
                                height: 106.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF0ED2C9),
                                    width: 3.w,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(4.w),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey.shade300,
                                    child: Icon(
                                      Icons.person,
                                      size: 50.w,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: -10.h,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF058F9D),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/tejamkor_plus.svg",
                                        width: 10.w,
                                        height: 10.w,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        "TEJAMKOR\nPLUS",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 8.sp,
                                          fontWeight: FontWeight.bold,
                                          height: 1.1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            "Daler Xusinov",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "dalerxusinov@gmail.com",
                            style: TextStyle(
                              fontSize: 14,
                              color: subtitleColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32.h),
                    Text(
                      "AKKAUNT SOZLAMALARI",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: subtitleColor,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Column(
                        children: [
                          _buildSettingsItem(
                            icon: "assets/icons/s_shield.svg",
                            title: "Akkaunt xavfsizligi",
                            subtitle: "Biometrics & 2FA active",
                            textColor: textColor,
                            subtitleColor: subtitleColor,
                          ),
                          _buildDivider(),
                          _buildSettingsItem(
                            icon: "assets/icons/notification.svg",
                            title: "Bildirishnoma sozlamalari",
                            subtitle: "Alerts, sounds & badges",
                            textColor: textColor,
                            subtitleColor: subtitleColor,
                          ),
                          _buildDivider(),
                          _buildSettingsItem(
                            icon: "assets/icons/bank.svg",
                            title: "Bog'langan akkauntlar",
                            subtitle: "3 ta bank ulangan",
                            textColor: textColor,
                            subtitleColor: subtitleColor,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32.h),
                    Text(
                      "SOZLAMALAR",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: subtitleColor,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Column(
                        children: [
                          _buildSettingsItem(
                            icon: "assets/icons/moon.svg",
                            title: "Theme",
                            subtitle: isDark ? "Dark Mode" : "Light Mode",
                            textColor: textColor,
                            subtitleColor: subtitleColor,
                            onTap: () {
                              context.read<ThemeNotifier>().toggleTheme(
                                !isDark,
                              );
                            },
                            trailing: Switch(
                              value: isDark,
                              onChanged: (val) {
                                context.read<ThemeNotifier>().toggleTheme(val);
                              },
                              activeColor: const Color(0xFF0ED2C9),
                            ),
                          ),
                          _buildDivider(),
                          _buildSettingsItem(
                            icon: "assets/icons/search_shield.svg",
                            title: "Privacy Policy",
                            subtitle: "Updated July 2024",
                            textColor: textColor,
                            subtitleColor: subtitleColor,
                            trailing: Icon(
                              Icons.open_in_new,
                              color: Colors.grey.shade400,
                              size: 20.w,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32.h),
                    InkWell(
                      onTap: () async {
                        try {
                          final authRepo = context.read<AuthRepository>();
                          await authRepo.logout();
                          if (context.mounted) {
                            context.go(Routers.login);
                          }
                        } catch (_) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Akkountdan chiqishda xatolik yuz berdi",
                                ),
                              ),
                            );
                          }
                        }
                      },
                      borderRadius: BorderRadius.circular(24.r),
                      child: Container(
                        height: 60.h,
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.logout,
                              color: const Color(0xFFD32F2F),
                              size: 20.w,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "Akauntdan chiqish",
                              style: TextStyle(
                                color: const Color(0xFFD32F2F),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 15.h),
                    Center(
                      child: Text(
                        "Tejamkor v1",
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 120.h),
                  ],
                ),
              ),
            ),
          ),
          _buildCustomNavBar(context, isDark),
        ],
      ),
    );
  }

  Widget _buildCustomNavBar(BuildContext context, bool isDark) {
    return Positioned(
      bottom: 36.h,
      left: 27.w,
      right: 27.w,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            height: 68.h,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(35.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(context, 0, 'assets/icons/house.svg', isDark),
                _buildNavItem(context, 1, 'assets/icons/time.svg', isDark),
                SizedBox(width: 70.w),
                _buildNavItem(context, 2, 'assets/icons/shield.svg', isDark),
                _buildNavItem(context, 3, 'assets/icons/menu.svg', isDark),
              ],
            ),
          ),
          Container(
            height: 80.w,
            width: 80.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.darkNavy, AppColors.cyanAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.1, 1],
              ),

              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0ED2C9).withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: FloatingActionButton(
              heroTag: null,
              onPressed: () {
                context.push(Routers.addTransaction);
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              focusElevation: 0,
              highlightElevation: 0,
              shape: const CircleBorder(),
              child: Icon(Icons.add, color: Colors.white, size: 36.w),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    String assetPath,
    bool isDark,
  ) {
    final isSelected = index == 3;
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          context.go(Routers.home);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.white24 : const Color(0xFFF3F3F3))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: SvgPicture.asset(
          assetPath,
          width: 24.w,
          height: 24.w,
          colorFilter: ColorFilter.mode(
            isSelected
                ? (isDark ? Colors.white : Colors.black)
                : const Color(0xFFACACAC),
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required String icon,
    required String title,
    required String subtitle,
    required Color textColor,
    required Color subtitleColor,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F8F7),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: SvgPicture.asset(
                icon,
                color: const Color(0xFF058F9D),
                height: 20.h,
                width: 20.w,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: subtitleColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            trailing ??
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade400,
                  size: 24.w,
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.only(left: 64.w, right: 16.w),
      child: Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
    );
  }
}
