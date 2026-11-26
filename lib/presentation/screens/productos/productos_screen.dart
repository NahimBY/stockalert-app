import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockalert_app/config/theme/app_theme.dart';
import 'package:stockalert_app/presentation/screens/productos/cubit/productos_cubit.dart';
import 'package:stockalert_app/presentation/screens/productos/cubit/productos_state.dart';
import 'package:stockalert_app/presentation/screens/productos/widgets/productos_body.dart';

class ProductosScreen extends StatelessWidget {
  static const String name = 'productos_screen';

  const ProductosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: BlocBuilder<ProductosCubit, ProductosState>(
                builder: (context, state) {
                  final total = switch (state) {
                    ProductosSuccess(:final pagina) => pagina.total,
                    ProductosLoading(:final anterior) => anterior?.total,
                    _ => null,
                  };

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Productos',
                              style: AppFonts.headline2,
                            ),
                          ),
                          if (total != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.marino10,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                '$total',
                                style: AppFonts.caption.copyWith(
                                  color: AppColors.marino,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Text(
                        'Catálogo con el stock actual frente a su mínimo',
                        style: AppFonts.caption,
                      ),
                    ],
                  );
                },
              ),
            ),
            const Expanded(child: ProductosBody()),
          ],
        ),
      ),
    );
  }
}
