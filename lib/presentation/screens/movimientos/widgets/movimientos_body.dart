import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockalert_app/domain/entities/movimiento.dart';
import 'package:stockalert_app/domain/entities/pagina.dart';
import 'package:stockalert_app/presentation/screens/movimientos/cubit/movimientos_cubit.dart';
import 'package:stockalert_app/presentation/screens/movimientos/cubit/movimientos_state.dart';
import 'package:stockalert_app/presentation/screens/movimientos/widgets/filtros_movimientos_sheet.dart';
import 'package:stockalert_app/presentation/widgets/filtros/buscador_campo.dart';
import 'package:stockalert_app/presentation/widgets/filtros/filtros_ui.dart';
import 'package:stockalert_app/presentation/widgets/lista/paginacion_barra.dart';
import 'package:stockalert_app/presentation/widgets/movimientos/movimiento_card.dart';

class MovimientosBody extends StatelessWidget {
  const MovimientosBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovimientosCubit, MovimientosState>(
      builder: (context, state) {
        if (state is MovimientosInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MovimientosError) {
          return EstadoErrorLista(
            message: state.message,
            onRetry: () => context.read<MovimientosCubit>().cargar(),
          );
        }

        final cubit = context.read<MovimientosCubit>();
        final cargando = state is MovimientosLoading;
        final Pagina<Movimiento>? pagina = switch (state) {
          MovimientosSuccess(:final pagina) => pagina,
          MovimientosLoading(:final anterior) => anterior,
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
  final Pagina<Movimiento>? pagina;
  final bool cargando;

  const _Lista({required this.pagina, required this.cargando});

  @override
  Widget build(BuildContext context) {
    final movimientos = pagina?.data ?? const <Movimiento>[];

    if (movimientos.isEmpty && !cargando) {
      return const EstadoVacioLista(
        message: 'No hay movimientos con esos filtros.',
      );
    }

    return Stack(
      children: [
        ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          itemCount: movimientos.length,
          itemBuilder: (context, index) =>
              MovimientoCard(movimiento: movimientos[index]),
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
  final MovimientosCubit cubit;

  const _Filtros({required this.cubit});

  @override
  Widget build(BuildContext context) {
    final activos = cubit.tipo.isNotEmpty || cubit.categoria.isNotEmpty;
    final cantidad =
        (cubit.tipo.isNotEmpty ? 1 : 0) + (cubit.categoria.isNotEmpty ? 1 : 0);

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
              onPressed: () => mostrarFiltrosMovimientos(context),
            ),
          ],
        ),
        if (activos) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              if (cubit.tipo.isNotEmpty)
                FiltroActivoChip(
                  label: etiquetaTipo(cubit.tipo),
                  onRemove: () => cubit.cambiarTipo(''),
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
