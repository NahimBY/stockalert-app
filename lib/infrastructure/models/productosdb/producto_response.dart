import 'package:stockalert_app/infrastructure/models/alertasdb/alerta_response.dart';

class ProductoResponse {
  final int id;
  final String nombre;
  final String? descripcion;
  final String? categoria;
  final int stockActual;
  final int stockMinimo;
  final double precio;
  final DateTime? fechaActualizacion;
  final bool estado;
  final String estadoStock;
  final AlertaResponse? alertaGenerada;

  const ProductoResponse({
    required this.id,
    required this.nombre,
    required this.stockActual,
    required this.stockMinimo,
    required this.precio,
    required this.estado,
    required this.estadoStock,
    this.descripcion,
    this.categoria,
    this.fechaActualizacion,
    this.alertaGenerada,
  });

  factory ProductoResponse.fromJson(Map<String, dynamic> json) {
    final alerta = json['alerta_generada'];
    return ProductoResponse(
      id: (json['id_producto'] as num?)?.toInt() ?? 0,
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'] as String?,
      categoria: json['categoria'] as String?,
      stockActual: (json['stock_actual'] as num?)?.toInt() ?? 0,
      stockMinimo: (json['stock_minimo'] as num?)?.toInt() ?? 0,
      precio: (json['precio'] as num?)?.toDouble() ?? 0,
      fechaActualizacion: json['fecha_actualizacion'] != null
          ? DateTime.tryParse(json['fecha_actualizacion'])
          : null,
      estado: json['estado'] ?? true,
      estadoStock: json['estado_stock'] ?? 'ok',
      alertaGenerada: alerta is Map
          ? AlertaResponse.fromJson(Map<String, dynamic>.from(alerta))
          : null,
    );
  }
}
