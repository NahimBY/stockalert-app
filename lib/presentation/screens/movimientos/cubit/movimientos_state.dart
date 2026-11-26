import 'package:stockalert_app/domain/entities/movimiento.dart';
import 'package:stockalert_app/domain/entities/pagina.dart';

abstract class MovimientosState {
  const MovimientosState();
}

class MovimientosInitial extends MovimientosState {
  const MovimientosInitial();
}

class MovimientosLoading extends MovimientosState {
  final Pagina<Movimiento>? anterior;

  const MovimientosLoading({this.anterior});
}

class MovimientosSuccess extends MovimientosState {
  final Pagina<Movimiento> pagina;
  final List<String> categorias;

  const MovimientosSuccess(this.pagina, {this.categorias = const []});
}

class MovimientosError extends MovimientosState {
  final String message;

  const MovimientosError(this.message);
}
