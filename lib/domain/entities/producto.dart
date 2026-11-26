import 'package:stockalert_app/domain/entities/alerta.dart';

class Producto {
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
  final Alerta? alertaGenerada;

  const Producto({
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

  int get faltante => stockMinimo - stockActual;
}
