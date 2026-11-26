import 'package:stockalert_app/domain/entities/alerta.dart';
import 'package:stockalert_app/infrastructure/models/alertasdb/alerta_response.dart';

class AlertaMapper {
  static Alerta responseToEntity(AlertaResponse response) => Alerta(
        id: response.id,
        idProducto: response.idProducto,
        producto: response.producto,
        categoria: response.categoria,
        tipo: response.tipo,
        stockDetectado: response.stockDetectado,
        fechaGeneracion: response.fechaGeneracion,
        estado: response.estado,
        fechaAtencion: response.fechaAtencion,
      );
}
