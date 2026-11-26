import 'package:stockalert_app/domain/datasources/alertas_datasource.dart';
import 'package:stockalert_app/domain/entities/alerta.dart';
import 'package:stockalert_app/domain/entities/pagina.dart';
import 'package:stockalert_app/domain/repositories/alertas_repository.dart';

class AlertasRepositoryImpl implements AlertasRepository {
  final AlertasDatasource datasource;

  AlertasRepositoryImpl(this.datasource);

  @override
  Future<Pagina<Alerta>> listar({
    String? estado,
    String? tipo,
    int? idProducto,
    int page = 1,
    int limit = 20,
  }) {
    return datasource.listar(
      estado: estado,
      tipo: tipo,
      idProducto: idProducto,
      page: page,
      limit: limit,
    );
  }

  @override
  Future<ResumenAlertas> resumen() => datasource.resumen();

  @override
  Future<Alerta> obtener(int id) => datasource.obtener(id);

  @override
  Future<Alerta> cambiarEstado(int id, String estado) =>
      datasource.cambiarEstado(id, estado);
}
