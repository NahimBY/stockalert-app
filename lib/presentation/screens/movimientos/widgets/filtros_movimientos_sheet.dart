import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockalert_app/presentation/screens/movimientos/cubit/movimientos_cubit.dart';
import 'package:stockalert_app/presentation/screens/movimientos/cubit/movimientos_state.dart';
import 'package:stockalert_app/presentation/widgets/filtros/filtros_ui.dart';

Future<void> mostrarFiltrosMovimientos(BuildContext context) {
  return mostrarFiltrosSheet(context, const FiltrosMovimientosSheet());
}

String etiquetaTipo(String valor) {
  for (final tipo in MovimientosCubit.tipos) {
    if (tipo.value == valor) return tipo.label;
  }
  return valor;
}

class FiltrosMovimientosSheet extends StatelessWidget {
  const FiltrosMovimientosSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovimientosCubit, MovimientosState>(
      builder: (context, state) {
        final cubit = context.read<MovimientosCubit>();
        final categorias = state is MovimientosSuccess
            ? state.categorias
            : const <String>[];
        final hayFiltros = cubit.tipo.isNotEmpty || cubit.categoria.isNotEmpty;

        return FiltrosSheetShell(
          titulo: 'Filtros',
          hayFiltros: hayFiltros,
          onLimpiar: cubit.limpiarFiltros,
          secciones: [
            FiltrosSeccion(
              titulo: 'Tipo de movimiento',
              child: Column(
                children: [
                  for (final tipo in MovimientosCubit.tipos)
                    FiltrosOpcion(
                      label: tipo.label,
                      seleccionada: cubit.tipo == tipo.value,
                      onTap: () => cubit.cambiarTipo(tipo.value),
                    ),
                ],
              ),
            ),
            if (categorias.isNotEmpty) ...[
              const SizedBox(height: 8),
              FiltrosSeccion(
                titulo: 'Categoría',
                child: Column(
                  children: [
                    FiltrosOpcion(
                      label: 'Todas',
                      seleccionada: cubit.categoria.isEmpty,
                      onTap: () => cubit.cambiarCategoria(''),
                    ),
                    for (final categoria in categorias)
                      FiltrosOpcion(
                        label: categoria,
                        seleccionada: cubit.categoria == categoria,
                        onTap: () => cubit.cambiarCategoria(categoria),
                      ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
