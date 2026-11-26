import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockalert_app/domain/entities/movimiento.dart';
import 'package:stockalert_app/domain/entities/pagina.dart';
import 'package:stockalert_app/domain/repositories/categorias_repository.dart';
import 'package:stockalert_app/domain/repositories/movimientos_repository.dart';
import 'package:stockalert_app/infrastructure/errors/api_error.dart';
import 'package:stockalert_app/presentation/screens/movimientos/cubit/movimientos_state.dart';

class MovimientosCubit extends Cubit<MovimientosState> {
  static const List<({String value, String label})> tipos = [
    (value: '', label: 'Todos'),
    (value: 'entrada', label: 'Entrada'),
    (value: 'salida', label: 'Salida'),
    (value: 'ajuste', label: 'Ajuste'),
  ];

  final MovimientosRepository movimientos;
  final CategoriasRepository categorias;

  final busquedaController = TextEditingController();

  String q = '';
  String tipo = '';
  String categoria = '';
  int page = 1;
  int limit = 20;

  List<String> _categorias = const [];
  Timer? _debounce;
  int _peticion = 0;

  MovimientosCubit(this.movimientos, this.categorias)
    : super(const MovimientosInitial());

  Future<void> cargar() async {
    emit(MovimientosLoading(anterior: _paginaActual));
    final peticion = ++_peticion;

    try {
      final pagina = await movimientos.listar(
        q: q,
        tipo: tipo,
        categoria: categoria,
        page: page,
        limit: limit,
      );
      if (isClosed || peticion != _peticion) return;

      if (_categorias.isEmpty) {
        _categorias = await _obtenerCategorias();
        if (isClosed || peticion != _peticion) return;
      }
      emit(MovimientosSuccess(pagina, categorias: _categorias));
    } on ApiException catch (e) {
      if (isClosed || peticion != _peticion) return;
      emit(MovimientosError(e.message));
    } catch (_) {
      if (isClosed || peticion != _peticion) return;
      emit(const MovimientosError('No se pudieron cargar los movimientos.'));
    }
  }

  void buscar(String texto) {
    q = texto;
    page = 1;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), cargar);
  }

  void cambiarTipo(String valor) {
    if (valor == tipo) return;
    tipo = valor;
    page = 1;
    cargar();
  }

  void cambiarCategoria(String valor) {
    if (valor == categoria) return;
    categoria = valor;
    page = 1;
    cargar();
  }

  void limpiarFiltros() {
    if (q.isEmpty && tipo.isEmpty && categoria.isEmpty) return;
    q = '';
    tipo = '';
    categoria = '';
    busquedaController.clear();
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

  Future<List<String>> _obtenerCategorias() async {
    try {
      return await categorias.listar();
    } catch (_) {
      return const [];
    }
  }

  Pagina<Movimiento>? get _paginaActual {
    final state = this.state;
    if (state is MovimientosSuccess) return state.pagina;
    if (state is MovimientosLoading) return state.anterior;
    return null;
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    busquedaController.dispose();
    return super.close();
  }
}
