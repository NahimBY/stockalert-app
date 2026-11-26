import 'package:stockalert_app/domain/datasources/auth_datasource.dart';
import 'package:stockalert_app/domain/entities/sesion.dart';
import 'package:stockalert_app/domain/entities/usuario.dart';
import 'package:stockalert_app/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl(this.datasource);

  @override
  Future<Sesion> iniciarSesion({
    required String correo,
    required String contrasena,
  }) {
    return datasource.iniciarSesion(correo: correo, contrasena: contrasena);
  }

  @override
  Future<Sesion> registrarNegocio({
    required String empresa,
    required String nombre,
    required String correo,
    required String contrasena,
  }) {
    return datasource.registrarNegocio(
      empresa: empresa,
      nombre: nombre,
      correo: correo,
      contrasena: contrasena,
    );
  }

  @override
  Future<Sesion> renovarSesion(String refreshToken) {
    return datasource.renovarSesion(refreshToken);
  }

  @override
  Future<void> cerrarSesion(String? refreshToken) {
    return datasource.cerrarSesion(refreshToken);
  }

  @override
  Future<Usuario> usuarioActual() {
    return datasource.usuarioActual();
  }

  @override
  Future<void> cambiarContrasena({
    required String actual,
    required String nueva,
  }) {
    return datasource.cambiarContrasena(actual: actual, nueva: nueva);
  }
}
