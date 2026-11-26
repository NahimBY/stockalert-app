import 'package:stockalert_app/domain/entities/pagina.dart';
import 'package:stockalert_app/domain/entities/solicitud.dart';

abstract class SolicitudesRepository {
  Future<Pagina<Solicitud>> listar({
    String? estado,
    int? idProducto,
    int page = 1,
    int limit = 20,
  });

  Future<ResumenSolicitudes> resumen();

  Future<Solicitud> obtener(int id);

  Future<Solicitud> editar(
    int id, {
    String? estado,
    int? cantidadSugerida,
    String? notas,
  });
}
