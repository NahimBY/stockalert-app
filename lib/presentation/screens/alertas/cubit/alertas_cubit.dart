import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockalert_app/domain/entities/alerta.dart';
import 'package:stockalert_app/domain/entities/pagina.dart';
import 'package:stockalert_app/domain/repositories/alertas_repository.dart';
import 'package:stockalert_app/infrastructure/errors/api_error.dart';
import 'package:stockalert_app/presentation/screens/alertas/cubit/alertas_state.dart';

class AlertasCubit extends Cubit<AlertasState> {
  static const List<({String value, String label})> estados = [
    (value: '', label: 'Todos'),
    (value: 'pendiente', label: 'Pendiente'),
    (value: 'atendida', label: 'Atendida'),
    (value: 'cerrada', label: 'Cerrada'),
  ];

  static const List<({String value, String label})> tipos = [
    (value: '', label: 'Todos'),
    (value: 'stock_bajo', label: 'Stock bajo'),
    (value: 'agotado', label: 'Agotado'),
  ];

  final AlertasRepository repository;

  String estado = '';
  String tipo = '';
  int page = 1;
  int limit = 20;

  ResumenAlertas _resumen = const ResumenAlertas(pendientes: 0, total: 0);
  int _peticion = 0;

  AlertasCubit(this.repository) : super(const AlertasInitial());

  Future<void> cargar() async {
    emit(AlertasLoading(anterior: _paginaActual));
    final peticion = ++_peticion;

    try {
      final pagina = await repository.listar(
        estado: estado,
        tipo: tipo,
        page: page,
        limit: limit,
      );
      if (isClosed || peticion != _peticion) return;

      _resumen = await _obtenerResumen();
      if (isClosed || peticion != _peticion) return;

      emit(AlertasSuccess(pagina, resumen: _resumen));
    } on ApiException catch (e) {
      if (isClosed || peticion != _peticion) return;
      emit(AlertasError(e.message));
    } catch (_) {
      if (isClosed || peticion != _peticion) return;
      emit(const AlertasError('No se pudieron cargar las alertas.'));
    }
  }

  void cambiarEstado(String valor) {
    if (valor == estado) return;
    estado = valor;
    page = 1;
    cargar();
  }

  void cambiarTipo(String valor) {
    if (valor == tipo) return;
    tipo = valor;
    page = 1;
    cargar();
  }

  void limpiarFiltros() {
    if (estado.isEmpty && tipo.isEmpty) return;
    estado = '';
    tipo = '';
    page = 1;
    cargar();
  }

  void irAPagina(int pagina) {
    final total = _paginaActual?.totalPages ?? 1;
    final destino = pagina.clamp(1, total);
    if (destino == page) return;
    page = destino;
    cargar();
  }

  /// Marca una alerta como atendida sin recargar la lista completa.
  Future<bool> marcarAtendida(int id) async {
    final current = state;
    if (current is! AlertasSuccess) return false;
    if (current.actualizando.contains(id)) return false;

    emit(current.copyWith(actualizando: {...current.actualizando, id}));

    try {
      final actualizada = await repository.cambiarEstado(id, 'atendida');
      if (isClosed) return false;

      final base = state;
      if (base is! AlertasSuccess) return false;

      final filas = [
        for (final alerta in base.pagina.data)
          if (alerta.id == id) actualizada else alerta,
      ];
      final resumen = await _obtenerResumen();
      if (isClosed) return false;

      final siguientes = {...base.actualizando}..remove(id);
      emit(
        AlertasSuccess(
          Pagina<Alerta>(
            data: filas,
            page: base.pagina.page,
            limit: base.pagina.limit,
            total: base.pagina.total,
            totalPages: base.pagina.totalPages,
          ),
          resumen: resumen,
          actualizando: siguientes,
        ),
      );
      _resumen = resumen;
      return true;
    } catch (_) {
      final base = state;
      if (base is AlertasSuccess && !isClosed) {
        emit(
          base.copyWith(actualizando: {...base.actualizando}..remove(id)),
        );
      }
      return false;
    }
  }

  Future<ResumenAlertas> _obtenerResumen() async {
    try {
      return await repository.resumen();
    } catch (_) {
      return _resumen;
    }
  }

  Pagina<Alerta>? get _paginaActual {
    final state = this.state;
    if (state is AlertasSuccess) return state.pagina;
    if (state is AlertasLoading) return state.anterior;
    return null;
  }
}
