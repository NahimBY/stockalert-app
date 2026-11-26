import 'package:stockalert_app/domain/entities/sesion.dart';
import 'package:stockalert_app/domain/entities/usuario.dart';
import 'package:stockalert_app/infrastructure/models/authdb/sesion_response.dart';
import 'package:stockalert_app/infrastructure/models/authdb/usuario_response.dart';

class AuthMapper {
  static Usuario usuarioResponseToEntity(UsuarioResponse response) => Usuario(
        id: response.id,
        nombre: response.nombre,
        correo: response.correo,
        rol: response.rol,
        empresaId: response.empresaId,
        empresaNombre: response.empresaNombre,
        estado: response.estado,
        fechaRegistro: response.fechaRegistro,
      );

  static Sesion sesionResponseToEntity(SesionResponse response) => Sesion(
        token: response.token,
        expiraEn: response.expiraEn,
        refreshToken: response.refreshToken,
        refreshExpiraEn: response.refreshExpiraEn,
        usuario: usuarioResponseToEntity(response.usuario),
      );
}
