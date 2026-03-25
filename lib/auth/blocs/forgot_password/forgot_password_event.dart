sealed class ForgotPasswordEvent {}

final class ForgotPasswordRequestEvent extends ForgotPasswordEvent {
  final String email;

  ForgotPasswordRequestEvent(this.email);
}

final class ForgotPasswordVerifyEvent extends ForgotPasswordEvent {
  final String verifyToken;
  final String code;

  ForgotPasswordVerifyEvent({required this.verifyToken, required this.code});
}

final class ForgotPasswordResetEvent extends ForgotPasswordEvent {
  final String resetToken;
  final String newPassword;
  final String confirmPassword;

  ForgotPasswordResetEvent({
    required this.resetToken,
    required this.newPassword,
    required this.confirmPassword,
  });
}
