class MovimientoResponse {
  final int id;
  final DateTime? fecha;
  final String tipo;
  final int cantidad;
  final String? observaciones;
  final int idProducto;
  final String producto;
  final String? categoria;
  final int idUsuario;
  final String usuario;

  const MovimientoResponse({
    required this.id,
    required this.tipo,
    required this.cantidad,
    required this.idProducto,
    required this.producto,
    required this.idUsuario,
    required this.usuario,
    this.fecha,
    this.observaciones,
    this.categoria,
  });

  factory MovimientoResponse.fromJson(Map<String, dynamic> json) =>
      MovimientoResponse(
        id: (json['id_movimiento'] as num?)?.toInt() ?? 0,
        fecha: json['fecha_movimiento'] != null
            ? DateTime.tryParse(json['fecha_movimiento'])
            : null,
        tipo: json['tipo_movimiento'] ?? '',
        cantidad: (json['cantidad'] as num?)?.toInt() ?? 0,
        observaciones: json['observaciones'] as String?,
        idProducto: (json['id_producto'] as num?)?.toInt() ?? 0,
        producto: json['producto'] ?? '',
        categoria: json['categoria'] as String?,
        idUsuario: (json['id_usuario'] as num?)?.toInt() ?? 0,
        usuario: json['usuario'] ?? '',
      );
}
