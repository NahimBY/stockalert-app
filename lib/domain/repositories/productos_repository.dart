import 'package:stockalert_app/domain/entities/pagina.dart';
import 'package:stockalert_app/domain/entities/producto.dart';

abstract class ProductosRepository {
  Future<Pagina<Producto>> listar({
    String? q,
    String? estado,
    String? categoria,
    String activo = 'true',
    int page = 1,
    int limit = 20,
  });

  Future<Producto> crear({
    required String nombre,
    String? descripcion,
    String? categoria,
    required double precio,
    required int stockMinimo,
    int stockInicial = 0,
  });

  Future<Producto> obtener(int id);

  Future<Producto> editar(
    int id, {
    String? nombre,
    String? descripcion,
    String? categoria,
    double? precio,
    int? stockMinimo,
    bool? estado,
  });

  Future<void> desactivar(int id);
}
