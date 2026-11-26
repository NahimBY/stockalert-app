import 'package:stockalert_app/domain/datasources/empresas_datasource.dart';
import 'package:stockalert_app/domain/entities/empresa.dart';
import 'package:stockalert_app/domain/entities/pagina.dart';
import 'package:stockalert_app/domain/repositories/empresas_repository.dart';

class EmpresasRepositoryImpl implements EmpresasRepository {
  final EmpresasDatasource datasource;

  EmpresasRepositoryImpl(this.datasource);

  @override
  Future<Pagina<Empresa>> listar({
    String? q,
    String? estado,
    int page = 1,
    int limit = 20,
  }) {
    return datasource.listar(q: q, estado: estado, page: page, limit: limit);
  }

  @override
  Future<Empresa> crear({
    required String nombre,
    String? adminNombre,
    String? adminCorreo,
    String? adminContrasena,
  }) {
    return datasource.crear(
      nombre: nombre,
      adminNombre: adminNombre,
      adminCorreo: adminCorreo,
      adminContrasena: adminContrasena,
    );
  }

  @override
  Future<Empresa> obtener(int id) => datasource.obtener(id);

  @override
  Future<Empresa> editar(int id, {String? nombre, bool? estado}) =>
      datasource.editar(id, nombre: nombre, estado: estado);
}
