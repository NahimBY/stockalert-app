class EmpresaResponse {
  final int id;
  final String nombre;
  final DateTime? fechaRegistro;
  final bool estado;
  final int usuarios;
  final int productos;

  const EmpresaResponse({
    required this.id,
    required this.nombre,
    required this.estado,
    required this.usuarios,
    required this.productos,
    this.fechaRegistro,
  });

  factory EmpresaResponse.fromJson(Map<String, dynamic> json) => EmpresaResponse(
        id: (json['id_empresa'] as num?)?.toInt() ?? 0,
        nombre: json['nombre'] ?? '',
        fechaRegistro: json['fecha_registro'] != null
            ? DateTime.tryParse(json['fecha_registro'])
            : null,
        estado: json['estado'] ?? true,
        usuarios: (json['usuarios'] as num?)?.toInt() ?? 0,
        productos: (json['productos'] as num?)?.toInt() ?? 0,
      );
}
