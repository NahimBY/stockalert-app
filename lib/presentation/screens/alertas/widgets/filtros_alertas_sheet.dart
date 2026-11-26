import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockalert_app/presentation/screens/alertas/cubit/alertas_cubit.dart';
import 'package:stockalert_app/presentation/screens/alertas/cubit/alertas_state.dart';
import 'package:stockalert_app/presentation/widgets/filtros/filtros_ui.dart';

Future<void> mostrarFiltrosAlertas(BuildContext context) {
  return mostrarFiltrosSheet(context, const FiltrosAlertasSheet());
}

String etiquetaEstadoAlerta(String valor) {
  for (final estado in AlertasCubit.estados) {
    if (estado.value == valor) return estado.label;
  }
  return valor;
}

String etiquetaTipoAlerta(String valor) {
  for (final tipo in AlertasCubit.tipos) {
    if (tipo.value == valor) return tipo.label;
  }
  return valor;
}

class FiltrosAlertasSheet extends StatelessWidget {
  const FiltrosAlertasSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlertasCubit, AlertasState>(
      builder: (context, state) {
        final cubit = context.read<AlertasCubit>();
        final hayFiltros = cubit.estado.isNotEmpty || cubit.tipo.isNotEmpty;

        return FiltrosSheetShell(
          titulo: 'Filtros',
          hayFiltros: hayFiltros,
          onLimpiar: cubit.limpiarFiltros,
          secciones: [
            FiltrosSeccion(
              titulo: 'Estado',
              child: Column(
                children: [
                  for (final estado in AlertasCubit.estados)
                    FiltrosOpcion(
                      label: estado.label,
                      seleccionada: cubit.estado == estado.value,
                      onTap: () => cubit.cambiarEstado(estado.value),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            FiltrosSeccion(
              titulo: 'Tipo de alerta',
              child: Column(
                children: [
                  for (final tipo in AlertasCubit.tipos)
                    FiltrosOpcion(
                      label: tipo.label,
                      seleccionada: cubit.tipo == tipo.value,
                      onTap: () => cubit.cambiarTipo(tipo.value),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
