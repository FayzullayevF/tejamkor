import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tejamkor/add_transactions/blocs/add_transactions_bloc.dart';
import 'package:tejamkor/auth/blocs/sign_up/sign_up_bloc.dart';
import 'package:tejamkor/auth/pages/enter_password_view.dart';
import 'package:tejamkor/auth/pages/forgot_password_view.dart';
import 'package:tejamkor/auth/pages/login_view.dart';
import 'package:tejamkor/auth/pages/onboarding_view.dart';
import 'package:tejamkor/auth/pages/sign_up_view.dart';
import 'package:tejamkor/auth/pages/splash_view.dart';
import 'package:tejamkor/core/data/repos/auth_repository.dart';
import 'package:tejamkor/core/routing/router.dart';
import 'package:tejamkor/home/pages/home_view.dart';
import 'package:tejamkor/categories/pages/all_categories_view.dart';
import 'package:tejamkor/add_transactions/pages/add_transaction_view.dart';
import 'package:tejamkor/monthly_limit/pages/monthly_limit_view.dart';
import 'package:tejamkor/statistics/pages/statistics_view.dart';
import 'package:tejamkor/transaction_history/pages/transaction_history_view.dart';
import 'package:tejamkor/add_transactions/pages/transaction_categories_view.dart';
import '../../settings/account_security_view.dart';
import '../../settings/linked_accounts_view.dart';
import '../../settings/notification_settings_view.dart';
import '../../settings/pages/settings_view.dart';
import '../../settings/privacy_policy_view.dart';

final router = GoRouter(
  initialLocation: Routers.splash,
  redirect: (context, state) async {
    final repo = context.read<AuthRepository>();
    final isLoggedIn = await repo.isLoggedIn();
    final isGoingToLogin =
        state.matchedLocation == Routers.login;
    if (!isLoggedIn && !isGoingToLogin) {
      return Routers.login;
    }
    if (isLoggedIn && isGoingToLogin) {
      return Routers.home;
    }
    return null;
  },
  routes: [
    GoRoute(
      path: Routers.splash,
      builder: (_, _) => const SplashView(),
    ),
    GoRoute(
      path: Routers.onboarding,
      builder: (_, _) => OnboardingView(),
    ),
    GoRoute(
      path: Routers.login,
      builder: (_, _) => LoginView(),
    ),
    GoRoute(
      path: Routers.signUp,
      builder: (context, state) => BlocProvider(
        create: (context) => SignUpBloc(repo: context.read()),
        child: SignUpView(),
      ),
    ),
    GoRoute(
      path: Routers.home,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: HomeView(),
          transitionDuration: const Duration(milliseconds: 700),
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
            final slideAnimation = Tween<Offset>(
              begin: const Offset(0, 0.15),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
            );
            final scaleAnimation = Tween<double>(
              begin: 0.92,
              end: 1,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutExpo,
              ),
            );
            final fadeAnimation = Tween<double>(
              begin: 0,
              end: 1,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeIn,
              ),
            );
            return FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: ScaleTransition(
                  scale: scaleAnimation,
                  child: child,
                ),
              ),
            );
          },
        );
      },
    ),
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
      builder: (_, _) => const AllCategoriesView(),
    ),
    GoRoute(
      path: Routers.settings,
      builder: (_, _) => SettingsView(),
    ),
    GoRoute(
      path: Routers.addTransaction,
      builder: (context, state) => BlocProvider(
        create: (context) => TransactionBloc(context.read()),
        child: const AddTransactionView(),
      ),
    ),
    GoRoute(
      path: Routers.monthlyLimit,
      builder: (_, _) => MonthlyLimitView(),
    ),
    GoRoute(
      path: Routers.statistics,
      builder: (_, _) => StatisticsView(),
    ),
    GoRoute(
      path: Routers.transactionHistory,
      builder: (_, _) => TransactionHistoryView(),
    ),
    GoRoute(
      path: Routers.transactionCategories,
      builder: (context, state) {
        final extra = state.extra;
        if (extra is Map) {
          final hiddenIds =
              (extra['hiddenIds'] as List<dynamic>?)?.cast<int>() ?? [];
          final multiSelect =
              (extra['multiSelect'] as bool?) ?? false;
          return TransactionCategoriesView(
            hiddenCategoryIds: hiddenIds,
            multiSelect: multiSelect,
          );
        }
        return const TransactionCategoriesView();
      },
    ),
    GoRoute(
      path: Routers.accountSecurity,
      builder: (_, _) => const AccountSecurityView(),
    ),
    GoRoute(
      path: Routers.linkedAccounts,
      builder: (_, _) => const LinkedAccountsView(),
    ),
    GoRoute(
      path: Routers.notificationSettings,
      builder: (_, _) => const NotificationSettingsView(),
    ),
    GoRoute(
      path: Routers.privacyPolicy,
      builder: (_, _) => const PrivacyPolicyView(),
    ),
  ],
);