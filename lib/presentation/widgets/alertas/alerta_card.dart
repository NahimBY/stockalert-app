import 'package:flutter/material.dart';
import 'package:stockalert_app/config/theme/app_theme.dart';
import 'package:stockalert_app/domain/entities/alerta.dart';
import 'package:stockalert_app/presentation/utils/formato_movimiento.dart';
import 'package:stockalert_app/presentation/widgets/alertas/alerta_badges.dart';

class AlertaCard extends StatelessWidget {
  final Alerta alerta;
  final bool actualizando;
  final VoidCallback? onMarcarAtendida;

  const AlertaCard({
    super.key,
    required this.alerta,
    this.actualizando = false,
    this.onMarcarAtendida,
  });

  bool get _esPendiente => alerta.estado == 'pendiente';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _esPendiente
              ? AppColors.error.withValues(alpha: 0.35)
              : AppColors.marino20.withValues(alpha: 0.6),
        ),
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
                      alerta.producto,
                      style: AppFonts.bodyText2.copyWith(
                        color: AppColors.marino,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (alerta.categoria != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        alerta.categoria!,
                        style: AppFonts.caption.copyWith(
                          color: AppColors.softText,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              AlertaEstadoBadge(estado: alerta.estado),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              AlertaTipoBadge(tipo: alerta.tipo),
              const SizedBox(width: 8),
              Text(
                'Stock detectado: ${alerta.stockDetectado}',
                style: AppFonts.caption.copyWith(color: AppColors.softText),
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
                  formatoFechaHora(alerta.fechaGeneracion),
                  style: AppFonts.caption.copyWith(color: AppColors.softText),
                ),
              ),
              Text(
                folioAlerta(alerta.id),
                style: AppFonts.caption.copyWith(
                  color: AppColors.softText,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          if (alerta.fechaAtencion != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  size: 13,
                  color: AppColors.softText,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Atendida ${formatoFechaHora(alerta.fechaAtencion)}',
                    style: AppFonts.caption.copyWith(color: AppColors.softText),
                  ),
                ),
              ],
            ),
          ],
          if (_esPendiente && onMarcarAtendida != null) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: OutlinedButton.icon(
                onPressed: actualizando ? null : onMarcarAtendida,
                icon: actualizando
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check_rounded, size: 18),
                label: Text(
                  actualizando ? 'Actualizando…' : 'Marcar como atendida',
                  style: AppFonts.caption.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.marino,
                  side: const BorderSide(color: AppColors.marino20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
