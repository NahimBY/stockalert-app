import 'package:stockalert_app/infrastructure/models/authdb/usuario_response.dart';

class SesionResponse {
  final String token;
  final int expiraEn;
  final String? refreshToken;
  final int? refreshExpiraEn;
  final UsuarioResponse usuario;

  const SesionResponse({
    required this.token,
    required this.expiraEn,
    required this.usuario,
    this.refreshToken,
    this.refreshExpiraEn,
  });

  factory SesionResponse.fromJson(Map<String, dynamic> json) => SesionResponse(
        token: json['token'] ?? '',
        expiraEn: (json['expira_en'] as num?)?.toInt() ?? 900,
        refreshToken: json['refresh_token'] as String?,
        refreshExpiraEn: (json['refresh_expira_en'] as num?)?.toInt(),
        usuario: UsuarioResponse.fromJson(
          Map<String, dynamic>.from(json['usuario']),
        ),
      );
}
