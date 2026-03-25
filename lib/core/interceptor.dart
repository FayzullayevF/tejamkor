import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tejamkor/core/routing/router.dart';
import 'package:tejamkor/core/secure_storage.dart';
import '../main.dart';
import 'data/repos/auth_repository.dart';

class AuthInterceptor extends Interceptor {
  final Dio _dio = Dio();

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {

    final requiresAuth = options.extra['requiresAuth'] ?? true;

    if (!requiresAuth) {
      return handler.next(options);
    }

    final jwt = await AppSecureStorage.getToken();

    if (jwt != null) {
      options.headers['Authorization'] = "Bearer $jwt";
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {

    final requiresAuth = err.requestOptions.extra['requiresAuth'] ?? true;

    if (!requiresAuth) {
      return handler.next(err);
    }

    if (err.response?.statusCode == 401) {

      final ctx = navigatorKey.currentContext;

      if (ctx == null) {
        return handler.next(err);
      }

      final result = await ctx.read<AuthRepository>().refreshToken();

      if (result) {

        final jwt = await AppSecureStorage.getToken();

        err.requestOptions.headers['Authorization'] = "Bearer $jwt";

        return handler.resolve(
          await _dio.request(
            err.requestOptions.baseUrl + err.requestOptions.path,
            options: Options(
              method: err.requestOptions.method,
              headers: err.requestOptions.headers,
            ),
            data: err.requestOptions.data,
            queryParameters: err.requestOptions.queryParameters,
          ),
        );

      } else {

        await ctx.read<AuthRepository>().logout();
        ctx.go(Routers.login);

        return handler.reject(err);
      }
    }

    handler.next(err);
  }
}