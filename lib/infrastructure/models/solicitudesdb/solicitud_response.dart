class SolicitudResponse {
  final int id;
  final int idProducto;
  final String producto;
  final String? categoria;
  final int stockActual;
  final int stockMinimo;
  final int? idAlerta;
  final String? tipoAlerta;
  final int cantidadSugerida;
  final String estado;
  final String? notas;
  final DateTime? fechaCreacion;
  final DateTime? fechaActualizacion;

  const SolicitudResponse({
    required this.id,
    required this.idProducto,
    required this.producto,
    required this.stockActual,
    required this.stockMinimo,
    required this.cantidadSugerida,
    required this.estado,
    this.categoria,
    this.idAlerta,
    this.tipoAlerta,
    this.notas,
    this.fechaCreacion,
    this.fechaActualizacion,
  });

  factory SolicitudResponse.fromJson(Map<String, dynamic> json) =>
      SolicitudResponse(
        id: (json['id_solicitud'] as num?)?.toInt() ?? 0,
        idProducto: (json['id_producto'] as num?)?.toInt() ?? 0,
        producto: json['producto'] ?? '',
        categoria: json['categoria'] as String?,
        stockActual: (json['stock_actual'] as num?)?.toInt() ?? 0,
        stockMinimo: (json['stock_minimo'] as num?)?.toInt() ?? 0,
        idAlerta: (json['id_alerta'] as num?)?.toInt(),
        tipoAlerta: json['tipo_alerta'] as String?,
        cantidadSugerida: (json['cantidad_sugerida'] as num?)?.toInt() ?? 0,
        estado: json['estado'] ?? '',
        notas: json['notas'] as String?,
        fechaCreacion: json['fecha_creacion'] != null
            ? DateTime.tryParse(json['fecha_creacion'])
            : null,
        fechaActualizacion: json['fecha_actualizacion'] != null
            ? DateTime.tryParse(json['fecha_actualizacion'])
            : null,
      );
}
