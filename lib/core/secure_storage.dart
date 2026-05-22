import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppSecureStorage {
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String loginKey = 'login';
  static const String nameKey = 'name';

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: false,
      resetOnError: true,
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

  static Future<void> saveName(String name) async {
    await _storage.write(key: nameKey, value: name);
  }

  static Future<void> saveAuthData({
    required String accessToken,
    required String refreshToken,
    required String login,
    String? name,
  }) async {
    await _storage.write(key: accessTokenKey, value: accessToken);
    await _storage.write(key: refreshTokenKey, value: refreshToken);
    await _storage.write(key: loginKey, value: login);
    if (name != null) {
      await _storage.write(key: nameKey, value: name);
    }
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

  static Future<String?> getName() async {
    return _storage.read(key: nameKey);
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

  static Future<void> deleteName() async {
    await _storage.delete(key: nameKey);
  }

  static Future<void> clearAuthData() async {
    await _storage.delete(key: accessTokenKey);
    await _storage.delete(key: refreshTokenKey);
    await _storage.delete(key: loginKey);
    await _storage.delete(key: nameKey);
  }
}