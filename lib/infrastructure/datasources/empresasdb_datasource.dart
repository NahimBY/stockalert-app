import 'package:dio/dio.dart';
import 'package:stockalert_app/domain/datasources/empresas_datasource.dart';
import 'package:stockalert_app/domain/entities/empresa.dart';
import 'package:stockalert_app/domain/entities/pagina.dart';
import 'package:stockalert_app/infrastructure/errors/api_error.dart';
import 'package:stockalert_app/infrastructure/mappers/empresa_mapper.dart';
import 'package:stockalert_app/infrastructure/models/common/pagina_response.dart';
import 'package:stockalert_app/infrastructure/models/empresasdb/empresa_response.dart';
import 'package:stockalert_app/infrastructure/providers/dio_provider.dart';

class EmpresasDatasourceImpl implements EmpresasDatasource {
  final Dio dio;

  EmpresasDatasourceImpl({Dio? dio}) : dio = dio ?? DioProvider.createDio();

  @override
  Future<Pagina<Empresa>> listar({
    String? q,
    String? estado,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await dio.get(
        '/empresas',
        queryParameters: {
          if (q != null && q.isNotEmpty) 'q': q,
          if (estado != null) 'estado': estado,
          'page': page,
          'limit': limit,
        },
      );
      final pagina = PaginaResponse.fromJson(response.data);
      return Pagina<Empresa>(
        data: pagina.data
            .map(
              (e) => EmpresaMapper.responseToEntity(
                EmpresaResponse.fromJson(Map<String, dynamic>.from(e)),
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
  Future<Empresa> crear({
    required String nombre,
    String? adminNombre,
    String? adminCorreo,
    String? adminContrasena,
  }) async {
    try {
      final tieneAdmin = adminNombre != null &&
          adminCorreo != null &&
          adminContrasena != null;
      final response = await dio.post(
        '/empresas',
        data: {
          'nombre': nombre,
          if (tieneAdmin)
            'admin': {
              'nombre': adminNombre,
              'correo': adminCorreo,
              'contrasena': adminContrasena,
            },
        },
      );
      return EmpresaMapper.responseToEntity(
        EmpresaResponse.fromJson(Map<String, dynamic>.from(response.data)),
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<Empresa> obtener(int id) async {
    try {
      final response = await dio.get('/empresas/$id');
      return EmpresaMapper.responseToEntity(
        EmpresaResponse.fromJson(Map<String, dynamic>.from(response.data)),
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<Empresa> editar(int id, {String? nombre, bool? estado}) async {
    try {
      final response = await dio.patch(
        '/empresas/$id',
        data: {
          if (nombre != null) 'nombre': nombre,
          if (estado != null) 'estado': estado,
        },
      );
      return EmpresaMapper.responseToEntity(
        EmpresaResponse.fromJson(Map<String, dynamic>.from(response.data)),
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
