import 'package:dio/dio.dart';
import 'package:tejamkor/categories/data/models/category_model.dart';
import 'package:tejamkor/categories/data/models/currency_model.dart';
import 'package:tejamkor/core/data/models/auth/auth_model.dart';
import 'package:tejamkor/core/data/models/auth/change_password.dart';
import 'package:tejamkor/core/data/models/auth/forgot_password_request.dart';
import 'package:tejamkor/core/data/models/auth/forgot_password_reset.dart';
import 'package:tejamkor/core/data/models/auth/forgot_password_verify.dart';
import 'package:tejamkor/core/data/models/auth/login_model.dart';
import 'package:tejamkor/core/interceptor.dart';

import 'api_constans.dart';
import 'data/models/transactions/post_transactions.dart';

class ApiClient {
  final Dio dio = Dio(BaseOptions(baseUrl: "https://www.tejamkor-ai.uz"))
    ..interceptors.add(AuthInterceptor());


  static const String _registerPath = '/api/users/register/';
  static const String _loginPath = '/api/users/login/';
  static const String _refreshPath = '/api/users/token/refresh/';
  static const String _logoutPath = '/api/users/logout/';
  static const String _forgotPasswordRequestPath =
      '/api/users/forgot-password/request/';
  static const String _forgotPasswordVerifyPath =
      '/api/users/forgot-password/verify/';
  static const String _forgotPasswordResetPath =
      '/api/users/forgot-password/reset/';
  static const String _changePassword = '/api/users/change-password/';

  Future<bool> signUp(AuthModel model) async {
    final response = await dio.post(
      _registerPath,
      data: model.toJson(),
      options: Options(extra: {'requiresAuth': false}),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<AuthTokensModel> login(LoginModel model) async {
    final response = await dio.post(
      _loginPath,
      data: model.toJson(),
      options: Options(extra: {'requiresAuth': false}),
    );

    print("LOGIN RESPONSE DATA: ${response.data}");
    print("LOGIN STATUS CODE: ${response.statusCode}");
    if (response.data is! Map<String, dynamic>) {
      throw Exception('Login response noto‘g‘ri formatda keldi');
    }

    return AuthTokensModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<RefreshResponseModel> refresh({required String refreshToken}) async {
    final response = await dio.post(
      _refreshPath,
      data: {'refresh': refreshToken},
      options: Options(extra: {'requiresAuth': false}),
    );

    if (response.data is! Map<String, dynamic>) {
      throw Exception('Refresh response noto‘g‘ri formatda keldi');
    }

    return RefreshResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<bool> logout({required String refreshToken, String? email}) async {
    final data = <String, dynamic>{'refresh': refreshToken};
    if (email != null) {
      data['email'] = email;
    }
    final response = await dio.post(
      _logoutPath,
      data: data,
      options: Options(extra: {'requiresAuth': false}),
    );

    return response.statusCode == 200 ||
        response.statusCode == 204 ||
        response.statusCode == 205;
  }

  Future<ForgotPasswordRequestResponse> forgotPasswordRequest({
    required String email,
  }) async {
    final response = await dio.post(
      _forgotPasswordRequestPath,
      data: {'email': email},
      options: Options(extra: {'requiresAuth': false}),
    );
    print(response.data);
    if (response.data is! Map<String, dynamic>) {
      throw Exception("Kod yuborilmadi");
    }
    return ForgotPasswordRequestResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<ForgotPasswordVerifyResponse> forgotPasswordVerify({
    required String verify_token,
    required String code,
  }) async {
    final response = await dio.post(
      _forgotPasswordVerifyPath,
      data: {"verify_token": verify_token, "code": code},
      options: Options(extra: {"requiresAuth": false}),
    );
    if (response.data is! Map<String, dynamic>) {
      throw Exception("Kod notog'ri yoki response noto'g'ri");
    }
    return ForgotPasswordVerifyResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<void> forgotPasswordReset(ForgotPasswordResetModel model) async {
    final response = await dio.post(
      _forgotPasswordResetPath,
      data: model.toJson(),
      options: Options(extra: {'requiresAuth': false}),
    );
    if (response.statusCode != 200) {
      throw Exception("Parol yangilanmadi");
    }
  }

  Future<void> changePassword(ChangePasswordModel model) async {
    final response = await dio.post(
      _changePassword,
      data: model.toJson(),
      options: Options(extra: {"requiresAuth": false}),
    );
    if (response.statusCode != 200) {
      throw Exception("Parol o'zgarmadi");
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    final response = await dio.get('/api/categories/defaults/');

    if (response.data is List) {
      final list = (response.data as List)
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return list; // Return all to let view filter them
    } else {
      throw Exception('Kategoriyalarni yuklashda xatolik yuz berdi');
    }
  }

  Future<List<CategoryModel>> getUserCategories() async {
    final response = await dio.get('/api/categories/');

    if (response.data is List) {
      return (response.data as List)
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('O\'z kategoriyalaringizni yuklashda xatolik');
    }
  }

  Future<void> selectDefaultCategories(List<int> categoryIds) async {
    final response = await dio.post(
      '/api/categories/select-defaults/',
      data: {'category_ids': categoryIds},
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Kategoriyalarni saqlashda xatolik yuz berdi');
    }
  }

  Future<UserCurrencyResponse> getUserCurrency() async {
    final response = await dio.get('/api/transactions/user-currency/');

    if (response.statusCode == 200 && response.data != null) {
      return UserCurrencyResponse.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw Exception('Valyutani yuklashda xatolik yuz berdi');
    }
  }

  Future<void> updateUserCurrency(int currencyId) async {
    final response = await dio.patch(
      '/api/transactions/user-currency/',
      data: {'currency': currencyId},
    );
    if (response.statusCode != 200) {
      throw Exception('Valyutani o\'zgartirishda xatolik yuz berdi');
    }
  }
  Future<TransactionModel> createTransaction(TransactionModel transaction) async {
    try {
      final response = await dio.post(
        ApiConstants.transactions,
        data: transaction.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TransactionModel.fromJson(response.data);
      } else {
        throw Exception('Failed to create transaction: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
        return 'Send timeout. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout. Please try again.';
      case DioExceptionType.badResponse:
        if (error.response?.data != null) {
          return 'Server error: ${error.response?.data}';
        }
        return 'Server error: ${error.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request cancelled.';
      default:
        return 'Network error: ${error.message}';
    }
  }
}
