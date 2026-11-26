import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockalert_app/domain/entities/pagina.dart';
import 'package:stockalert_app/domain/entities/producto.dart';
import 'package:stockalert_app/presentation/screens/productos/cubit/productos_cubit.dart';
import 'package:stockalert_app/presentation/screens/productos/cubit/productos_state.dart';
import 'package:stockalert_app/presentation/screens/productos/widgets/filtros_sheet.dart';
import 'package:stockalert_app/presentation/widgets/filtros/buscador_campo.dart';
import 'package:stockalert_app/presentation/widgets/filtros/filtros_ui.dart';
import 'package:stockalert_app/presentation/widgets/lista/paginacion_barra.dart';
import 'package:stockalert_app/presentation/widgets/productos/producto_card.dart';

class ProductosBody extends StatelessWidget {
  const ProductosBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductosCubit, ProductosState>(
      builder: (context, state) {
        if (state is ProductosInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProductosError) {
          return EstadoErrorLista(
            message: state.message,
            onRetry: () => context.read<ProductosCubit>().cargar(),
          );
        }

        final cubit = context.read<ProductosCubit>();
        final cargando = state is ProductosLoading;
        final Pagina<Producto>? pagina = switch (state) {
          ProductosSuccess(:final pagina) => pagina,
          ProductosLoading(:final anterior) => anterior,
          _ => null,
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: _Filtros(cubit: cubit),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => cubit.cargar(),
                child: _Lista(pagina: pagina, cargando: cargando),
              ),
            ),
            if (pagina != null)
              PaginacionBarra(
                total: pagina.total,
                page: pagina.page,
                limit: pagina.limit,
                totalPages: pagina.totalPages,
                onIrAPagina: cubit.irAPagina,
              ),
          ],
        );
      },
    );
  }
}

class _Lista extends StatelessWidget {
  final Pagina<Producto>? pagina;
  final bool cargando;

  const _Lista({required this.pagina, required this.cargando});

  @override
  Widget build(BuildContext context) {
    final productos = pagina?.data ?? const <Producto>[];

    if (productos.isEmpty && !cargando) {
      return const EstadoVacioLista(
        message: 'No hay productos con esos filtros.',
      );
    }

    return Stack(
      children: [
        ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          itemCount: productos.length,
          itemBuilder:
              (context, index) => ProductoCard(producto: productos[index]),
        ),
        if (cargando)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(minHeight: 2),
          ),
      ],
    );
  }
}

class _Filtros extends StatelessWidget {
  final ProductosCubit cubit;

  const _Filtros({required this.cubit});

  @override
  Widget build(BuildContext context) {
    final activos = cubit.estado.isNotEmpty || cubit.categoria.isNotEmpty;
    final cantidad =
        (cubit.estado.isNotEmpty ? 1 : 0) + (cubit.categoria.isNotEmpty ? 1 : 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: BuscadorCampo(
                controller: cubit.busquedaController,
                hint: 'Buscar producto…',
                onChanged: cubit.buscar,
              ),
            ),
            const SizedBox(width: 10),
            BotonFiltros(
              cantidad: cantidad,
              onPressed: () => mostrarFiltros(context),
            ),
          ],
        ),
        if (activos) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              if (cubit.estado.isNotEmpty)
                FiltroActivoChip(
                  label: etiquetaEstado(cubit.estado),
                  onRemove: () => cubit.cambiarEstado(''),
                ),
              if (cubit.categoria.isNotEmpty)
                FiltroActivoChip(
                  label: cubit.categoria,
                  onRemove: () => cubit.cambiarCategoria(''),
                ),
            ],
          ),
        ],
        const SizedBox(height: 8),
      ],
    );
  }
}
