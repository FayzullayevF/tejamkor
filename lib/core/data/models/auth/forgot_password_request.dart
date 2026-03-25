class ForgotPasswordRequestResponse {
  final String? verifyToken;
  final String? message;

  ForgotPasswordRequestResponse({ this.verifyToken, this.message});

  factory ForgotPasswordRequestResponse.fromJson(Map<String, dynamic> json) {

    return ForgotPasswordRequestResponse(
      verifyToken: json['verify_token'],
      message: json['message']?.toString(),
    );
  }
}
