import 'package:flutter/material.dart';
import 'package:stockalert_app/config/theme/app_theme.dart';
import 'package:stockalert_app/domain/entities/movimiento.dart';
import 'package:stockalert_app/presentation/utils/formato_movimiento.dart';
import 'package:stockalert_app/presentation/widgets/movimientos/tipo_movimiento_badge.dart';

class MovimientoCard extends StatelessWidget {
  final Movimiento movimiento;

  const MovimientoCard({super.key, required this.movimiento});

  Color get _colorCantidad {
    if (movimiento.tipo == 'salida') return AppColors.info;
    if (movimiento.tipo == 'ajuste') return AppColors.warning;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.marino20.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movimiento.producto,
                      style: AppFonts.bodyText2.copyWith(
                        color: AppColors.marino,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (movimiento.categoria != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        movimiento.categoria!,
                        style: AppFonts.caption.copyWith(
                          color: AppColors.softText,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    cantidadConSigno(movimiento.tipo, movimiento.cantidad),
                    style: AppFonts.headline3.copyWith(
                      color: _colorCantidad,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(height: 2),
                  TipoMovimientoBadge(tipo: movimiento.tipo),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                size: 13,
                color: AppColors.softText,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  formatoFechaHora(movimiento.fecha),
                  style: AppFonts.caption.copyWith(color: AppColors.softText),
                ),
              ),
              Text(
                folioMovimiento(movimiento.id),
                style: AppFonts.caption.copyWith(
                  color: AppColors.softText,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.person_outline_rounded,
                size: 13,
                color: AppColors.softText,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  movimiento.usuario,
                  style: AppFonts.caption.copyWith(color: AppColors.softText),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (movimiento.observaciones != null &&
              movimiento.observaciones!.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.row,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                movimiento.observaciones!,
                style: AppFonts.caption.copyWith(color: AppColors.text),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
