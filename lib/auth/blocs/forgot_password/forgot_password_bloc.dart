import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:tejamkor/auth/blocs/forgot_password/forgot_password_event.dart';
import 'package:tejamkor/auth/blocs/forgot_password/forgot_password_state.dart';
import 'package:tejamkor/core/data/repos/auth_repository.dart';
import 'package:tejamkor/core/utils/error_parser.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final AuthRepository _repo;
  final emailController = TextEditingController();
  final codeController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  ForgotPasswordBloc({required AuthRepository repo})
    : _repo = repo,
      super(ForgotPasswordState.initial()) {
    on<ForgotPasswordRequestEvent>(_onRequest);
    on<ForgotPasswordVerifyEvent>(_onVerify);
    on<ForgotPasswordResetEvent>(_onReset);
  }

  Future<void> _onRequest(
    ForgotPasswordRequestEvent event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    print("Forgot password request event keldi");
    emit(state.copyWith(status: ForgotPasswordStatus.loading, error: null));
    try {
      final result = await _repo.forgotPasswordRequest(
        email:event.email.trim(),
      );
      print("Forgot password request success");
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.codeSent,
          verifyToken: result.verifyToken,
        ),
      );
    } catch (e, s) {
      print("Forgot password request error $e");
      print("STACKTRACE: $s");
      emit(
        state.copyWith(status: ForgotPasswordStatus.error, error: ErrorParser.parse(e)),
      );
    }
  }

  Future<void> _onVerify(
    ForgotPasswordVerifyEvent event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    print("Forgot password verify event keldi");
    emit(state.copyWith(status: ForgotPasswordStatus.loading));
    try {
      final result = await _repo.forgotPasswordVerify(
        verifyToken: event.verifyToken,
        code: event.code,
      );
      print("Forgot password verify success");
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.verified,
          resetToken: result.resetToken,
        ),
      );
    } catch (e, s) {
      print("Forgot password verify error $e");
      print("STACKTRACE: $s");
      emit(
        state.copyWith(status: ForgotPasswordStatus.error, error: ErrorParser.parse(e)),
      );
    }
  }

  Future<void> _onReset(
    ForgotPasswordResetEvent event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    print("Forgot password reset event keldi");
    emit(state.copyWith(status: ForgotPasswordStatus.loading));
    try {
      await _repo.forgotPasswordReset(
        resetToken: event.resetToken,
        newPassword: event.newPassword,
        newPasswordConfirm: event.confirmPassword,
      );

      print("Forgot password reset success");
      emit(state.copyWith(status: ForgotPasswordStatus.success));
    } catch (e, s) {
      print("Forgot password reset error $e");
      print("STACKTRACE: $s");
      emit(
        state.copyWith(status: ForgotPasswordStatus.error, error: ErrorParser.parse(e)),
      );
    }
  }
  @override
  Future<void> close() {
   emailController.dispose();
    return super.close();
  }
}
