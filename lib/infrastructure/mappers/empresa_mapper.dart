import 'package:stockalert_app/domain/entities/empresa.dart';
import 'package:stockalert_app/infrastructure/models/empresasdb/empresa_response.dart';

class EmpresaMapper {
  static Empresa responseToEntity(EmpresaResponse response) => Empresa(
        id: response.id,
        nombre: response.nombre,
        fechaRegistro: response.fechaRegistro,
        estado: response.estado,
        usuarios: response.usuarios,
        productos: response.productos,
      );
}
