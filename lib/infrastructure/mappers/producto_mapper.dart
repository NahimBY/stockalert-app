import 'package:stockalert_app/domain/entities/producto.dart';
import 'package:stockalert_app/infrastructure/mappers/alerta_mapper.dart';
import 'package:stockalert_app/infrastructure/models/productosdb/producto_response.dart';

class ProductoMapper {
  static Producto responseToEntity(ProductoResponse response) => Producto(
        id: response.id,
        nombre: response.nombre,
        descripcion: response.descripcion,
        categoria: response.categoria,
        stockActual: response.stockActual,
        stockMinimo: response.stockMinimo,
        precio: response.precio,
        fechaActualizacion: response.fechaActualizacion,
        estado: response.estado,
        estadoStock: response.estadoStock,
        alertaGenerada: response.alertaGenerada != null
            ? AlertaMapper.responseToEntity(response.alertaGenerada!)
            : null,
      );
}
