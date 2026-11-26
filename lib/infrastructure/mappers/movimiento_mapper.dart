import 'package:stockalert_app/domain/entities/movimiento.dart';
import 'package:stockalert_app/infrastructure/mappers/alerta_mapper.dart';
import 'package:stockalert_app/infrastructure/models/movimientosdb/movimiento_registrado_response.dart';
import 'package:stockalert_app/infrastructure/models/movimientosdb/movimiento_response.dart';

class MovimientoMapper {
  static Movimiento responseToEntity(MovimientoResponse response) => Movimiento(
        id: response.id,
        fecha: response.fecha,
        tipo: response.tipo,
        cantidad: response.cantidad,
        observaciones: response.observaciones,
        idProducto: response.idProducto,
        producto: response.producto,
        categoria: response.categoria,
        idUsuario: response.idUsuario,
        usuario: response.usuario,
      );

  static ProductoStock productoStockToEntity(ProductoStockResponse response) =>
      ProductoStock(
        id: response.id,
        nombre: response.nombre,
        categoria: response.categoria,
        stockActual: response.stockActual,
        stockMinimo: response.stockMinimo,
        estadoStock: response.estadoStock,
      );

  static MovimientoRegistrado registradoToEntity(
    MovimientoRegistradoResponse response,
  ) =>
      MovimientoRegistrado(
        movimiento: responseToEntity(response.movimiento),
        producto: productoStockToEntity(response.producto),
        alertaGenerada: response.alertaGenerada != null
            ? AlertaMapper.responseToEntity(response.alertaGenerada!)
            : null,
        alertasAtendidas: response.alertasAtendidas,
        n8nNotificado: response.n8nNotificado,
      );
}
