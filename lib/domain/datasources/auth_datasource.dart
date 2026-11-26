import 'package:stockalert_app/domain/entities/sesion.dart';
import 'package:stockalert_app/domain/entities/usuario.dart';

abstract class AuthDatasource {
  Future<Sesion> iniciarSesion({
    required String correo,
    required String contrasena,
  });

  Future<Sesion> registrarNegocio({
    required String empresa,
    required String nombre,
    required String correo,
    required String contrasena,
  });

  Future<Sesion> renovarSesion(String refreshToken);

  Future<void> cerrarSesion(String? refreshToken);

  Future<Usuario> usuarioActual();

  Future<void> cambiarContrasena({
    required String actual,
    required String nueva,
  });
}
