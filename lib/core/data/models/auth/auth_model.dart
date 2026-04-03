class AuthModel {
  AuthModel({
    required this.email_telefon_raqami,
    required this.password,
    required this.password_confirm,
    required this.full_name,
  });

  final String email_telefon_raqami, password, password_confirm, full_name;

  Map<String, dynamic> toJson() {
    return {
      "email_telefon_raqami": email_telefon_raqami,
      "password": password,
      "password_confirm": password_confirm,
      "full_name": full_name,
    };
  }
}

class AuthTokensModel {
  AuthTokensModel({
    required this.accessToken,
    required this.refreshToken,
  });

  final String accessToken;
  final String refreshToken;

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) {
    final tokens = json['tokens'];

    if (tokens is! Map<String, dynamic>) {
      throw Exception('Tokens object kelmadi');
    }

    final access = tokens['access'];
    final refresh = tokens['refresh'];

    if (access == null || access.toString().isEmpty) {
      throw Exception('Access token kelmadi');
    }

    if (refresh == null || refresh.toString().isEmpty) {
      throw Exception('Refresh token kelmadi');
    }

    return AuthTokensModel(
      accessToken: access.toString(),
      refreshToken: refresh.toString(),
    );
  }
}

class RefreshResponseModel {
  RefreshResponseModel({
    required this.accessToken,
  });

  final String accessToken;

  factory RefreshResponseModel.fromJson(Map<String, dynamic> json) {
    final access = json['access'] ?? json['token'];

    if (access == null || access.toString().isEmpty) {
      throw Exception('Yangi access token kelmadi');
    }

    return RefreshResponseModel(
      accessToken: access.toString(),
    );
  }
}