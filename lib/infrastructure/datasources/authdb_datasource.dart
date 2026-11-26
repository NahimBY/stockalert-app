import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:stockalert_app/domain/datasources/auth_datasource.dart';
import 'package:stockalert_app/domain/entities/sesion.dart';
import 'package:stockalert_app/domain/entities/usuario.dart';
import 'package:stockalert_app/infrastructure/errors/api_error.dart';
import 'package:stockalert_app/infrastructure/mappers/auth_mapper.dart';
import 'package:stockalert_app/infrastructure/models/authdb/sesion_response.dart';
import 'package:stockalert_app/infrastructure/models/authdb/usuario_response.dart';
import 'package:stockalert_app/infrastructure/providers/dio_provider.dart';
import 'package:stockalert_app/infrastructure/services/key_value_storage_service.dart';

class AuthDatasourceImpl extends AuthDatasource {
  final Dio dio;

  AuthDatasourceImpl({Dio? dio}) : dio = dio ?? DioProvider.createDio();

  @override
  Future<Sesion> iniciarSesion({
    required String correo,
    required String contrasena,
  }) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {
          'correo': correo,
          'contrasena': contrasena,
          'cliente': 'movil',
        },
      );
      return _guardarSesion(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<Sesion> registrarNegocio({
    required String empresa,
    required String nombre,
    required String correo,
    required String contrasena,
  }) async {
    try {
      final response = await dio.post(
        '/auth/registro',
        data: {
          'empresa': empresa,
          'nombre': nombre,
          'correo': correo,
          'contrasena': contrasena,
          'cliente': 'movil',
        },
      );
      return _guardarSesion(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<Sesion> renovarSesion(String refreshToken) async {
    try {
      final response = await dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      return _guardarSesion(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<void> cerrarSesion(String? refreshToken) async {
    try {
      await dio.post(
        '/auth/logout',
        data: {
          if (refreshToken != null) 'refresh_token': refreshToken,
        },
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } finally {
      await Future.wait([
        KeyValueStorageService.remove('auth_token'),
        KeyValueStorageService.remove('refresh_token'),
        KeyValueStorageService.remove('auth_usuario'),
      ]);
    }
  }

  @override
  Future<Usuario> usuarioActual() async {
    try {
      final response = await dio.get('/auth/yo');
      final usuario = UsuarioResponse.fromJson(
        Map<String, dynamic>.from(response.data),
      );
      await KeyValueStorageService.setValue(
        'auth_usuario',
        jsonEncode(usuario.toJson()),
      );
      return AuthMapper.usuarioResponseToEntity(usuario);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<void> cambiarContrasena({
    required String actual,
    required String nueva,
  }) async {
    try {
      await dio.patch(
        '/auth/contrasena',
        data: {'actual': actual, 'nueva': nueva},
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<Sesion> _guardarSesion(dynamic data) async {
    final response = SesionResponse.fromJson(
      Map<String, dynamic>.from(data),
    );
    final sesion = AuthMapper.sesionResponseToEntity(response);

    await Future.wait([
      KeyValueStorageService.setValue('auth_token', sesion.token),
      KeyValueStorageService.setValue(
        'auth_usuario',
        jsonEncode(response.usuario.toJson()),
      ),
      if (sesion.refreshToken != null)
        KeyValueStorageService.setValue('refresh_token', sesion.refreshToken!),
    ]);

    return sesion;
  }
}
