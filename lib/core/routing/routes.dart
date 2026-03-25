import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tejamkor/auth/blocs/sign_up/sign_up_bloc.dart';
import 'package:tejamkor/auth/pages/enter_password_view.dart';
import 'package:tejamkor/auth/pages/forgot_password_view.dart';
import 'package:tejamkor/auth/pages/login_view.dart';
import 'package:tejamkor/auth/pages/onboarding_view.dart';
import 'package:tejamkor/auth/pages/sign_up_view.dart';
import 'package:tejamkor/categories/pages/categories_view.dart';
import 'package:tejamkor/core/routing/router.dart';
import 'package:tejamkor/home/pages/home_view.dart';

final router = GoRouter(
  initialLocation: Routers.categories,
  routes: [
    GoRoute(path: Routers.onboarding, builder: (_, _) => OnboardingView()),
    GoRoute(path: Routers.login, builder: (_, _) => LoginView()),
    GoRoute(
      path: Routers.signUp,
      builder: (context, state) => BlocProvider(
        create: (context) => SignUpBloc(repo: context.read()),
        child: SignUpView(),
      ),
    ),
    GoRoute(path: Routers.home, builder: (_, _) => HomeView()),
    GoRoute(
      path: Routers.forgotPassword,
      builder: (_, _) => ForgotPasswordView(),
    ),
    GoRoute(
      path: Routers.enterPassword,
      builder: (_, _) => EnterPasswordView(),
    ),
    GoRoute(
      path: Routers.categories,
      builder: (_, _) => CategoriesView(),
    ),
  ],
);
