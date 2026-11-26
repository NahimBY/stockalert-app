import 'package:flutter_bloc/flutter_bloc.dart' show Cubit;
import 'package:go_router/go_router.dart';
import 'package:stockalert_app/domain/entities/usuario.dart';
import 'package:stockalert_app/presentation/screens/screens.dart';

GoRouter createRouter(String initialLocation) => GoRouter(
  initialLocation: initialLocation,
  routes: [
    GoRoute(
      name: NavigationWrapper.name,
      path: '/',
      builder: (context, state) => const NavigationWrapper(),
    ),
    GoRoute(
      name: LoginScreen.name,
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      name: SignupScreen.name,
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      name: ProfileScreen.name,
      path: '/profile',
      builder: (context, state) {
        final usuario = state.extra;
        if (usuario is! Usuario) {
          return const NavigationWrapper();
        }
        return ProfileScreen(usuario: usuario);
      },
    ),
  ],
);

class RouterSimpleCubit extends Cubit<GoRouter> {
  RouterSimpleCubit({String? initialRoute})
    : super(createRouter(initialRoute ?? '/login'));

  void goBack() {
    state.pop();
  }

  void goWrapper() {
    state.go('/');
  }

  void pushRoute(value, {Object? extra}) {
    state.push('/$value', extra: extra);
  }

  void goRoute(value, {Object? extra}) {
    state.go('/$value', extra: extra);
  }
}
