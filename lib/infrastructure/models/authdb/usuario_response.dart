class UsuarioResponse {
  final int id;
  final String nombre;
  final String correo;
  final String rol;
  final int? empresaId;
  final String? empresaNombre;
  final bool estado;
  final DateTime? fechaRegistro;

  const UsuarioResponse({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.rol,
    this.empresaId,
    this.empresaNombre,
    this.estado = true,
    this.fechaRegistro,
  });

  factory UsuarioResponse.fromJson(Map<String, dynamic> json) {
    final empresa = json['empresa'];
    int? empresaId;
    String? empresaNombre;

    if (empresa is Map) {
      empresaId = _asInt(empresa['id_empresa']);
      empresaNombre = empresa['nombre'] as String?;
    } else {
      empresaId = _asInt(json['id_empresa']);
      empresaNombre = empresa as String?;
    }

    return UsuarioResponse(
      id: _asInt(json['id_usuario']) ?? 0,
      nombre: json['nombre'] ?? '',
      correo: json['correo'] ?? '',
      rol: json['rol'] ?? '',
      empresaId: empresaId,
      empresaNombre: empresaNombre,
      estado: json['estado'] ?? true,
      fechaRegistro: json['fecha_registro'] != null
          ? DateTime.tryParse(json['fecha_registro'])
          : null,
    );
  }

  static int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return null;
  }

  Map<String, dynamic> toJson() => {
    'id_usuario': id,
    'nombre': nombre,
    'correo': correo,
    'rol': rol,
    'id_empresa': empresaId,
    'empresa': empresaNombre,
    'estado': estado,
    'fecha_registro': fechaRegistro?.toIso8601String(),
  };
}
