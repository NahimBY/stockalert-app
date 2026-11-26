import 'package:flutter/material.dart';
import 'package:stockalert_app/config/theme/app_theme.dart';

Future<void> mostrarFiltrosSheet(BuildContext context, Widget contenido) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => contenido,
  );
}

class FiltrosSheetShell extends StatelessWidget {
  final String titulo;
  final bool hayFiltros;
  final VoidCallback onLimpiar;
  final List<Widget> secciones;

  const FiltrosSheetShell({
    super.key,
    required this.titulo,
    required this.hayFiltros,
    required this.onLimpiar,
    required this.secciones,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.marino20,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 12, 0),
            child: Row(
              children: [
                Expanded(child: Text(titulo, style: AppFonts.headline3)),
                if (hayFiltros)
                  TextButton(
                    onPressed: onLimpiar,
                    child: Text(
                      'Limpiar',
                      style: AppFonts.label.copyWith(
                        color: AppColors.marino,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: secciones,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              8,
              20,
              MediaQuery.viewPaddingOf(context).bottom + 16,
            ),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.marino,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text('Ver resultados', style: AppFonts.buttonText),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FiltrosSeccion extends StatelessWidget {
  final String titulo;
  final Widget child;

  const FiltrosSeccion({
    super.key,
    required this.titulo,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            titulo,
            style: AppFonts.caption.copyWith(
              color: AppColors.softText,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class FiltrosOpcion extends StatelessWidget {
  final String label;
  final bool seleccionada;
  final VoidCallback onTap;

  const FiltrosOpcion({
    super.key,
    required this.label,
    required this.seleccionada,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
        child: Row(
          children: [
            Icon(
              seleccionada
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              size: 20,
              color: seleccionada ? AppColors.marino : AppColors.marino20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: AppFonts.bodyText2.copyWith(
                  color: seleccionada ? AppColors.marino : AppColors.text,
                  fontWeight: seleccionada
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FiltroActivoChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const FiltroActivoChip({
    super.key,
    required this.label,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return InputChip(
      label: Text(
        label,
        style: AppFonts.caption.copyWith(
          color: AppColors.marino,
          fontWeight: FontWeight.w600,
        ),
      ),
      onDeleted: onRemove,
      deleteIcon: const Icon(
        Icons.close_rounded,
        size: 16,
        color: AppColors.marino,
      ),
      backgroundColor: AppColors.marino10,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      labelPadding: const EdgeInsets.only(left: 8, right: 2),
    );
  }
}

class BotonFiltros extends StatelessWidget {
  final int cantidad;
  final VoidCallback onPressed;

  const BotonFiltros({
    super.key,
    required this.cantidad,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final activo = cantidad > 0;

    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          foregroundColor: AppColors.marino,
          side: BorderSide(
            color: activo ? AppColors.marino : AppColors.marino20,
            width: activo ? 1.5 : 1,
          ),
          backgroundColor: activo ? AppColors.marino10 : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.tune_rounded, size: 20),
            if (activo) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColors.marino,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '$cantidad',
                  style: AppFonts.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
