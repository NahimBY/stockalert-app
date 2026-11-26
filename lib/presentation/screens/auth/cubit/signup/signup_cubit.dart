import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockalert_app/domain/repositories/auth_repository.dart';
import 'package:stockalert_app/infrastructure/errors/api_error.dart';
import 'package:stockalert_app/presentation/screens/auth/cubit/signup/signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository repository;

  final formKey = GlobalKey<FormState>();
  final empresaController = TextEditingController();
  final nombreController = TextEditingController();
  final correoController = TextEditingController();
  final contrasenaController = TextEditingController();
  final confirmarContrasenaController = TextEditingController();

  SignupCubit(this.repository) : super(const SignupInitial());

  Future<void> registrarNegocio() async {
    final obscure = state.obscurePassword;
    emit(SignupLoading(obscurePassword: obscure));
    try {
      final sesion = await repository.registrarNegocio(
        empresa: empresaController.text.trim(),
        nombre: nombreController.text.trim(),
        correo: correoController.text.trim(),
        contrasena: contrasenaController.text,
      );
      emit(SignupSuccess(sesion.usuario, obscurePassword: obscure));
    } on ApiException catch (e) {
      emit(SignupError(e.message, obscurePassword: obscure));
    } catch (_) {
      emit(
        SignupError(
          'Ocurrió un error inesperado. Inténtalo de nuevo.',
          obscurePassword: obscure,
        ),
      );
    }
  }

  void togglePasswordVisibility() {
    final obscure = !state.obscurePassword;
    final current = state;
    if (current is SignupInitial) {
      emit(SignupInitial(obscurePassword: obscure));
    } else if (current is SignupLoading) {
      emit(SignupLoading(obscurePassword: obscure));
    } else if (current is SignupSuccess) {
      emit(SignupSuccess(current.usuario, obscurePassword: obscure));
    } else if (current is SignupError) {
      emit(SignupError(current.message, obscurePassword: obscure));
    }
  }

  void limpiarError() {
    if (state is SignupError) {
      emit(SignupInitial(obscurePassword: state.obscurePassword));
    }
  }

  @override
  Future<void> close() {
    empresaController.dispose();
    nombreController.dispose();
    correoController.dispose();
    contrasenaController.dispose();
    confirmarContrasenaController.dispose();
    return super.close();
  }
}
