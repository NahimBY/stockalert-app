import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockalert_app/config/router/app_router.dart';
import 'package:stockalert_app/config/theme/app_theme.dart';
import 'package:stockalert_app/domain/entities/usuario.dart';
import 'package:stockalert_app/presentation/screens/auth/cubit/login/auth_cubit.dart';
import 'package:stockalert_app/presentation/screens/auth/cubit/login/auth_state.dart';
import 'package:stockalert_app/presentation/widgets/user_avatar.dart';

class ProfileScreen extends StatelessWidget {
  static const String name = 'profile_screen';

  final Usuario usuario;

  const ProfileScreen({super.key, required this.usuario});

  static String _rol(Usuario usuario) {
    final rol = usuario.rol.trim();
    if (rol.isEmpty) return 'Sin rol';
    return rol[0].toUpperCase() + rol.substring(1);
  }

  static String _fechaRegistro(Usuario usuario) {
    final fecha = usuario.fechaRegistro;
    if (fecha == null) return '—';
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    return '$dia/$mes/${fecha.year}';
  }

  Future<void> _cerrarSesion(BuildContext context) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text('Cerrar sesión', style: AppFonts.headline3),
            content: Text(
              '¿Seguro que quieres salir de tu cuenta?',
              style: AppFonts.bodyText3.copyWith(color: AppColors.softText),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(
                  'Cancelar',
                  style: AppFonts.bodyText3.copyWith(color: AppColors.softText),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(
                  'Salir',
                  style: AppFonts.bodyText3.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
    );

    if (confirmar != true || !context.mounted) return;

    await context.read<AuthCubit>().cerrarSesion();
    if (!context.mounted) return;
    context.read<RouterSimpleCubit>().goRoute('login');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final actual = state is AuthSuccess ? state.usuario : usuario;
        final cargando = state is AuthLoading;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Mi perfil'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  tooltip: 'Actualizar',
                  onPressed:
                      cargando
                          ? null
                          : () => context.read<AuthCubit>().actualizarUsuario(),
                  icon:
                      cargando
                          ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Icon(Icons.refresh_rounded),
                ),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => context.read<AuthCubit>().actualizarUsuario(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _ProfileHeader(
                        nombre: actual.nombre,
                        correo: actual.correo,
                        rol: _rol(actual),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.marino20.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Column(
                          children: [
                            _InfoRow(
                              icon: Icons.mail_outline_rounded,
                              label: 'Correo',
                              value: actual.correo,
                            ),
                            const Divider(height: 28),
                            _InfoRow(
                              icon: Icons.badge_outlined,
                              label: 'Rol',
                              value: _rol(actual),
                            ),
                            if (actual.empresaNombre != null) ...[
                              const Divider(height: 28),
                              _InfoRow(
                                icon: Icons.storefront_outlined,
                                label: 'Negocio',
                                value: actual.empresaNombre!,
                              ),
                            ],
                            const Divider(height: 28),
                            _InfoRow(
                              icon: Icons.event_outlined,
                              label: 'Miembro desde',
                              value: _fechaRegistro(actual),
                            ),
                            const Divider(height: 28),
                            _InfoRow(
                              icon:
                                  actual.estado
                                      ? Icons.check_circle_outline_rounded
                                      : Icons.pause_circle_outline_rounded,
                              label: 'Estado',
                              value: actual.estado ? 'Activo' : 'Inactivo',
                              valueColor:
                                  actual.estado
                                      ? AppColors.success
                                      : AppColors.error,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        height: 54,
                        child: OutlinedButton.icon(
                          onPressed: () => _cerrarSesion(context),
                          icon: const Icon(
                            Icons.logout_rounded,
                            size: 20,
                            color: AppColors.error,
                          ),
                          label: Text(
                            'Cerrar sesión',
                            style: AppFonts.buttonText.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.error),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String nombre;
  final String correo;
  final String rol;

  const _ProfileHeader({
    required this.nombre,
    required this.correo,
    required this.rol,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserAvatar(nombre: nombre, size: 84),
        const SizedBox(height: 16),
        Text(
          nombre.isEmpty ? 'Usuario' : nombre,
          textAlign: TextAlign.center,
          style: AppFonts.headline2,
        ),
        const SizedBox(height: 4),
        Text(
          correo,
          textAlign: TextAlign.center,
          style: AppFonts.bodyText3.copyWith(color: AppColors.softText),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.marino10,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            rol,
            style: AppFonts.caption.copyWith(
              color: AppColors.marino,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.softText),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppFonts.caption.copyWith(color: AppColors.softText),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppFonts.bodyText2.copyWith(
                  color: valueColor ?? AppColors.text,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
