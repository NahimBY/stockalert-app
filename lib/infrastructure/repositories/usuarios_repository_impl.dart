import 'package:stockalert_app/domain/datasources/usuarios_datasource.dart';
import 'package:stockalert_app/domain/entities/pagina.dart';
import 'package:stockalert_app/domain/entities/usuario.dart';
import 'package:stockalert_app/domain/repositories/usuarios_repository.dart';

class UsuariosRepositoryImpl implements UsuariosRepository {
  final UsuariosDatasource datasource;

  UsuariosRepositoryImpl(this.datasource);

  @override
  Future<Pagina<Usuario>> listar({
    String? q,
    String? rol,
    String? estado,
    int? idEmpresa,
    int page = 1,
    int limit = 20,
  }) {
    return datasource.listar(
      q: q,
      rol: rol,
      estado: estado,
      idEmpresa: idEmpresa,
      page: page,
      limit: limit,
    );
  }

  @override
  Future<Usuario> crear({
    required String nombre,
    required String correo,
    required String contrasena,
    required String rol,
    int? idEmpresa,
  }) {
    return datasource.crear(
      nombre: nombre,
      correo: correo,
      contrasena: contrasena,
      rol: rol,
      idEmpresa: idEmpresa,
    );
  }

  @override
  Future<Usuario> obtener(int id) => datasource.obtener(id);

  @override
  Future<Usuario> editar(
    int id, {
    String? nombre,
    String? correo,
    String? rol,
    bool? estado,
    String? contrasena,
  }) {
    return datasource.editar(
      id,
      nombre: nombre,
      correo: correo,
      rol: rol,
      estado: estado,
      contrasena: contrasena,
    );
  }
}
