import 'package:stockalert_app/domain/entities/usuario.dart';

class Sesion {
  final String token;
  final int expiraEn;
  final String? refreshToken;
  final int? refreshExpiraEn;
  final Usuario usuario;

  const Sesion({
    required this.token,
    required this.expiraEn,
    required this.usuario,
    this.refreshToken,
    this.refreshExpiraEn,
  });
}
