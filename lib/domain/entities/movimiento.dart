import 'package:stockalert_app/domain/entities/alerta.dart';

class Movimiento {
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

  const Movimiento({
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
}

class ProductoStock {
  final int id;
  final String nombre;
  final String? categoria;
  final int stockActual;
  final int stockMinimo;
  final String estadoStock;

  const ProductoStock({
    required this.id,
    required this.nombre,
    required this.stockActual,
    required this.stockMinimo,
    required this.estadoStock,
    this.categoria,
  });
}

class MovimientoRegistrado {
  final Movimiento movimiento;
  final ProductoStock producto;
  final Alerta? alertaGenerada;
  final int alertasAtendidas;
  final bool n8nNotificado;

  const MovimientoRegistrado({
    required this.movimiento,
    required this.producto,
    required this.alertasAtendidas,
    required this.n8nNotificado,
    this.alertaGenerada,
  });
}
