import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:tejamkor/auth/blocs/login/login_event.dart';
import 'package:tejamkor/auth/blocs/login/login_state.dart';
import 'package:tejamkor/core/data/repos/auth_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _repo;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginBloc({required AuthRepository repo})
    : _repo = repo,
      super(LoginState.initial()) {
    on<LoginSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    print("Login event keldi");
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      await _repo.login(
        login: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      print("Login success");
      emit(state.copyWith(status: LoginStatus.success));
    } catch (e,s) {
      print("Login error $e");
      print("STACKTRACE: $s");
      emit(
        state.copyWith(status: LoginStatus.error, errorMessage: e.toString()),
      );
    }
  }
}
