class ChangePasswordModel {
  final String oldPassword;
  final String newPassword;
  final String newPasswordConfirm;

  ChangePasswordModel({
    required this.oldPassword,
    required this.newPassword,
    required this.newPasswordConfirm,
  });

  Map<String, dynamic> toJson() {
    return {
      "old_password": oldPassword,
      "new_password": newPassword,
      "new_password_confirm": newPasswordConfirm,
    };
  }
}
