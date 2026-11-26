import 'package:stockalert_app/domain/entities/alerta.dart';
import 'package:stockalert_app/domain/entities/pagina.dart';

abstract class AlertasState {
  const AlertasState();
}

class AlertasInitial extends AlertasState {
  const AlertasInitial();
}

class AlertasLoading extends AlertasState {
  final Pagina<Alerta>? anterior;

  const AlertasLoading({this.anterior});
}

class AlertasSuccess extends AlertasState {
  final Pagina<Alerta> pagina;
  final ResumenAlertas resumen;
  final Set<int> actualizando;

  const AlertasSuccess(
    this.pagina, {
    required this.resumen,
    this.actualizando = const {},
  });

  AlertasSuccess copyWith({
    Pagina<Alerta>? pagina,
    ResumenAlertas? resumen,
    Set<int>? actualizando,
  }) {
    return AlertasSuccess(
      pagina ?? this.pagina,
      resumen: resumen ?? this.resumen,
      actualizando: actualizando ?? this.actualizando,
    );
  }
}

class AlertasError extends AlertasState {
  final String message;

  const AlertasError(this.message);
}
