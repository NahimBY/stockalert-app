import 'package:dio/dio.dart';
import 'package:stockalert_app/domain/datasources/usuarios_datasource.dart';
import 'package:stockalert_app/domain/entities/pagina.dart';
import 'package:stockalert_app/domain/entities/usuario.dart';
import 'package:stockalert_app/infrastructure/errors/api_error.dart';
import 'package:stockalert_app/infrastructure/mappers/auth_mapper.dart';
import 'package:stockalert_app/infrastructure/models/authdb/usuario_response.dart';
import 'package:stockalert_app/infrastructure/models/common/pagina_response.dart';
import 'package:stockalert_app/infrastructure/providers/dio_provider.dart';

class UsuariosDatasourceImpl implements UsuariosDatasource {
  final Dio dio;

  UsuariosDatasourceImpl({Dio? dio}) : dio = dio ?? DioProvider.createDio();

  @override
  Future<Pagina<Usuario>> listar({
    String? q,
    String? rol,
    String? estado,
    int? idEmpresa,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await dio.get(
        '/usuarios',
        queryParameters: {
          if (q != null && q.isNotEmpty) 'q': q,
          if (rol != null) 'rol': rol,
          if (estado != null) 'estado': estado,
          if (idEmpresa != null) 'id_empresa': idEmpresa,
          'page': page,
          'limit': limit,
        },
      );
      final pagina = PaginaResponse.fromJson(response.data);
      return Pagina<Usuario>(
        data: pagina.data
            .map(
              (e) => AuthMapper.usuarioResponseToEntity(
                UsuarioResponse.fromJson(Map<String, dynamic>.from(e)),
              ),
            )
            .toList(),
        page: pagina.page,
        limit: pagina.limit,
        total: pagina.total,
        totalPages: pagina.totalPages,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<Usuario> crear({
    required String nombre,
    required String correo,
    required String contrasena,
    required String rol,
    int? idEmpresa,
  }) async {
    try {
      final response = await dio.post(
        '/usuarios',
        data: {
          'nombre': nombre,
          'correo': correo,
          'contrasena': contrasena,
          'rol': rol,
          if (idEmpresa != null) 'id_empresa': idEmpresa,
        },
      );
      return AuthMapper.usuarioResponseToEntity(
        UsuarioResponse.fromJson(Map<String, dynamic>.from(response.data)),
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<Usuario> obtener(int id) async {
    try {
      final response = await dio.get('/usuarios/$id');
      return AuthMapper.usuarioResponseToEntity(
        UsuarioResponse.fromJson(Map<String, dynamic>.from(response.data)),
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<Usuario> editar(
    int id, {
    String? nombre,
    String? correo,
    String? rol,
    bool? estado,
    String? contrasena,
  }) async {
    try {
      final response = await dio.patch(
        '/usuarios/$id',
        data: {
          if (nombre != null) 'nombre': nombre,
          if (correo != null) 'correo': correo,
          if (rol != null) 'rol': rol,
          if (estado != null) 'estado': estado,
          if (contrasena != null) 'contrasena': contrasena,
        },
      );
      return AuthMapper.usuarioResponseToEntity(
        UsuarioResponse.fromJson(Map<String, dynamic>.from(response.data)),
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
