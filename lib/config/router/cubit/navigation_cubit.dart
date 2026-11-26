import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockalert_app/config/router/app_router.dart';
import 'package:stockalert_app/config/router/cubit/navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  final RouterSimpleCubit router;

  NavigationCubit({required this.router}) : super(const NavigationState());

  void navigateToHome() => _select(NavigationTab.home);

  void navigateToProductos() => _select(NavigationTab.productos);

  void navigateToMovimientos() => _select(NavigationTab.movimientos);

  void navigateToAlertas() => _select(NavigationTab.alertas);

  void setTab(NavigationTab tab) => emit(state.copyWith(currentTab: tab));

  void _select(NavigationTab tab) {
    setTab(tab);
    router.goWrapper();
  }
}
