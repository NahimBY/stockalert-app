import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockalert_app/config/theme/app_theme.dart';
import 'package:stockalert_app/domain/entities/alerta.dart';
import 'package:stockalert_app/domain/entities/pagina.dart';
import 'package:stockalert_app/presentation/screens/alertas/cubit/alertas_cubit.dart';
import 'package:stockalert_app/presentation/screens/alertas/cubit/alertas_state.dart';
import 'package:stockalert_app/presentation/screens/alertas/widgets/filtros_alertas_sheet.dart';
import 'package:stockalert_app/presentation/utils/formato.dart';
import 'package:stockalert_app/presentation/widgets/alertas/alerta_card.dart';
import 'package:stockalert_app/presentation/widgets/dashboard/stat_card.dart';
import 'package:stockalert_app/presentation/widgets/filtros/filtros_ui.dart';
import 'package:stockalert_app/presentation/widgets/lista/paginacion_barra.dart';

class AlertasBody extends StatelessWidget {
  const AlertasBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlertasCubit, AlertasState>(
      builder: (context, state) {
        if (state is AlertasInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AlertasError) {
          return EstadoErrorLista(
            message: state.message,
            onRetry: () => context.read<AlertasCubit>().cargar(),
          );
        }

        final cubit = context.read<AlertasCubit>();
        final cargando = state is AlertasLoading;
        final Pagina<Alerta>? pagina = switch (state) {
          AlertasSuccess(:final pagina) => pagina,
          AlertasLoading(:final anterior) => anterior,
          _ => null,
        };
        final resumen = state is AlertasSuccess
            ? state.resumen
            : const ResumenAlertas(pendientes: 0, total: 0);
        final actualizando = state is AlertasSuccess
            ? state.actualizando
            : const <int>{};

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Resumen(resumen: resumen),
                  const SizedBox(height: 12),
                  _Filtros(cubit: cubit),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => cubit.cargar(),
                child: _Lista(
                  pagina: pagina,
                  cargando: cargando,
                  actualizando: actualizando,
                ),
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

class _Resumen extends StatelessWidget {
  final ResumenAlertas resumen;

  const _Resumen({required this.resumen});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: StatCard(
            label: 'Pendientes',
            value: formatoNumero(resumen.pendientes),
            icon: Icons.notifications_active_outlined,
            alert: resumen.pendientes > 0,
            detalle: 'sin reponerse',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StatCard(
            label: 'Registradas en el año',
            value: formatoNumero(resumen.total),
            icon: Icons.inventory_2_outlined,
            detalle: 'en total',
          ),
        ),
      ],
    );
  }
}

class _Lista extends StatelessWidget {
  final Pagina<Alerta>? pagina;
  final bool cargando;
  final Set<int> actualizando;

  const _Lista({
    required this.pagina,
    required this.cargando,
    required this.actualizando,
  });

  Future<void> _marcar(BuildContext context, Alerta alerta) async {
    final cubit = context.read<AlertasCubit>();
    final ok = await cubit.marcarAtendida(alerta.id);
    if (!context.mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.white,
            elevation: 8,
            duration: const Duration(seconds: 2),
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
            content: Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Alerta marcada como atendida',
                    style: AppFonts.bodyText3.copyWith(
                      color: AppColors.text,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final alertas = pagina?.data ?? const <Alerta>[];

    if (alertas.isEmpty && !cargando) {
      return const EstadoVacioLista(
        message: 'No hay alertas con esos filtros.',
      );
    }

    return Stack(
      children: [
        ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          itemCount: alertas.length,
          itemBuilder: (context, index) {
            final alerta = alertas[index];
            return AlertaCard(
              alerta: alerta,
              actualizando: actualizando.contains(alerta.id),
              onMarcarAtendida: () => _marcar(context, alerta),
            );
          },
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
  final AlertasCubit cubit;

  const _Filtros({required this.cubit});

  @override
  Widget build(BuildContext context) {
    final activos = cubit.estado.isNotEmpty || cubit.tipo.isNotEmpty;
    final cantidad =
        (cubit.estado.isNotEmpty ? 1 : 0) + (cubit.tipo.isNotEmpty ? 1 : 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => mostrarFiltrosAlertas(context),
                icon: const Icon(Icons.tune_rounded, size: 18),
                label: Text(
                  cantidad == 0 ? 'Filtros' : 'Filtros ($cantidad)',
                  style: AppFonts.bodyText3.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.marino,
                  backgroundColor: cantidad > 0
                      ? AppColors.marino10
                      : Colors.white,
                  side: BorderSide(
                    color: cantidad > 0
                        ? AppColors.marino
                        : AppColors.marino20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
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
                  label: etiquetaEstadoAlerta(cubit.estado),
                  onRemove: () => cubit.cambiarEstado(''),
                ),
              if (cubit.tipo.isNotEmpty)
                FiltroActivoChip(
                  label: etiquetaTipoAlerta(cubit.tipo),
                  onRemove: () => cubit.cambiarTipo(''),
                ),
            ],
          ),
        ],
        const SizedBox(height: 8),
      ],
    );
  }
}
