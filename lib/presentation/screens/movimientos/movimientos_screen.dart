import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockalert_app/config/theme/app_theme.dart';
import 'package:stockalert_app/presentation/screens/movimientos/cubit/movimientos_cubit.dart';
import 'package:stockalert_app/presentation/screens/movimientos/cubit/movimientos_state.dart';
import 'package:stockalert_app/presentation/screens/movimientos/widgets/movimientos_body.dart';

class MovimientosScreen extends StatelessWidget {
  static const String name = 'movimientos_screen';

  const MovimientosScreen({super.key});

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
              child: BlocBuilder<MovimientosCubit, MovimientosState>(
                builder: (context, state) {
                  final total = switch (state) {
                    MovimientosSuccess(:final pagina) => pagina.total,
                    MovimientosLoading(:final anterior) => anterior?.total,
                    _ => null,
                  };

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Movimientos',
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
                        'Entradas, salidas y ajustes registrados',
                        style: AppFonts.caption,
                      ),
                    ],
                  );
                },
              ),
            ),
            const Expanded(child: MovimientosBody()),
          ],
        ),
      ),
    );
  }
}
