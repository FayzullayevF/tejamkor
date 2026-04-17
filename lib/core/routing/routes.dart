import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tejamkor/add_transactions/blocs/add_transactions_bloc.dart';
import 'package:tejamkor/auth/blocs/sign_up/sign_up_bloc.dart';
import 'package:tejamkor/auth/pages/enter_password_view.dart';
import 'package:tejamkor/auth/pages/forgot_password_view.dart';
import 'package:tejamkor/auth/pages/login_view.dart';
import 'package:tejamkor/auth/pages/onboarding_view.dart';
import 'package:tejamkor/auth/pages/sign_up_view.dart';
import 'package:tejamkor/core/data/repos/add_transactions.dart';
import 'package:tejamkor/core/routing/router.dart';
import 'package:tejamkor/home/home_view.dart';
import 'package:tejamkor/categories/pages/all_categories_view.dart';
import 'package:tejamkor/home/pages/settings_view.dart';
import 'package:tejamkor/add_transactions/pages/add_transaction_view.dart';
import 'package:tejamkor/monthly_limit/pages/monthly_limit_view.dart';
import 'package:tejamkor/statistics/pages/statistics_view.dart';
import 'package:tejamkor/transaction_history/pages/transaction_history_view.dart';

final router = GoRouter(
  initialLocation: Routers.addTransaction,
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
      builder: (_, _) => const AllCategoriesView(),
    ),
    GoRoute(path: Routers.settings, builder: (_, _) => SettingsView()),
    GoRoute(
      path: Routers.addTransaction,
      builder: (context, state) => BlocProvider(
        create: (context)=> TransactionBloc(context.read()),
        child: const AddTransactionView(),
      ),
    ),
    GoRoute(path: Routers.monthlyLimit, builder: (_, _) => MonthlyLimitView()),
    GoRoute(path: Routers.statistics, builder: (_, _) => StatisticsView()),
    GoRoute(
      path: Routers.transactionHistory,
      builder: (_, _) => TransactionHistoryView(),
    ),
  ],
);
