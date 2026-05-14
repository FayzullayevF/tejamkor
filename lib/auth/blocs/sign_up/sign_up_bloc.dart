import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:tejamkor/auth/blocs/sign_up/sign_up_event.dart';
import 'package:tejamkor/auth/blocs/sign_up/sign_up_state.dart';
import 'package:tejamkor/core/data/repos/auth_repository.dart';
import 'package:tejamkor/core/utils/error_parser.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository _repo;
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  SignUpBloc({required AuthRepository repo})
    : _repo = repo,
      super(SignUpState.initial()) {
    on<SignUpSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(SignUpSubmitted event, Emitter<SignUpState> emit) async {
    emit(state.copyWith(status: SignUpStatus.loading));
    try {
      final store = await _repo.signUp(
        passwordConfirm: passwordConfirmController.text.trim(),
        fullName: fullNameController.text.trim(),
        emailTelefonRaqami: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (store) {
        await _repo.login(
          login: emailController.text.trim(),
          password: passwordController.text.trim(),
          name: fullNameController.text.trim(),
        );
        emit(state.copyWith(status: SignUpStatus.success));
      } else {
        emit(state.copyWith(status: SignUpStatus.error,errorMessage: "Ro'yxatdan o'tish kutilmaganda to'xtatildi. Qayta urinib ko'ring."));
      }
    } catch (e) {
      emit(state.copyWith(status: SignUpStatus.error, errorMessage: ErrorParser.parse(e)));
    }
  }

  @override
  Future<void> close() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    return super.close();
  }
}
