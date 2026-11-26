class AlertaResponse {
  final int id;
  final int idProducto;
  final String producto;
  final String? categoria;
  final String tipo;
  final int stockDetectado;
  final DateTime? fechaGeneracion;
  final String estado;
  final DateTime? fechaAtencion;

  const AlertaResponse({
    required this.id,
    required this.idProducto,
    required this.producto,
    required this.tipo,
    required this.stockDetectado,
    required this.estado,
    this.categoria,
    this.fechaGeneracion,
    this.fechaAtencion,
  });

  factory AlertaResponse.fromJson(Map<String, dynamic> json) => AlertaResponse(
        id: (json['id_alerta'] as num?)?.toInt() ?? 0,
        idProducto: (json['id_producto'] as num?)?.toInt() ?? 0,
        producto: json['producto'] ?? '',
        categoria: json['categoria'] as String?,
        tipo: json['tipo_alerta'] ?? '',
        stockDetectado: (json['stock_detectado'] as num?)?.toInt() ?? 0,
        fechaGeneracion: json['fecha_generacion'] != null
            ? DateTime.tryParse(json['fecha_generacion'])
            : null,
        estado: json['estado'] ?? '',
        fechaAtencion: json['fecha_atencion'] != null
            ? DateTime.tryParse(json['fecha_atencion'])
            : null,
      );
}
