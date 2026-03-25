class ForgotPasswordResetModel {
  final String resetToken;
  final String newPassword;
  final String newPasswordConfirm;

  ForgotPasswordResetModel({
    required this.resetToken,
    required this.newPassword,
    required this.newPasswordConfirm,
  });

  Map<String, dynamic> toJson() {
    return {
      "reset_token": resetToken,
      "new_password": newPassword,
      "new_password_confirm": newPassword,
    };
  }
}
