import 'package:stockalert_app/domain/entities/alerta.dart';
import 'package:stockalert_app/domain/entities/pagina.dart';

abstract class AlertasRepository {
  Future<Pagina<Alerta>> listar({
    String? estado,
    String? tipo,
    int? idProducto,
    int page = 1,
    int limit = 20,
  });

  Future<ResumenAlertas> resumen();

  Future<Alerta> obtener(int id);

  Future<Alerta> cambiarEstado(int id, String estado);
}
