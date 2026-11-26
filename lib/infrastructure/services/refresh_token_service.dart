import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:stockalert_app/infrastructure/models/authdb/sesion_response.dart';
import 'package:stockalert_app/infrastructure/providers/dio_provider.dart';
import 'package:stockalert_app/infrastructure/services/key_value_storage_service.dart';

class RefreshTokenService {
  static RefreshTokenService? _instance;
  late Dio dio;

  Function()? onTokenExpired;
  Function(String)? onTokenRefreshed;

  RefreshTokenService._() {
    dio = Dio(
      BaseOptions(
        baseUrl: DioProvider.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        contentType: Headers.jsonContentType,
      ),
    );
  }

  static RefreshTokenService get instance {
    _instance ??= RefreshTokenService._();
    return _instance!;
  }

  String? get accessToken => KeyValueStorageService.getString('auth_token');
  String? get refreshToken => KeyValueStorageService.getString('refresh_token');

  Future<String?> refreshAccessToken() async {
    final token = refreshToken;
    if (token == null) {
      onTokenExpired?.call();
      return null;
    }

    try {
      final response = await dio.post(
        '/auth/refresh',
        data: {'refresh_token': token},
      );

      final sesion = SesionResponse.fromJson(response.data);

      await Future.wait([
        KeyValueStorageService.setValue('auth_token', sesion.token),
        KeyValueStorageService.setValue(
          'auth_usuario',
          jsonEncode(sesion.usuario.toJson()),
        ),
        if (sesion.refreshToken != null)
          KeyValueStorageService.setValue(
            'refresh_token',
            sesion.refreshToken!,
          ),
      ]);

      onTokenRefreshed?.call(sesion.token);
      return sesion.token;
    } catch (_) {
      onTokenExpired?.call();
      return null;
    }
  }
}
