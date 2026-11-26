import 'package:dio/dio.dart';
import 'package:stockalert_app/infrastructure/interceptors/auth_interceptor.dart';
import 'package:stockalert_app/infrastructure/services/refresh_token_service.dart';

class DioProvider {
  static const String baseUrl = 'https://stockalert-beta.vercel.app/api';

  static Dio createDio({bool handleRefresh = true}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        contentType: Headers.jsonContentType,
      ),
    );

    dio.interceptors.add(
      AuthInterceptor(
        refreshService: RefreshTokenService.instance,
        handleRefresh: handleRefresh,
      ),
    );

    return dio;
  }
}
