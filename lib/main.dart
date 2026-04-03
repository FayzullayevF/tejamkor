import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tejamkor/core/dependencies.dart';
import 'package:tejamkor/core/routing/routes.dart';
import 'package:tejamkor/core/theme_notifier.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(430, 932),
      child: MultiProvider(
        providers: providers,
        builder: (context, child) {
          final themeNotifier = context.watch<ThemeNotifier>();
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            themeMode: themeNotifier.themeMode,
            theme: ThemeData(
              brightness: Brightness.light,
              fontFamily: "San Francisco Pro Display",
              scaffoldBackgroundColor: const Color(0xffF3F3F3),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              fontFamily: "San Francisco Pro Display",
              scaffoldBackgroundColor: Colors.black,
            ),
            routerConfig: router,
          );
        },
      ),
    );
  }
}
