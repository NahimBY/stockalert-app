import 'package:stockalert_app/domain/entities/usuario.dart';

abstract class AuthState {
  final bool obscurePassword;

  const AuthState({this.obscurePassword = true});
}

class AuthInitial extends AuthState {
  const AuthInitial({super.obscurePassword});
}

class AuthLoading extends AuthState {
  const AuthLoading({super.obscurePassword});
}

class AuthSuccess extends AuthState {
  final Usuario usuario;

  const AuthSuccess(this.usuario, {super.obscurePassword});
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message, {super.obscurePassword});
}
