import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tejamkor/core/data/repos/auth_repository.dart';
import 'package:tejamkor/core/routing/router.dart';
import 'package:tejamkor/core/secure_storage.dart';
import 'package:tejamkor/core/theme_notifier.dart';
import 'package:tejamkor/widgets/custom_navi_bar.dart';
import 'package:tejamkor/widgets/app_snackbar.dart';

import '../../home/widgets/settings_logout_button.dart';
import '../../home/widgets/settings_profile_header.dart';
import '../../home/widgets/settings_section_card.dart';

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
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 10.h),
                FutureBuilder(
                  future: Future.wait([
                    AppSecureStorage.getName(),
                    AppSecureStorage.getLogin(),
                  ]),
                  builder: (context, AsyncSnapshot<List<String?>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox();
                    }
                    final name = snapshot.data?[0] ?? "";
                    final email = snapshot.data?[1] ?? "";
                    return SettingsProfileHeader(
                      name: name,
                      email: email,
                      textColor: textColor,
                      subtitleColor: subtitleColor,
                    );
                  },
                ),

                SizedBox(height: 32.h),
                SettingsSectionCard(
                  title: "AKKAUNT SOZLAMALARI",
                  cardColor: cardColor,
                  textColor: textColor,
                  subtitleColor: subtitleColor,
                  items: [
                    SettingsItemData(
                      icon: "assets/icons/s_shield.svg",
                      title: "Akkaunt xavfsizligi",
                      subtitle: "Biometrics & 2FA active",
                      onTap: () => context.push(Routers.accountSecurity),
                    ),
                    SettingsItemData(
                      icon: "assets/icons/notification.svg",
                      title: "Bildirishnoma sozlamalari",
                      subtitle: "Alerts, sounds & badges",
                      onTap: () => context.push(Routers.notificationSettings),
                    ),
                    SettingsItemData(
                      icon: "assets/icons/bank.svg",
                      title: "Bog'langan akkauntlar",
                      subtitle: "3 ta bank ulangan",
                      onTap: () => context.push(Routers.linkedAccounts),
                    ),
                  ],
                ),
                SizedBox(height: 32.h),
                SettingsSectionCard(
                  title: "SOZLAMALAR",
                  cardColor: cardColor,
                  textColor: textColor,
                  subtitleColor: subtitleColor,
                  items: [
                    SettingsItemData(
                      icon: "assets/icons/moon.svg",
                      title: "Theme",
                      subtitle: isDark ? "Dark Mode" : "Light Mode",
                      onTap: () =>
                          context.read<ThemeNotifier>().toggleTheme(!isDark),
                      trailing: Switch(
                        value: isDark,
                        onChanged: (val) =>
                            context.read<ThemeNotifier>().toggleTheme(val),
                        activeThumbColor: const Color(0xFF0ED2C9),
                      ),
                    ),
                    SettingsItemData(
                      icon: "assets/icons/search_shield.svg",
                      title: "Privacy Policy",
                      subtitle: "Updated July 2024",
                      onTap: () => context.push(Routers.privacyPolicy),
                      trailing: Icon(
                        Icons.open_in_new,
                        color: Colors.grey.shade400,
                        size: 20.w,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32.h),
                SettingsLogoutButton(
                  cardColor: cardColor,
                  onTap: () => _handleLogout(context),
                ),
                SizedBox(height: 15.h),
                _buildVersionText(),
                SizedBox(height: 120.h),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: 3,
        onTap: (index) {
          if (index == 0) context.go(Routers.home);
          if (index == 1) context.go(Routers.transactionHistory);
          if (index == 2) context.go(Routers.monthlyLimit);
          if (index == 3) context.go(Routers.statistics);
        },
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    try {
      final authRepo = context.read<AuthRepository>();
      await authRepo.logout();
      if (context.mounted) context.go(Routers.login);
    } catch (_) {
      if (context.mounted) {
        AppSnackbar.showError(context, "Akkountdan chiqishda xatolik yuz berdi");
      }
    }
  }

  Widget _buildVersionText() {
    return Center(
      child: Text(
        "Tejamkor v1",
        style: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
