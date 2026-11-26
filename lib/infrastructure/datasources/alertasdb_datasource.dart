import 'package:dio/dio.dart';
import 'package:stockalert_app/domain/datasources/alertas_datasource.dart';
import 'package:stockalert_app/domain/entities/alerta.dart';
import 'package:stockalert_app/domain/entities/pagina.dart';
import 'package:stockalert_app/infrastructure/errors/api_error.dart';
import 'package:stockalert_app/infrastructure/mappers/alerta_mapper.dart';
import 'package:stockalert_app/infrastructure/models/alertasdb/alerta_response.dart';
import 'package:stockalert_app/infrastructure/models/common/pagina_response.dart';
import 'package:stockalert_app/infrastructure/providers/dio_provider.dart';

class AlertasDatasourceImpl implements AlertasDatasource {
  final Dio dio;

  AlertasDatasourceImpl({Dio? dio}) : dio = dio ?? DioProvider.createDio();

  @override
  Future<Pagina<Alerta>> listar({
    String? estado,
    String? tipo,
    int? idProducto,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await dio.get(
        '/alertas',
        queryParameters: {
          if (estado != null) 'estado': estado,
          if (tipo != null) 'tipo': tipo,
          if (idProducto != null) 'id_producto': idProducto,
          'page': page,
          'limit': limit,
        },
      );
      final pagina = PaginaResponse.fromJson(response.data);
      return Pagina<Alerta>(
        data: pagina.data
            .map(
              (e) => AlertaMapper.responseToEntity(
                AlertaResponse.fromJson(Map<String, dynamic>.from(e)),
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
  Future<ResumenAlertas> resumen() async {
    try {
      final response = await dio.get('/alertas/resumen');
      return ResumenAlertas(
        pendientes: response.data['pendientes'] ?? 0,
        total: response.data['total'] ?? 0,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<Alerta> obtener(int id) async {
    try {
      final response = await dio.get('/alertas/$id');
      return AlertaMapper.responseToEntity(
        AlertaResponse.fromJson(Map<String, dynamic>.from(response.data)),
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<Alerta> cambiarEstado(int id, String estado) async {
    try {
      final response = await dio.patch(
        '/alertas/$id',
        data: {'estado': estado},
      );
      return AlertaMapper.responseToEntity(
        AlertaResponse.fromJson(Map<String, dynamic>.from(response.data)),
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
