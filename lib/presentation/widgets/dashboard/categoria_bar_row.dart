import 'package:flutter/material.dart';
import 'package:stockalert_app/config/theme/app_theme.dart';

class CategoriaBarRow extends StatelessWidget {
  final String categoria;
  final int unidades;
  final int maximo;

  const CategoriaBarRow({
    super.key,
    required this.categoria,
    required this.unidades,
    required this.maximo,
  });

  @override
  Widget build(BuildContext context) {
    final proporcion = maximo <= 0 ? 0.0 : (unidades / maximo).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  categoria,
                  style: AppFonts.bodyText3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                _formato(unidades),
                style: AppFonts.bodyText3.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: proporcion,
              minHeight: 8,
              backgroundColor: AppColors.marino10,
              valueColor: const AlwaysStoppedAnimation(AppColors.blueSeries1),
            ),
          ),
        ],
      ),
    );
  }

  String _formato(int valor) {
    final texto = valor.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < texto.length; i++) {
      if (i > 0 && (texto.length - i) % 3 == 0) buffer.write(',');
      buffer.write(texto[i]);
    }
    return buffer.toString();
  }
}
