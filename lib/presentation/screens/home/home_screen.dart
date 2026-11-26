import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockalert_app/config/router/app_router.dart';
import 'package:stockalert_app/config/theme/app_theme.dart';
import 'package:stockalert_app/presentation/screens/auth/cubit/login/auth_cubit.dart';
import 'package:stockalert_app/presentation/screens/auth/cubit/login/auth_state.dart';
import 'package:stockalert_app/presentation/screens/home/widgets/dashboard_body.dart';
import 'package:stockalert_app/presentation/widgets/user_avatar.dart';

class HomeScreen extends StatelessWidget {
  static const name = "home_screen";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthCubit>().state;
    final usuario = state is AuthSuccess ? state.usuario : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dashboard', style: AppFonts.headline2),
            Text('Indicadores de inventario y ventas', style: AppFonts.caption),
          ],
        ),
        actions: [
          if (usuario != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: UserAvatar(
                nombre: usuario.nombre,
                onTap:
                    () => context.read<RouterSimpleCubit>().pushRoute(
                      'profile',
                      extra: usuario,
                    ),
              ),
            ),
        ],
      ),
      body: const SafeArea(child: DashboardBody()),
    );
  }
}
