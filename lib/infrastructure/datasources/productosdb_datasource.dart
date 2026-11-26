import 'package:dio/dio.dart';
import 'package:stockalert_app/domain/datasources/productos_datasource.dart';
import 'package:stockalert_app/domain/entities/pagina.dart';
import 'package:stockalert_app/domain/entities/producto.dart';
import 'package:stockalert_app/infrastructure/errors/api_error.dart';
import 'package:stockalert_app/infrastructure/mappers/producto_mapper.dart';
import 'package:stockalert_app/infrastructure/models/common/pagina_response.dart';
import 'package:stockalert_app/infrastructure/models/productosdb/producto_response.dart';
import 'package:stockalert_app/infrastructure/providers/dio_provider.dart';

class ProductosDatasourceImpl implements ProductosDatasource {
  final Dio dio;

  ProductosDatasourceImpl({Dio? dio}) : dio = dio ?? DioProvider.createDio();

  @override
  Future<Pagina<Producto>> listar({
    String? q,
    String? estado,
    String? categoria,
    String activo = 'true',
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await dio.get(
        '/productos',
        queryParameters: {
          if (q != null && q.isNotEmpty) 'q': q,
          if (estado != null) 'estado': estado,
          if (categoria != null && categoria.isNotEmpty) 'categoria': categoria,
          'activo': activo,
          'page': page,
          'limit': limit,
        },
      );
      final pagina = PaginaResponse.fromJson(response.data);
      return Pagina<Producto>(
        data: pagina.data
            .map(
              (e) => ProductoMapper.responseToEntity(
                ProductoResponse.fromJson(Map<String, dynamic>.from(e)),
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
  Future<Producto> crear({
    required String nombre,
    String? descripcion,
    String? categoria,
    required double precio,
    required int stockMinimo,
    int stockInicial = 0,
  }) async {
    try {
      final response = await dio.post(
        '/productos',
        data: {
          'nombre': nombre,
          if (descripcion != null) 'descripcion': descripcion,
          if (categoria != null) 'categoria': categoria,
          'precio': precio,
          'stock_minimo': stockMinimo,
          'stock_inicial': stockInicial,
        },
      );
      return ProductoMapper.responseToEntity(
        ProductoResponse.fromJson(Map<String, dynamic>.from(response.data)),
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<Producto> obtener(int id) async {
    try {
      final response = await dio.get('/productos/$id');
      return ProductoMapper.responseToEntity(
        ProductoResponse.fromJson(Map<String, dynamic>.from(response.data)),
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<Producto> editar(
    int id, {
    String? nombre,
    String? descripcion,
    String? categoria,
    double? precio,
    int? stockMinimo,
    bool? estado,
  }) async {
    try {
      final response = await dio.patch(
        '/productos/$id',
        data: {
          if (nombre != null) 'nombre': nombre,
          if (descripcion != null) 'descripcion': descripcion,
          if (categoria != null) 'categoria': categoria,
          if (precio != null) 'precio': precio,
          if (stockMinimo != null) 'stock_minimo': stockMinimo,
          if (estado != null) 'estado': estado,
        },
      );
      return ProductoMapper.responseToEntity(
        ProductoResponse.fromJson(Map<String, dynamic>.from(response.data)),
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<void> desactivar(int id) async {
    try {
      await dio.delete('/productos/$id');
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
