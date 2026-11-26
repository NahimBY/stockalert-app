import 'package:flutter/material.dart';
import 'package:stockalert_app/config/theme/app_theme.dart';

class EstadoStockBadge extends StatelessWidget {
  final String estado;

  const EstadoStockBadge({super.key, required this.estado});

  ({String texto, Color color, Color fondo}) get _estilo {
    switch (estado) {
      case 'agotado':
        return (
          texto: 'Agotado',
          color: AppColors.error,
          fondo: AppColors.error10,
        );
      case 'bajo':
        return (
          texto: 'Bajo mínimo',
          color: AppColors.warning,
          fondo: AppColors.warning10,
        );
      default:
        return (
          texto: 'En orden',
          color: AppColors.success,
          fondo: AppColors.success10,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final estilo = _estilo;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: estilo.fondo,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        estilo.texto,
        style: AppFonts.caption.copyWith(
          color: estilo.color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
