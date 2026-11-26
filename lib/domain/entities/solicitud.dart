class Solicitud {
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

  const Solicitud({
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
}

class ResumenSolicitudes {
  final int pendiente;
  final int pedida;
  final int recibida;
  final int cancelada;

  const ResumenSolicitudes({
    required this.pendiente,
    required this.pedida,
    required this.recibida,
    required this.cancelada,
  });
}
