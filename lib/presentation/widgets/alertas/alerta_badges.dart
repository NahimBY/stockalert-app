import 'package:flutter/material.dart';
import 'package:stockalert_app/config/theme/app_theme.dart';

class AlertaTipoBadge extends StatelessWidget {
  final String tipo;

  const AlertaTipoBadge({super.key, required this.tipo});

  /// La web usa 'agotado' → error y 'stock_bajo' → alerta (ámbar).
  ({String texto, IconData icono, Color color, Color fondo}) get _estilo {
    if (tipo == 'agotado') {
      return (
        texto: 'Agotado',
        icono: Icons.remove_shopping_cart_outlined,
        color: AppColors.error,
        fondo: AppColors.error10,
      );
    }
    return (
      texto: 'Stock bajo',
      icono: Icons.warning_amber_rounded,
      color: AppColors.warning,
      fondo: AppColors.warning10,
    );
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

class AlertaEstadoBadge extends StatelessWidget {
  final String estado;

  const AlertaEstadoBadge({super.key, required this.estado});

  /// La web: pendiente → error, atendida → éxito, cerrada → neutro.
  ({String texto, Color color, Color fondo}) get _estilo {
    switch (estado) {
      case 'atendida':
        return (
          texto: 'Atendida',
          color: AppColors.success,
          fondo: AppColors.success10,
        );
      case 'cerrada':
        return (
          texto: 'Cerrada',
          color: AppColors.softText,
          fondo: AppColors.row,
        );
      default:
        return (
          texto: 'Pendiente',
          color: AppColors.error,
          fondo: AppColors.error10,
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
