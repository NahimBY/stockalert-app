import 'package:flutter/material.dart';
import 'package:stockalert_app/config/theme/app_theme.dart';
import 'package:stockalert_app/domain/entities/producto.dart';
import 'package:stockalert_app/presentation/utils/formato.dart';
import 'package:stockalert_app/presentation/widgets/productos/estado_stock_badge.dart';

class ProductoCard extends StatelessWidget {
  final Producto producto;

  const ProductoCard({super.key, required this.producto});

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
                      producto.nombre,
                      style: AppFonts.bodyText2.copyWith(
                        color: AppColors.marino,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (producto.categoria != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        producto.categoria!,
                        style: AppFonts.caption.copyWith(
                          color: AppColors.softText,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              EstadoStockBadge(estado: producto.estadoStock),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _Dato(
                  label: 'Stock',
                  valor: formatoNumero(producto.stockActual),
                  resaltado:
                      producto.estadoStock == 'bajo' ||
                      producto.estadoStock == 'agotado',
                ),
              ),
              Expanded(
                child: _Dato(
                  label: 'Mínimo',
                  valor: formatoNumero(producto.stockMinimo),
                ),
              ),
              Expanded(
                child: _Dato(
                  label: 'Precio',
                  valor: formatoMoneda(producto.precio),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Dato extends StatelessWidget {
  final String label;
  final String valor;
  final bool resaltado;

  const _Dato({
    required this.label,
    required this.valor,
    this.resaltado = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppFonts.caption.copyWith(color: AppColors.softText),
        ),
        const SizedBox(height: 2),
        Text(
          valor,
          style: AppFonts.bodyText3.copyWith(
            fontWeight: FontWeight.w600,
            color: resaltado ? AppColors.error : AppColors.text,
          ),
        ),
      ],
    );
  }
}
