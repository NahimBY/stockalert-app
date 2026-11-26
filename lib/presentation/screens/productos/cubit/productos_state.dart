import 'package:stockalert_app/domain/entities/pagina.dart';
import 'package:stockalert_app/domain/entities/producto.dart';

abstract class ProductosState {
  const ProductosState();
}

class ProductosInitial extends ProductosState {
  const ProductosInitial();
}

class ProductosLoading extends ProductosState {
  final Pagina<Producto>? anterior;

  const ProductosLoading({this.anterior});
}

class ProductosSuccess extends ProductosState {
  final Pagina<Producto> pagina;
  final List<String> categorias;

  const ProductosSuccess(this.pagina, {this.categorias = const []});
}

class ProductosError extends ProductosState {
  final String message;

  const ProductosError(this.message);
}
