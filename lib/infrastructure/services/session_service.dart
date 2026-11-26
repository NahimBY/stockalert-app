import 'dart:convert';

import 'package:stockalert_app/domain/entities/usuario.dart';
import 'package:stockalert_app/infrastructure/mappers/auth_mapper.dart';
import 'package:stockalert_app/infrastructure/models/authdb/usuario_response.dart';
import 'package:stockalert_app/infrastructure/services/key_value_storage_service.dart';
import 'package:stockalert_app/infrastructure/services/refresh_token_service.dart';
import 'package:stockalert_app/infrastructure/services/token_service.dart';

class SessionService {
  static Future<Usuario?> restore() async {
    final accessToken = KeyValueStorageService.getString('auth_token');
    if (accessToken == null) return null;

    if (!_isExpired(accessToken)) {
      return usuarioGuardado();
    }

    final refreshToken = KeyValueStorageService.getString('refresh_token');
    if (refreshToken == null) {
      await limpiar();
      return null;
    }

    final newToken = await RefreshTokenService.instance.refreshAccessToken();
    if (newToken == null) {
      await limpiar();
      return null;
    }

    return usuarioGuardado();
  }

  static Usuario? usuarioGuardado() {
    final raw = KeyValueStorageService.getString('auth_usuario');
    if (raw == null) return null;
    try {
      final json = Map<String, dynamic>.from(jsonDecode(raw) as Map);
      return AuthMapper.usuarioResponseToEntity(UsuarioResponse.fromJson(json));
    } catch (_) {
      return null;
    }
  }

  static Future<void> limpiar() async {
    await Future.wait([
      KeyValueStorageService.remove('auth_token'),
      KeyValueStorageService.remove('refresh_token'),
      KeyValueStorageService.remove('auth_usuario'),
    ]);
  }

  static bool _isExpired(String token) {
    try {
      return TokenService.isTokenExpired(token);
    } catch (_) {
      return true;
    }
  }
}
