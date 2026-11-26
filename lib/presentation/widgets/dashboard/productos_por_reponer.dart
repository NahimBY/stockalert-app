import 'package:flutter/material.dart';
import 'package:stockalert_app/config/theme/app_theme.dart';
import 'package:stockalert_app/domain/entities/dashboard.dart';

class ProductosPorReponer extends StatelessWidget {
  final List<ProductoPorReponer> productos;

  const ProductosPorReponer({super.key, required this.productos});

  @override
  Widget build(BuildContext context) {
    if (productos.isEmpty) {
      return Text(
        'Todos los productos están en o por encima de su stock mínimo.',
        style: AppFonts.caption.copyWith(color: AppColors.softText),
      );
    }

    return Column(
      children: [
        for (var i = 0; i < productos.length; i++) ...[
          if (i > 0) const Divider(height: 20),
          _ReponerRow(producto: productos[i]),
        ],
      ],
    );
  }
}

class _ReponerRow extends StatelessWidget {
  final ProductoPorReponer producto;

  const _ReponerRow({required this.producto});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                producto.nombre,
                style: AppFonts.bodyText2.copyWith(color: AppColors.marino),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                '${producto.stockActual} en stock · mínimo ${producto.stockMinimo}',
                style: AppFonts.caption.copyWith(color: AppColors.softText),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.error10,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            'Faltan ${producto.faltante}',
            style: AppFonts.caption.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
