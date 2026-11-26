import 'package:flutter/material.dart';
import 'package:stockalert_app/config/theme/app_theme.dart';
import 'package:stockalert_app/presentation/utils/formato.dart';

class PaginacionBarra extends StatelessWidget {
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final ValueChanged<int> onIrAPagina;

  const PaginacionBarra({
    super.key,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.onIrAPagina,
  });

  @override
  Widget build(BuildContext context) {
    final desde = total == 0 ? 0 : (page - 1) * limit + 1;
    final hasta = total == 0 ? 0 : (page * limit).clamp(0, total);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.marino20.withValues(alpha: 0.6)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$desde – $hasta de ${formatoNumero(total)}',
              style: AppFonts.caption.copyWith(color: AppColors.softText),
            ),
          ),
          IconButton(
            onPressed: page > 1 ? () => onIrAPagina(1) : null,
            icon: const Icon(Icons.first_page_rounded),
            iconSize: 22,
            tooltip: 'Primera página',
          ),
          IconButton(
            onPressed: page > 1 ? () => onIrAPagina(page - 1) : null,
            icon: const Icon(Icons.chevron_left_rounded),
            iconSize: 22,
            tooltip: 'Página anterior',
          ),
          Text(
            '$page / $totalPages',
            style: AppFonts.caption.copyWith(
              color: AppColors.text,
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            onPressed: page < totalPages ? () => onIrAPagina(page + 1) : null,
            icon: const Icon(Icons.chevron_right_rounded),
            iconSize: 22,
            tooltip: 'Página siguiente',
          ),
          IconButton(
            onPressed:
                page < totalPages ? () => onIrAPagina(totalPages) : null,
            icon: const Icon(Icons.last_page_rounded),
            iconSize: 22,
            tooltip: 'Última página',
          ),
        ],
      ),
    );
  }
}

class EstadoErrorLista extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const EstadoErrorLista({
    super.key,
    required this.message,
    required this.onRetry,
  });

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

class EstadoVacioLista extends StatelessWidget {
  final String message;

  const EstadoVacioLista({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 40),
        Icon(
          Icons.inbox_outlined,
          size: 40,
          color: AppColors.softText.withValues(alpha: 0.6),
        ),
        const SizedBox(height: 12),
        Text(
          message,
          textAlign: TextAlign.center,
          style: AppFonts.bodyText3.copyWith(color: AppColors.softText),
        ),
      ],
    );
  }
}
