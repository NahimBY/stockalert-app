import 'package:dio/dio.dart';
import 'package:stockalert_app/domain/datasources/movimientos_datasource.dart';
import 'package:stockalert_app/domain/entities/movimiento.dart';
import 'package:stockalert_app/domain/entities/pagina.dart';
import 'package:stockalert_app/infrastructure/errors/api_error.dart';
import 'package:stockalert_app/infrastructure/mappers/movimiento_mapper.dart';
import 'package:stockalert_app/infrastructure/models/common/pagina_response.dart';
import 'package:stockalert_app/infrastructure/models/movimientosdb/movimiento_registrado_response.dart';
import 'package:stockalert_app/infrastructure/models/movimientosdb/movimiento_response.dart';
import 'package:stockalert_app/infrastructure/providers/dio_provider.dart';

class MovimientosDatasourceImpl implements MovimientosDatasource {
  final Dio dio;

  MovimientosDatasourceImpl({Dio? dio})
      : dio = dio ?? DioProvider.createDio();

  @override
  Future<Pagina<Movimiento>> listar({
    String? q,
    String? tipo,
    String? categoria,
    int? idProducto,
    String? desde,
    String? hasta,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await dio.get(
        '/movimientos',
        queryParameters: {
          if (q != null && q.isNotEmpty) 'q': q,
          if (tipo != null) 'tipo': tipo,
          if (categoria != null && categoria.isNotEmpty) 'categoria': categoria,
          if (idProducto != null) 'id_producto': idProducto,
          if (desde != null) 'desde': desde,
          if (hasta != null) 'hasta': hasta,
          'page': page,
          'limit': limit,
        },
      );
      final pagina = PaginaResponse.fromJson(response.data);
      return Pagina<Movimiento>(
        data: pagina.data
            .map(
              (e) => MovimientoMapper.responseToEntity(
                MovimientoResponse.fromJson(Map<String, dynamic>.from(e)),
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
  Future<MovimientoRegistrado> registrar({
    required int idProducto,
    required String tipoMovimiento,
    required int cantidad,
    String? observaciones,
  }) async {
    try {
      final response = await dio.post(
        '/movimientos',
        data: {
          'id_producto': idProducto,
          'tipo_movimiento': tipoMovimiento,
          'cantidad': cantidad,
          if (observaciones != null) 'observaciones': observaciones,
        },
      );
      return MovimientoMapper.registradoToEntity(
        MovimientoRegistradoResponse.fromJson(
          Map<String, dynamic>.from(response.data),
        ),
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<Movimiento> obtener(int id) async {
    try {
      final response = await dio.get('/movimientos/$id');
      return MovimientoMapper.responseToEntity(
        MovimientoResponse.fromJson(
          Map<String, dynamic>.from(response.data),
        ),
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
