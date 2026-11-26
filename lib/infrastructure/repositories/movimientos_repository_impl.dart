import 'package:stockalert_app/domain/datasources/movimientos_datasource.dart';
import 'package:stockalert_app/domain/entities/movimiento.dart';
import 'package:stockalert_app/domain/entities/pagina.dart';
import 'package:stockalert_app/domain/repositories/movimientos_repository.dart';

class MovimientosRepositoryImpl implements MovimientosRepository {
  final MovimientosDatasource datasource;

  MovimientosRepositoryImpl(this.datasource);

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
  }) {
    return datasource.listar(
      q: q,
      tipo: tipo,
      categoria: categoria,
      idProducto: idProducto,
      desde: desde,
      hasta: hasta,
      page: page,
      limit: limit,
    );
  }

  @override
  Future<MovimientoRegistrado> registrar({
    required int idProducto,
    required String tipoMovimiento,
    required int cantidad,
    String? observaciones,
  }) {
    return datasource.registrar(
      idProducto: idProducto,
      tipoMovimiento: tipoMovimiento,
      cantidad: cantidad,
      observaciones: observaciones,
    );
  }

  @override
  Future<Movimiento> obtener(int id) => datasource.obtener(id);
}
