import 'package:stockalert_app/domain/entities/empresa.dart';
import 'package:stockalert_app/domain/entities/pagina.dart';

abstract class EmpresasRepository {
  Future<Pagina<Empresa>> listar({
    String? q,
    String? estado,
    int page = 1,
    int limit = 20,
  });

  Future<Empresa> crear({
    required String nombre,
    String? adminNombre,
    String? adminCorreo,
    String? adminContrasena,
  });

  Future<Empresa> obtener(int id);

  Future<Empresa> editar(int id, {String? nombre, bool? estado});
}
