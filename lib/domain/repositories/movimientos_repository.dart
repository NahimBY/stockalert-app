import 'package:stockalert_app/domain/entities/movimiento.dart';
import 'package:stockalert_app/domain/entities/pagina.dart';

abstract class MovimientosRepository {
  Future<Pagina<Movimiento>> listar({
    String? q,
    String? tipo,
    String? categoria,
    int? idProducto,
    String? desde,
    String? hasta,
    int page = 1,
    int limit = 20,
  });

  Future<MovimientoRegistrado> registrar({
    required int idProducto,
    required String tipoMovimiento,
    required int cantidad,
    String? observaciones,
  });

  Future<Movimiento> obtener(int id);
}
