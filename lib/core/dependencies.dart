import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tejamkor/add_transactions/blocs/add_transactions_bloc.dart';
import 'package:tejamkor/auth/blocs/forgot_password/forgot_password_bloc.dart';
import 'package:tejamkor/auth/blocs/login/login_bloc.dart';
import 'package:tejamkor/auth/blocs/sign_up/sign_up_bloc.dart';
import 'package:tejamkor/auth/pages/forgot_password_view.dart';
import 'package:tejamkor/core/client.dart';
import 'package:tejamkor/core/data/repos/add_transactions.dart';
import 'package:tejamkor/core/data/repos/auth_repository.dart';
import 'package:tejamkor/categories/data/repositories/category_repository.dart';
import 'package:tejamkor/categories/blocs/category/category_bloc.dart';
import 'package:tejamkor/core/theme_notifier.dart';
import 'package:tejamkor/core/data/repos/account_repository.dart';
import 'package:tejamkor/add_transactions/blocs/accounts/accounts_bloc.dart';
import 'package:tejamkor/statistics/data/sources/statistics_api_source.dart';
import 'package:tejamkor/statistics/data/repositories/statistics_repository.dart';
import 'package:tejamkor/statistics/bloc/statistics_bloc.dart';
import 'package:tejamkor/home/data/repos/dashboard_repository.dart';
import 'package:tejamkor/home/bloc/dashboard_bloc.dart';
import 'package:tejamkor/categories/data/repositories/currency_repository.dart';
import 'package:tejamkor/categories/blocs/currency/currency_bloc.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (_) => ThemeNotifier()),
  Provider(create: (context) => ApiClient()),
  Provider(create: (context) => AuthRepository(client: context.read())),
  Provider(create: (context) => CategoryRepository(apiClient: context.read())),
  Provider(create: (context) => TransactionRepository(context.read<ApiClient>())),
  Provider(create: (context) => AccountRepository(apiClient: context.read<ApiClient>())),
  Provider(create: (context) => StatisticsApiSource(context.read<ApiClient>().dio)),
  Provider(create: (context) => StatisticsRepository(context.read<StatisticsApiSource>())),
  Provider(create: (context) => CurrencyRepository(apiClient: context.read<ApiClient>())),
  BlocProvider(
    create: (context) => CategoryBloc(repo: context.read<CategoryRepository>()),
  ),
  BlocProvider(
    create: (context) => SignUpBloc(repo: context.read<AuthRepository>()),
  ),
  BlocProvider(
    create: (context) => LoginBloc(repo: context.read<AuthRepository>()),
  ),
  BlocProvider(
    create: (context) =>
        ForgotPasswordBloc(repo: context.read<AuthRepository>()),
    child: ForgotPasswordView(),
  ),
  BlocProvider(
    create: (context) =>
        TransactionBloc(context.read<TransactionRepository>()),
  ),
  BlocProvider(
    create: (context) => AccountsBloc(repository: context.read<AccountRepository>()),
  ),
  BlocProvider(
    create: (context) => StatisticsBloc(context.read<StatisticsRepository>()),
  ),
  BlocProvider(
    create: (context) => CurrencyBloc(repo: context.read<CurrencyRepository>()),
  ),
  Provider(create: (context) => DashboardRepository(context.read<ApiClient>())),
  BlocProvider(
    create: (context) => DashboardBloc(context.read<DashboardRepository>()),
  ),
];
