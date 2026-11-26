import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockalert_app/config/router/app_router.dart';
import 'package:stockalert_app/config/router/cubit/navigation_cubit.dart';
import 'package:stockalert_app/config/theme/app_theme.dart';
import 'package:stockalert_app/presentation/screens/auth/cubit/signup/signup_cubit.dart';
import 'package:stockalert_app/presentation/screens/auth/cubit/signup/signup_state.dart';
import 'package:stockalert_app/presentation/widgets/auth_ui.dart';

class SignupScreen extends StatelessWidget {
  static const String name = 'signup_screen';

  const SignupScreen({super.key});

  void _onSignupSuccess(BuildContext context) {
    showSuccessToast(context, 'Cuenta creada');
    context.read<NavigationCubit>().navigateToHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        child: BlocListener<SignupCubit, SignupState>(
          listener: (context, state) {
            if (state is SignupSuccess) {
              _onSignupSuccess(context);
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
                    const BrandHeader(subtitle: 'Crea la cuenta de tu negocio'),
                    const SizedBox(height: 32),
                    const _SignupForm(),
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

class _SignupForm extends StatelessWidget {
  const _SignupForm();

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    final cubit = context.read<SignupCubit>();
    if (cubit.formKey.currentState?.validate() ?? false) {
      cubit.registrarNegocio();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignupCubit>();

    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        return AuthCard(
          child: Form(
            key: cubit.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Crear cuenta', style: AppFonts.headline2),
                const SizedBox(height: 4),
                Text(
                  'Registra tu negocio para empezar',
                  style: AppFonts.bodyText3.copyWith(color: AppColors.softText),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  controller: cubit.empresaController,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => cubit.limpiarError(),
                  style: AppFonts.bodyText1,
                  decoration: authInputDecoration(
                    label: 'Negocio',
                    hint: 'Nombre de tu negocio',
                    icon: Icons.storefront_outlined,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingresa el nombre del negocio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  controller: cubit.nombreController,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.name],
                  onChanged: (_) => cubit.limpiarError(),
                  style: AppFonts.bodyText1,
                  decoration: authInputDecoration(
                    label: 'Nombre',
                    hint: 'Tu nombre completo',
                    icon: Icons.person_outline_rounded,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingresa tu nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
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
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.newPassword],
                  onChanged: (_) => cubit.limpiarError(),
                  style: AppFonts.bodyText1,
                  decoration: authInputDecoration(
                    label: 'Contraseña',
                    hint: 'Mínimo 8 caracteres',
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
                      return 'Ingresa una contraseña';
                    }
                    if (value.length < 8) {
                      return 'Usa al menos 8 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  controller: cubit.confirmarContrasenaController,
                  obscureText: state.obscurePassword,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.newPassword],
                  onChanged: (_) => cubit.limpiarError(),
                  onFieldSubmitted: (_) => _submit(context),
                  style: AppFonts.bodyText1,
                  decoration: authInputDecoration(
                    label: 'Confirmar contraseña',
                    hint: 'Repite tu contraseña',
                    icon: Icons.lock_outline_rounded,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirma tu contraseña';
                    }
                    if (value != cubit.contrasenaController.text) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                ),
                AuthErrorBanner(
                  message: state is SignupError ? state.message : null,
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  loading: state is SignupLoading,
                  label: 'Crear cuenta',
                  onPressed: () => _submit(context),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('¿Ya tienes una cuenta?'),
                    TextButton(
                      onPressed:
                          () => context.read<RouterSimpleCubit>().goBack(),
                      child: Text(
                        'Inicia sesión',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
