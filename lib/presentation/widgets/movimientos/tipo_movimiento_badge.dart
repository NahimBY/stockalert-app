import 'package:flutter/material.dart';
import 'package:stockalert_app/config/theme/app_theme.dart';

class TipoMovimientoBadge extends StatelessWidget {
  final String tipo;

  const TipoMovimientoBadge({super.key, required this.tipo});

  ({String texto, IconData icono, Color color, Color fondo}) get _estilo {
    switch (tipo) {
      case 'entrada':
        return (
          texto: 'Entrada',
          icono: Icons.south_west_rounded,
          color: AppColors.success,
          fondo: AppColors.success10,
        );
      case 'salida':
        return (
          texto: 'Salida',
          icono: Icons.north_east_rounded,
          color: AppColors.info,
          fondo: AppColors.info10,
        );
      case 'ajuste':
        return (
          texto: 'Ajuste',
          icono: Icons.tune_rounded,
          color: AppColors.warning,
          fondo: AppColors.warning10,
        );
      default:
        return (
          texto: tipo,
          icono: Icons.circle_outlined,
          color: AppColors.softText,
          fondo: AppColors.row,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final estilo = _estilo;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: estilo.fondo,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(estilo.icono, size: 12, color: estilo.color),
          const SizedBox(width: 4),
          Text(
            estilo.texto,
            style: AppFonts.caption.copyWith(
              color: estilo.color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
