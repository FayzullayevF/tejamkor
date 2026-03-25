class ForgotPasswordVerifyResponse {
  final String resetToken;
  final String? message;

  ForgotPasswordVerifyResponse({required this.resetToken, this.message});

  factory ForgotPasswordVerifyResponse.fromJson(Map<String, dynamic> json) {
    final token = json['reset_token'];

    if (token == null || token.toString().isEmpty) {
      throw Exception("reset_token kelmadi");
    }
    return ForgotPasswordVerifyResponse(
      resetToken: token.toString(),
      message: json["message"]?.toString(),
    );
  }
}
