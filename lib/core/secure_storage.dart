import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppSecureStorage {
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String loginKey = 'login';

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  static Future<void> saveAccessToken(String token) async {
    await _storage.write(key: accessTokenKey, value: token);
  }

  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: refreshTokenKey, value: token);
  }

  static Future<void> saveLogin(String login) async {
    await _storage.write(key: loginKey, value: login);
  }

  static Future<void> saveAuthData({
    required String accessToken,
    required String refreshToken,
    required String login,
  }) async {
    await _storage.write(key: accessTokenKey, value: accessToken);
    await _storage.write(key: refreshTokenKey, value: refreshToken);
    await _storage.write(key: loginKey, value: login);
  }

  static Future<String?> getToken() async {
    return _storage.read(key: accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    return _storage.read(key: refreshTokenKey);
  }

  static Future<String?> getLogin() async {
    return _storage.read(key: loginKey);
  }

  static Future<void> deleteAccessToken() async {
    await _storage.delete(key: accessTokenKey);
  }

  static Future<void> deleteRefreshToken() async {
    await _storage.delete(key: refreshTokenKey);
  }

  static Future<void> deleteLogin() async {
    await _storage.delete(key: loginKey);
  }

  static Future<void> clearAuthData() async {
    await _storage.delete(key: accessTokenKey);
    await _storage.delete(key: refreshTokenKey);
    await _storage.delete(key: loginKey);
  }
}