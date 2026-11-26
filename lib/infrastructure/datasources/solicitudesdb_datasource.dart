import 'package:dio/dio.dart';
import 'package:stockalert_app/domain/datasources/solicitudes_datasource.dart';
import 'package:stockalert_app/domain/entities/pagina.dart';
import 'package:stockalert_app/domain/entities/solicitud.dart';
import 'package:stockalert_app/infrastructure/errors/api_error.dart';
import 'package:stockalert_app/infrastructure/mappers/solicitud_mapper.dart';
import 'package:stockalert_app/infrastructure/models/common/pagina_response.dart';
import 'package:stockalert_app/infrastructure/models/solicitudesdb/solicitud_response.dart';
import 'package:stockalert_app/infrastructure/providers/dio_provider.dart';

class SolicitudesDatasourceImpl implements SolicitudesDatasource {
  final Dio dio;

  SolicitudesDatasourceImpl({Dio? dio})
      : dio = dio ?? DioProvider.createDio();

  @override
  Future<Pagina<Solicitud>> listar({
    String? estado,
    int? idProducto,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await dio.get(
        '/solicitudes',
        queryParameters: {
          if (estado != null) 'estado': estado,
          if (idProducto != null) 'id_producto': idProducto,
          'page': page,
          'limit': limit,
        },
      );
      final pagina = PaginaResponse.fromJson(response.data);
      return Pagina<Solicitud>(
        data: pagina.data
            .map(
              (e) => SolicitudMapper.responseToEntity(
                SolicitudResponse.fromJson(Map<String, dynamic>.from(e)),
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
  Future<ResumenSolicitudes> resumen() async {
    try {
      final response = await dio.get('/solicitudes/resumen');
      return ResumenSolicitudes(
        pendiente: response.data['pendiente'] ?? 0,
        pedida: response.data['pedida'] ?? 0,
        recibida: response.data['recibida'] ?? 0,
        cancelada: response.data['cancelada'] ?? 0,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<Solicitud> obtener(int id) async {
    try {
      final response = await dio.get('/solicitudes/$id');
      return SolicitudMapper.responseToEntity(
        SolicitudResponse.fromJson(Map<String, dynamic>.from(response.data)),
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<Solicitud> editar(
    int id, {
    String? estado,
    int? cantidadSugerida,
    String? notas,
  }) async {
    try {
      final response = await dio.patch(
        '/solicitudes/$id',
        data: {
          if (estado != null) 'estado': estado,
          if (cantidadSugerida != null) 'cantidad_sugerida': cantidadSugerida,
          if (notas != null) 'notas': notas,
        },
      );
      return SolicitudMapper.responseToEntity(
        SolicitudResponse.fromJson(Map<String, dynamic>.from(response.data)),
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
