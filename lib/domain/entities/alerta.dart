class Alerta {
  final int id;
  final int idProducto;
  final String producto;
  final String? categoria;
  final String tipo;
  final int stockDetectado;
  final DateTime? fechaGeneracion;
  final String estado;
  final DateTime? fechaAtencion;

  const Alerta({
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
}

class ResumenAlertas {
  final int pendientes;
  final int total;

  const ResumenAlertas({required this.pendientes, required this.total});
}
