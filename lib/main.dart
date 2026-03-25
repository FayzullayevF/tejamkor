import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tejamkor/core/data/repos/auth_repository.dart';
import 'package:tejamkor/core/dependencies.dart';
import 'package:tejamkor/core/routing/routes.dart';

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
        builder: (context, child) => MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: "San Francisco Pro Display"),
          routerConfig: router,
        ),
      ),
    );
  }
}
