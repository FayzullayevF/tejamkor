import 'package:freezed_annotation/freezed_annotation.dart';
part 'forgot_password_state.freezed.dart';
enum ForgotPasswordStatus { idle, success, error, loading,codeSent,verified }

@freezed
abstract class ForgotPasswordState with _$ForgotPasswordState {
  const factory ForgotPasswordState({
    required ForgotPasswordStatus status,
    String? verifyToken,
    String? resetToken,
    String? error,
  }) = _ForgotPasswordState;
  factory ForgotPasswordState.initial(){
    return ForgotPasswordState(status: ForgotPasswordStatus.idle);
  }
}
