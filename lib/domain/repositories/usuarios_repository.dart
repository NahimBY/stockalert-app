import 'package:stockalert_app/domain/entities/pagina.dart';
import 'package:stockalert_app/domain/entities/usuario.dart';

abstract class UsuariosRepository {
  Future<Pagina<Usuario>> listar({
    String? q,
    String? rol,
    String? estado,
    int? idEmpresa,
    int page = 1,
    int limit = 20,
  });

  Future<Usuario> crear({
    required String nombre,
    required String correo,
    required String contrasena,
    required String rol,
    int? idEmpresa,
  });

  Future<Usuario> obtener(int id);

  Future<Usuario> editar(
    int id, {
    String? nombre,
    String? correo,
    String? rol,
    bool? estado,
    String? contrasena,
  });
}
