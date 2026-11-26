import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockalert_app/config/theme/app_theme.dart';
import 'package:stockalert_app/presentation/screens/alertas/cubit/alertas_cubit.dart';
import 'package:stockalert_app/presentation/screens/alertas/cubit/alertas_state.dart';
import 'package:stockalert_app/presentation/screens/alertas/widgets/alertas_body.dart';

class AlertasScreen extends StatelessWidget {
  static const String name = 'alertas_screen';

  const AlertasScreen({super.key});

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
              child: BlocBuilder<AlertasCubit, AlertasState>(
                builder: (context, state) {
                  final pendientes = state is AlertasSuccess
                      ? state.resumen.pendientes
                      : null;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text('Alertas', style: AppFonts.headline2),
                          ),
                          if (pendientes != null && pendientes > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.error10,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                '$pendientes pendientes',
                                style: AppFonts.caption.copyWith(
                                  color: AppColors.error,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Text(
                        'Stock bajo y productos agotados',
                        style: AppFonts.caption,
                      ),
                    ],
                  );
                },
              ),
            ),
            const Expanded(child: AlertasBody()),
          ],
        ),
      ),
    );
  }
}
