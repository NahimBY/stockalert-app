import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockalert_app/domain/entities/pagina.dart';
import 'package:stockalert_app/domain/entities/producto.dart';
import 'package:stockalert_app/domain/repositories/categorias_repository.dart';
import 'package:stockalert_app/domain/repositories/productos_repository.dart';
import 'package:stockalert_app/infrastructure/errors/api_error.dart';
import 'package:stockalert_app/presentation/screens/productos/cubit/productos_state.dart';

class ProductosCubit extends Cubit<ProductosState> {
  static const List<({String value, String label})> estados = [
    (value: '', label: 'Todos'),
    (value: 'reponer', label: 'Por reponer'),
    (value: 'bajo', label: 'Bajo su mínimo'),
    (value: 'agotado', label: 'Agotado'),
    (value: 'ok', label: 'En orden'),
  ];

  final ProductosRepository productos;
  final CategoriasRepository categorias;

  final busquedaController = TextEditingController();

  String q = '';
  String estado = '';
  String categoria = '';
  int page = 1;
  int limit = 20;

  List<String> _categorias = const [];
  Timer? _debounce;
  int _peticion = 0;

  ProductosCubit(this.productos, this.categorias) : super(const ProductosInitial());

  Future<void> cargar({bool conCategorias = true}) async {
    final actual = _paginaActual;
    emit(ProductosLoading(anterior: actual));
    final peticion = ++_peticion;

    try {
      final pagina = await productos.listar(
        q: q,
        estado: estado,
        categoria: categoria,
        page: page,
        limit: limit,
      );
      if (isClosed || peticion != _peticion) return;

      if (conCategorias && _categorias.isEmpty) {
        _categorias = await _obtenerCategorias();
        if (isClosed || peticion != _peticion) return;
      }
      emit(ProductosSuccess(pagina, categorias: _categorias));
    } on ApiException catch (e) {
      if (isClosed || peticion != _peticion) return;
      emit(ProductosError(e.message));
    } catch (_) {
      if (isClosed || peticion != _peticion) return;
      emit(const ProductosError('No se pudieron cargar los productos.'));
    }
  }

  void buscar(String texto) {
    q = texto;
    page = 1;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), cargar);
  }

  void cambiarEstado(String valor) {
    if (valor == estado) return;
    estado = valor;
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
    if (q.isEmpty && estado.isEmpty && categoria.isEmpty) return;
    q = '';
    estado = '';
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

  Pagina<Producto>? get _paginaActual {
    final state = this.state;
    if (state is ProductosSuccess) return state.pagina;
    if (state is ProductosLoading) return state.anterior;
    return null;
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    busquedaController.dispose();
    return super.close();
  }
}
