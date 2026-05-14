import 'package:dio/dio.dart';
import 'package:tejamkor/core/client.dart';
import 'package:tejamkor/core/data/models/auth/auth_model.dart';
import 'package:tejamkor/core/data/models/auth/change_password.dart';
import 'package:tejamkor/core/data/models/auth/forgot_password_request.dart';
import 'package:tejamkor/core/data/models/auth/forgot_password_reset.dart';
import 'package:tejamkor/core/data/models/auth/forgot_password_verify.dart';
import 'package:tejamkor/core/data/models/auth/login_model.dart';
import 'package:tejamkor/core/secure_storage.dart';

class AuthRepository {
  AuthRepository({required this.client});

  final ApiClient client;

  String? jwt;

  Future<void> login({required String login, required String password, String? name}) async {
    final tokens = await client.login(
      LoginModel(login: login, password: password),
    );
    await AppSecureStorage.clearAuthData();
    await AppSecureStorage.saveAuthData(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
      login: login,
      name: name,
    );

    jwt = tokens.accessToken;
  }

  Future<bool> signUp({
    required String passwordConfirm,
    required String fullName,
    required String emailTelefonRaqami,
    required String password,
  }) async {
    final result = await client.signUp(
      AuthModel(
        full_name: fullName,
        email_telefon_raqami: emailTelefonRaqami,
        password_confirm: passwordConfirm,
        password: password,
      ),
    );
    return result;
  }

  Future<void> logout() async {
    try {
      final refreshToken = await AppSecureStorage.getRefreshToken();
      final email = await AppSecureStorage.getLogin();

      if (refreshToken != null && refreshToken.isNotEmpty) {
        await client.logout(refreshToken: refreshToken, email: email);
      }
    } on DioException {
      print("Dio Exception");
    } catch (_) {
    } finally {
      jwt = null;
      await AppSecureStorage.clearAuthData();
    }
  }

  Future<void> clearSession() async {
    jwt = null;
    await AppSecureStorage.clearAuthData();
  }

  Future<bool> refreshToken() async {
    try {
      final refreshTokenValue = await AppSecureStorage.getRefreshToken();

      if (refreshTokenValue == null || refreshTokenValue.isEmpty) {
        return false;
      }

      final response = await client.refresh(refreshToken: refreshTokenValue);

      await AppSecureStorage.saveAccessToken(response.accessToken);
      jwt = response.accessToken;

      return true;
    } on DioException {
      await clearSession();
      return false;
    } catch (_) {
      await clearSession();
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await AppSecureStorage.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<String?> getSavedLogin() async {
    return AppSecureStorage.getLogin();
  }

  Future<String?> getAccessToken() async {
    return AppSecureStorage.getToken();
  }

  Future<String?> getRefreshToken() async {
    return AppSecureStorage.getRefreshToken();
  }

  Future<ForgotPasswordRequestResponse> forgotPasswordRequest({
    required String email,
  }) async {
    return await client.forgotPasswordRequest(email: email);
  }

  Future<ForgotPasswordVerifyResponse> forgotPasswordVerify({
    required String verifyToken,
    required String code,
  }) async {
    return await client.forgotPasswordVerify(
      verify_token: verifyToken,
      code: code,
    );
  }

  Future<void> forgotPasswordReset({
    required String resetToken,
    required String newPassword,
    required String newPasswordConfirm,
  }) async {
    await client.forgotPasswordReset(
      ForgotPasswordResetModel(
        resetToken: resetToken,
        newPassword: newPassword,
        newPasswordConfirm: newPasswordConfirm,
      ),
    );
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirm,
  }) async {
    await client.changePassword(
      ChangePasswordModel(
        oldPassword: oldPassword,
        newPassword: newPassword,
        newPasswordConfirm: newPasswordConfirm,
      ),
    );
  }
}
