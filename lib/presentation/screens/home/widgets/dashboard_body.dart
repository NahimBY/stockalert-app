import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockalert_app/config/theme/app_theme.dart';
import 'package:stockalert_app/domain/entities/dashboard.dart';
import 'package:stockalert_app/presentation/screens/home/cubit/dashboard_cubit.dart';
import 'package:stockalert_app/presentation/screens/home/cubit/dashboard_state.dart';
import 'package:stockalert_app/presentation/widgets/dashboard/categoria_bar_row.dart';
import 'package:stockalert_app/presentation/widgets/dashboard/dashboard_section.dart';
import 'package:stockalert_app/presentation/utils/formato.dart';
import 'package:stockalert_app/presentation/widgets/dashboard/mini_line_chart.dart';
import 'package:stockalert_app/presentation/widgets/dashboard/productos_por_reponer.dart';
import 'package:stockalert_app/presentation/widgets/dashboard/stat_card.dart';

class DashboardBody extends StatelessWidget {
  const DashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading || state is DashboardInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is DashboardError) {
          return _DashboardError(
            message: state.message,
            onRetry: () => context.read<DashboardCubit>().cargar(),
          );
        }

        final dashboard = (state as DashboardSuccess).dashboard;
        return RefreshIndicator(
          onRefresh: () => context.read<DashboardCubit>().cargar(),
          child: _DashboardContent(dashboard: dashboard),
        );
      },
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final Dashboard dashboard;

  const _DashboardContent({required this.dashboard});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DashboardCubit>();
    final vendidas = dashboard.unidadesVendidas;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PeriodoSelector(
            seleccionado: cubit.meses,
            onChanged: cubit.cambiarPeriodo,
          ),
          const SizedBox(height: 16),
          _Indicadores(dashboard: dashboard, vendidas: vendidas),
          const SizedBox(height: 16),
          if (dashboard.porMes.isNotEmpty) ...[
            DashboardSection(
              title: 'Entradas y salidas por mes',
              subtitle: 'Unidades; el último mes está en curso',
              child: Column(
                children: [
                  const _LeyendaSeries(),
                  const SizedBox(height: 12),
                  MiniLineChart(
                    entradas: [
                      for (final m in dashboard.porMes) m.entradas.toDouble(),
                    ],
                    salidas: [
                      for (final m in dashboard.porMes) m.salidas.toDouble(),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (dashboard.porCategoria.isNotEmpty) ...[
            DashboardSection(
              title: 'Unidades vendidas por categoría',
              subtitle: 'Salidas del periodo, de mayor a menor',
              child: _BarrasCategoria(categorias: dashboard.porCategoria),
            ),
            const SizedBox(height: 16),
          ],
          DashboardSection(
            title: 'Productos por reponer',
            child: ProductosPorReponer(productos: dashboard.porReponer),
          ),
        ],
      ),
    );
  }
}

class _Indicadores extends StatelessWidget {
  final Dashboard dashboard;
  final UnidadesVendidasDashboard vendidas;

  const _Indicadores({required this.dashboard, required this.vendidas});

  @override
  Widget build(BuildContext context) {
    final stockBajo = dashboard.stockBajo;
    final top = dashboard.categoriaTop;
    final variacion = vendidas.variacion;

    return Column(
      children: [
        StatCard(
          label: 'Productos bajo su stock mínimo',
          value: formatoNumero(stockBajo.productos),
          icon: Icons.inventory_2_outlined,
          alert: stockBajo.productos > 0,
          detalle:
              'de ${formatoNumero(stockBajo.total)} productos activos · hay que reponerlos',
        ),
        const SizedBox(height: 12),
        StatCard(
          label: 'Unidades vendidas en el periodo',
          value: formatoNumero(vendidas.actual),
          icon: Icons.shopping_cart_outlined,
          detalle: variacion == null
              ? 'Sin periodo anterior completo para comparar'
              : '${formatoPorcentaje(variacion.abs())} ${variacion >= 0 ? 'más' : 'menos'} que los ${dashboard.meses} meses anteriores',
        ),
        const SizedBox(height: 12),
        StatCard(
          label: 'Categoría más vendida',
          value: top?.categoria ?? '—',
          icon: Icons.category_outlined,
          detalle: top == null
              ? null
              : '${formatoPorcentaje(top.participacion)} de las unidades vendidas (${formatoNumero(top.unidades)})',
        ),
      ],
    );
  }
}

class _PeriodoSelector extends StatelessWidget {
  final int seleccionado;
  final ValueChanged<int> onChanged;

  const _PeriodoSelector({
    required this.seleccionado,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        for (final meses in DashboardCubit.periodosDisponibles)
          ChoiceChip(
            label: Text(
              meses == 1 ? 'Último mes' : 'Últimos $meses meses',
              style: AppFonts.caption.copyWith(
                color: meses == seleccionado
                    ? AppColors.marino
                    : AppColors.softText,
                fontWeight: FontWeight.w600,
              ),
            ),
            selected: meses == seleccionado,
            onSelected: (_) => onChanged(meses),
            selectedColor: AppColors.marino10,
            backgroundColor: Colors.white,
            showCheckmark: false,
            side: BorderSide(
              color: meses == seleccionado
                  ? AppColors.marino
                  : AppColors.marino20,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
          ),
      ],
    );
  }
}

class _LeyendaSeries extends StatelessWidget {
  const _LeyendaSeries();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 6,
      children: [
        _leyenda('Salidas (ventas)', AppColors.blueSeries1),
        _leyenda('Entradas (compras)', AppColors.orangeSeries2),
      ],
    );
  }

  Widget _leyenda(String texto, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 2,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(texto, style: AppFonts.caption),
      ],
    );
  }
}

class _BarrasCategoria extends StatelessWidget {
  final List<CategoriaDashboard> categorias;

  const _BarrasCategoria({required this.categorias});

  @override
  Widget build(BuildContext context) {
    final maximo = categorias.fold<int>(0, (a, c) => c.unidades > a ? c.unidades : a);

    return Column(
      children: [
        for (final categoria in categorias)
          CategoriaBarRow(
            categoria: categoria.categoria,
            unidades: categoria.unidades,
            maximo: maximo,
          ),
      ],
    );
  }
}

class _DashboardError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _DashboardError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.error,
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppFonts.bodyText3.copyWith(color: AppColors.softText),
            ),
            const SizedBox(height: 16),
            TextButton(onPressed: onRetry, child: const Text('Reintentar')),
          ],
        ),
      ),
    );
  }
}
