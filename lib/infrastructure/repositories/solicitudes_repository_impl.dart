import 'package:stockalert_app/domain/datasources/solicitudes_datasource.dart';
import 'package:stockalert_app/domain/entities/pagina.dart';
import 'package:stockalert_app/domain/entities/solicitud.dart';
import 'package:stockalert_app/domain/repositories/solicitudes_repository.dart';

class SolicitudesRepositoryImpl implements SolicitudesRepository {
  final SolicitudesDatasource datasource;

  SolicitudesRepositoryImpl(this.datasource);

  @override
  Future<Pagina<Solicitud>> listar({
    String? estado,
    int? idProducto,
    int page = 1,
    int limit = 20,
  }) {
    return datasource.listar(
      estado: estado,
      idProducto: idProducto,
      page: page,
      limit: limit,
    );
  }

  @override
  Future<ResumenSolicitudes> resumen() => datasource.resumen();

  @override
  Future<Solicitud> obtener(int id) => datasource.obtener(id);

  @override
  Future<Solicitud> editar(
    int id, {
    String? estado,
    int? cantidadSugerida,
    String? notas,
  }) {
    return datasource.editar(
      id,
      estado: estado,
      cantidadSugerida: cantidadSugerida,
      notas: notas,
    );
  }
}
