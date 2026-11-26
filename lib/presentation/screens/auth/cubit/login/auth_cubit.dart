import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockalert_app/domain/entities/usuario.dart';
import 'package:stockalert_app/domain/repositories/auth_repository.dart';
import 'package:stockalert_app/infrastructure/errors/api_error.dart';
import 'package:stockalert_app/infrastructure/services/refresh_token_service.dart';
import 'package:stockalert_app/presentation/screens/auth/cubit/login/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;

  final formKey = GlobalKey<FormState>();
  final correoController = TextEditingController();
  final contrasenaController = TextEditingController();

  AuthCubit(this.repository, {Usuario? usuarioRestaurado})
    : super(
        usuarioRestaurado == null
            ? const AuthInitial()
            : AuthSuccess(usuarioRestaurado),
      );

  Future<void> iniciarSesion() async {
    final obscure = state.obscurePassword;
    emit(AuthLoading(obscurePassword: obscure));
    try {
      final sesion = await repository.iniciarSesion(
        correo: correoController.text.trim(),
        contrasena: contrasenaController.text,
      );
      emit(AuthSuccess(sesion.usuario, obscurePassword: obscure));
    } on ApiException catch (e) {
      emit(AuthError(e.message, obscurePassword: obscure));
    } catch (_) {
      emit(
        AuthError(
          'Ocurrió un error inesperado. Inténtalo de nuevo.',
          obscurePassword: obscure,
        ),
      );
    }
  }

  void togglePasswordVisibility() {
    final obscure = !state.obscurePassword;
    final current = state;
    if (current is AuthInitial) {
      emit(AuthInitial(obscurePassword: obscure));
    } else if (current is AuthLoading) {
      emit(AuthLoading(obscurePassword: obscure));
    } else if (current is AuthSuccess) {
      emit(AuthSuccess(current.usuario, obscurePassword: obscure));
    } else if (current is AuthError) {
      emit(AuthError(current.message, obscurePassword: obscure));
    }
  }

  void limpiarError() {
    if (state is AuthError) {
      emit(AuthInitial(obscurePassword: state.obscurePassword));
    }
  }

  Future<void> actualizarUsuario() async {
    final current = state;
    if (current is! AuthSuccess) return;
    final obscure = current.obscurePassword;
    emit(AuthLoading(obscurePassword: obscure));
    try {
      final usuario = await repository.usuarioActual();
      emit(AuthSuccess(usuario, obscurePassword: obscure));
    } on ApiException catch (e) {
      emit(AuthError(e.message, obscurePassword: obscure));
      emit(AuthSuccess(current.usuario, obscurePassword: obscure));
    } catch (_) {
      emit(AuthSuccess(current.usuario, obscurePassword: obscure));
    }
  }

  Future<void> cerrarSesion() async {
    final obscure = state.obscurePassword;
    try {
      await repository.cerrarSesion(RefreshTokenService.instance.refreshToken);
    } on ApiException catch (_) {
      // El datasource ya limpia el storage aunque el servidor falle.
    } catch (_) {
      // Idem: la sesion local se cierra de todos modos.
    }
    correoController.clear();
    contrasenaController.clear();
    emit(AuthInitial(obscurePassword: obscure));
  }

  @override
  Future<void> close() {
    correoController.dispose();
    contrasenaController.dispose();
    return super.close();
  }
}
