import 'package:stockalert_app/domain/datasources/productos_datasource.dart';
import 'package:stockalert_app/domain/entities/pagina.dart';
import 'package:stockalert_app/domain/entities/producto.dart';
import 'package:stockalert_app/domain/repositories/productos_repository.dart';

class ProductosRepositoryImpl implements ProductosRepository {
  final ProductosDatasource datasource;

  ProductosRepositoryImpl(this.datasource);

  @override
  Future<Pagina<Producto>> listar({
    String? q,
    String? estado,
    String? categoria,
    String activo = 'true',
    int page = 1,
    int limit = 20,
  }) {
    return datasource.listar(
      q: q,
      estado: estado,
      categoria: categoria,
      activo: activo,
      page: page,
      limit: limit,
    );
  }

  @override
  Future<Producto> crear({
    required String nombre,
    String? descripcion,
    String? categoria,
    required double precio,
    required int stockMinimo,
    int stockInicial = 0,
  }) {
    return datasource.crear(
      nombre: nombre,
      descripcion: descripcion,
      categoria: categoria,
      precio: precio,
      stockMinimo: stockMinimo,
      stockInicial: stockInicial,
    );
  }

  @override
  Future<Producto> obtener(int id) => datasource.obtener(id);

  @override
  Future<Producto> editar(
    int id, {
    String? nombre,
    String? descripcion,
    String? categoria,
    double? precio,
    int? stockMinimo,
    bool? estado,
  }) {
    return datasource.editar(
      id,
      nombre: nombre,
      descripcion: descripcion,
      categoria: categoria,
      precio: precio,
      stockMinimo: stockMinimo,
      estado: estado,
    );
  }

  @override
  Future<void> desactivar(int id) => datasource.desactivar(id);
}
