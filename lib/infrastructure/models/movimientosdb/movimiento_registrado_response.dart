import 'package:stockalert_app/infrastructure/models/alertasdb/alerta_response.dart';
import 'package:stockalert_app/infrastructure/models/movimientosdb/movimiento_response.dart';

class ProductoStockResponse {
  final int id;
  final String nombre;
  final String? categoria;
  final int stockActual;
  final int stockMinimo;
  final String estadoStock;

  const ProductoStockResponse({
    required this.id,
    required this.nombre,
    required this.stockActual,
    required this.stockMinimo,
    required this.estadoStock,
    this.categoria,
  });

  factory ProductoStockResponse.fromJson(Map<String, dynamic> json) =>
      ProductoStockResponse(
        id: (json['id_producto'] as num?)?.toInt() ?? 0,
        nombre: json['nombre'] ?? '',
        categoria: json['categoria'] as String?,
        stockActual: (json['stock_actual'] as num?)?.toInt() ?? 0,
        stockMinimo: (json['stock_minimo'] as num?)?.toInt() ?? 0,
        estadoStock: json['estado_stock'] ?? 'ok',
      );
}

class MovimientoRegistradoResponse {
  final MovimientoResponse movimiento;
  final ProductoStockResponse producto;
  final AlertaResponse? alertaGenerada;
  final int alertasAtendidas;
  final bool n8nNotificado;

  const MovimientoRegistradoResponse({
    required this.movimiento,
    required this.producto,
    required this.alertasAtendidas,
    required this.n8nNotificado,
    this.alertaGenerada,
  });

  factory MovimientoRegistradoResponse.fromJson(Map<String, dynamic> json) {
    final alerta = json['alerta_generada'];
    return MovimientoRegistradoResponse(
      movimiento: MovimientoResponse.fromJson(
        Map<String, dynamic>.from(json['movimiento']),
      ),
      producto: ProductoStockResponse.fromJson(
        Map<String, dynamic>.from(json['producto']),
      ),
      alertaGenerada: alerta is Map
          ? AlertaResponse.fromJson(Map<String, dynamic>.from(alerta))
          : null,
      alertasAtendidas: (json['alertas_atendidas'] as num?)?.toInt() ?? 0,
      n8nNotificado: json['n8n_notificado'] ?? false,
    );
  }
}
