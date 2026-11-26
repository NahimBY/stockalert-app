import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockalert_app/config/router/cubit/navigation_cubit.dart';
import 'package:stockalert_app/config/router/cubit/navigation_state.dart';
import 'package:stockalert_app/config/theme/app_theme.dart';
import 'package:stockalert_app/presentation/screens/screens.dart';

class NavigationWrapper extends StatelessWidget {
  static const String name = 'navigation_wrapper';

  const NavigationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: IndexedStack(
            index: state.currentTab.index,
            children: const [
              HomeScreen(),
              ProductosScreen(),
              MovimientosScreen(),
              AlertasScreen(),
            ],
          ),
          bottomNavigationBar: Container(
            color: Colors.white,
            child: NavigationBar(
              height: 72,
              selectedIndex: state.currentTab.index,
              backgroundColor: Colors.white,
              indicatorColor: AppColors.marino10,
              surfaceTintColor: Colors.transparent,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.selected)) {
                  return AppFonts.caption.copyWith(
                    color: AppColors.marino,
                    fontWeight: FontWeight.w700,
                  );
                }
                return AppFonts.caption.copyWith(color: AppColors.softText);
              }),
              onDestinationSelected: (index) {
                FocusScope.of(context).unfocus();
                context.read<NavigationCubit>().setTab(
                  NavigationTab.values[index],
                );
              },
              destinations: _destinations,
            ),
          ),
        );
      },
    );
  }

  static const List<NavigationDestination> _destinations = [
    NavigationDestination(
      icon: Icon(
        Icons.space_dashboard_outlined,
        size: 26,
        color: AppColors.softText,
      ),
      selectedIcon: Icon(
        Icons.space_dashboard_rounded,
        size: 26,
        color: AppColors.marino,
      ),
      label: 'Inicio',
    ),
    NavigationDestination(
      icon: Icon(
        Icons.inventory_2_outlined,
        size: 26,
        color: AppColors.softText,
      ),
      selectedIcon: Icon(
        Icons.inventory_2_rounded,
        size: 26,
        color: AppColors.marino,
      ),
      label: 'Productos',
    ),
    NavigationDestination(
      icon: Icon(
        Icons.swap_horiz_rounded,
        size: 26,
        color: AppColors.softText,
      ),
      selectedIcon: Icon(
        Icons.swap_horiz_rounded,
        size: 26,
        color: AppColors.marino,
      ),
      label: 'Movimientos',
    ),
    NavigationDestination(
      icon: Icon(
        Icons.notifications_none_rounded,
        size: 26,
        color: AppColors.softText,
      ),
      selectedIcon: Icon(
        Icons.notifications_rounded,
        size: 26,
        color: AppColors.marino,
      ),
      label: 'Alertas',
    ),
  ];
}
