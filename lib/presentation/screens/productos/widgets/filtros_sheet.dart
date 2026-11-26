import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockalert_app/presentation/screens/productos/cubit/productos_cubit.dart';
import 'package:stockalert_app/presentation/screens/productos/cubit/productos_state.dart';
import 'package:stockalert_app/presentation/widgets/filtros/filtros_ui.dart';

Future<void> mostrarFiltros(BuildContext context) {
  return mostrarFiltrosSheet(context, const FiltrosSheet());
}

String etiquetaEstado(String valor) {
  for (final estado in ProductosCubit.estados) {
    if (estado.value == valor) return estado.label;
  }
  return valor;
}

class FiltrosSheet extends StatelessWidget {
  const FiltrosSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductosCubit, ProductosState>(
      builder: (context, state) {
        final cubit = context.read<ProductosCubit>();
        final categorias = state is ProductosSuccess
            ? state.categorias
            : const <String>[];
        final hayFiltros = cubit.estado.isNotEmpty || cubit.categoria.isNotEmpty;

        return FiltrosSheetShell(
          titulo: 'Filtros',
          hayFiltros: hayFiltros,
          onLimpiar: cubit.limpiarFiltros,
          secciones: [
            FiltrosSeccion(
              titulo: 'Estado del stock',
              child: Column(
                children: [
                  for (final estado in ProductosCubit.estados)
                    FiltrosOpcion(
                      label: estado.label,
                      seleccionada: cubit.estado == estado.value,
                      onTap: () => cubit.cambiarEstado(estado.value),
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
