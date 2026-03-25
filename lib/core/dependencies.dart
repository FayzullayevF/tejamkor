import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tejamkor/auth/blocs/forgot_password/forgot_password_bloc.dart';
import 'package:tejamkor/auth/blocs/login/login_bloc.dart';
import 'package:tejamkor/auth/blocs/sign_up/sign_up_bloc.dart';
import 'package:tejamkor/auth/pages/forgot_password_view.dart';
import 'package:tejamkor/core/client.dart';
import 'package:tejamkor/core/data/repos/auth_repository.dart';

List<SingleChildWidget> providers = [
  Provider(create: (context) => ApiClient()),
  Provider(create: (context) => AuthRepository(client: context.read())),
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
];
