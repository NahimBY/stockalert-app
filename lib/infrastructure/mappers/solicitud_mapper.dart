import 'package:stockalert_app/domain/entities/solicitud.dart';
import 'package:stockalert_app/infrastructure/models/solicitudesdb/solicitud_response.dart';

class SolicitudMapper {
  static Solicitud responseToEntity(SolicitudResponse response) => Solicitud(
        id: response.id,
        idProducto: response.idProducto,
        producto: response.producto,
        categoria: response.categoria,
        stockActual: response.stockActual,
        stockMinimo: response.stockMinimo,
        idAlerta: response.idAlerta,
        tipoAlerta: response.tipoAlerta,
        cantidadSugerida: response.cantidadSugerida,
        estado: response.estado,
        notas: response.notas,
        fechaCreacion: response.fechaCreacion,
        fechaActualizacion: response.fechaActualizacion,
      );
}
