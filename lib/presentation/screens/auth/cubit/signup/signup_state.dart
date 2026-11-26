import 'package:stockalert_app/domain/entities/usuario.dart';

abstract class SignupState {
  final bool obscurePassword;

  const SignupState({this.obscurePassword = true});
}

class SignupInitial extends SignupState {
  const SignupInitial({super.obscurePassword});
}

class SignupLoading extends SignupState {
  const SignupLoading({super.obscurePassword});
}

class SignupSuccess extends SignupState {
  final Usuario usuario;

  const SignupSuccess(this.usuario, {super.obscurePassword});
}

class SignupError extends SignupState {
  final String message;

  const SignupError(this.message, {super.obscurePassword});
}
