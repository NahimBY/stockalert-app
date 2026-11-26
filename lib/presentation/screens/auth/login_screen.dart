import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockalert_app/config/router/app_router.dart';
import 'package:stockalert_app/config/router/cubit/navigation_cubit.dart';
import 'package:stockalert_app/config/theme/app_theme.dart';
import 'package:stockalert_app/presentation/screens/auth/cubit/login/auth_cubit.dart';
import 'package:stockalert_app/presentation/screens/auth/cubit/login/auth_state.dart';
import 'package:stockalert_app/presentation/widgets/auth_ui.dart';

class LoginScreen extends StatelessWidget {
  static const String name = 'login_screen';

  const LoginScreen({super.key});

  void _onLoginSuccess(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.white,
          elevation: 8,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.success,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                'Sesión iniciada',
                style: AppFonts.bodyText3.copyWith(
                  color: AppColors.text,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );

    context.read<NavigationCubit>().navigateToHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              _onLoginSuccess(context);
            }
          },
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                24,
                MediaQuery.viewPaddingOf(context).top + 32,
                24,
                32,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const BrandHeader(),
                    const SizedBox(height: 32),
                    const _LoginForm(),
                    const SizedBox(height: 24),
                    Center(
                      child: Text(
                        'StockAlert · Inventario inteligente',
                        style: AppFonts.caption,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    final cubit = context.read<AuthCubit>();
    if (cubit.formKey.currentState?.validate() ?? false) {
      cubit.iniciarSesion();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return AuthCard(
          child: Form(
            key: cubit.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Iniciar sesión', style: AppFonts.headline2),
                const SizedBox(height: 4),
                Text(
                  'Ingresa a tu cuenta para continuar',
                  style: AppFonts.bodyText3.copyWith(color: AppColors.softText),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  controller: cubit.correoController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  onChanged: (_) => cubit.limpiarError(),
                  style: AppFonts.bodyText1,
                  decoration: authInputDecoration(
                    label: 'Correo',
                    hint: 'tu@correo.com',
                    icon: Icons.mail_outline_rounded,
                  ),
                  validator: (value) {
                    final correo = value?.trim() ?? '';
                    if (correo.isEmpty) return 'Ingresa tu correo';
                    final emailRegex = RegExp(
                      r'^[\w\.\+\-]+@[\w\-]+\.[\w\.\-]+$',
                    );
                    if (!emailRegex.hasMatch(correo)) {
                      return 'El correo no es válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  controller: cubit.contrasenaController,
                  obscureText: state.obscurePassword,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  onChanged: (_) => cubit.limpiarError(),
                  onFieldSubmitted: (_) => _submit(context),
                  style: AppFonts.bodyText1,
                  decoration: authInputDecoration(
                    label: 'Contraseña',
                    hint: 'Tu contraseña',
                    icon: Icons.lock_outline_rounded,
                  ).copyWith(
                    suffixIcon: IconButton(
                      onPressed: cubit.togglePasswordVisibility,
                      icon: Icon(
                        state.obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                        color: AppColors.softText,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu contraseña';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                AuthErrorBanner(
                  message: state is AuthError ? state.message : null,
                ),
                PrimaryButton(
                  loading: state is AuthLoading,
                  label: 'Entrar',
                  onPressed: () => _submit(context),
                ),
                // const SizedBox(height: 24),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text('¿No tienes una cuenta?'),
                //     TextButton(
                //       onPressed:
                //           () => context.read<RouterSimpleCubit>().pushRoute(
                //             'signup',
                //           ),
                //       child: Text(
                //         'Regístrate',
                //         style: TextStyle(fontWeight: FontWeight.bold),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
