import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stockalert_app/config/router/app_router.dart';
import 'package:stockalert_app/config/router/cubit/navigation_cubit.dart';
import 'package:stockalert_app/config/theme/app_theme.dart';
import 'package:stockalert_app/domain/entities/usuario.dart';
import 'package:stockalert_app/infrastructure/datasources/alertasdb_datasource.dart';
import 'package:stockalert_app/infrastructure/datasources/authdb_datasource.dart';
import 'package:stockalert_app/infrastructure/datasources/categoriasdb_datasource.dart';
import 'package:stockalert_app/infrastructure/datasources/dashboarddb_datasource.dart';
import 'package:stockalert_app/infrastructure/datasources/movimientosdb_datasource.dart';
import 'package:stockalert_app/infrastructure/datasources/productosdb_datasource.dart';
import 'package:stockalert_app/infrastructure/repositories/alertas_repository_impl.dart';
import 'package:stockalert_app/infrastructure/repositories/auth_repository_impl.dart';
import 'package:stockalert_app/infrastructure/repositories/categorias_repository_impl.dart';
import 'package:stockalert_app/infrastructure/repositories/dashboard_repository_impl.dart';
import 'package:stockalert_app/infrastructure/repositories/movimientos_repository_impl.dart';
import 'package:stockalert_app/infrastructure/repositories/productos_repository_impl.dart';
import 'package:stockalert_app/infrastructure/services/key_value_storage_service.dart';
import 'package:stockalert_app/infrastructure/services/refresh_token_service.dart';
import 'package:stockalert_app/infrastructure/services/session_service.dart';
import 'package:stockalert_app/presentation/screens/alertas/cubit/alertas_cubit.dart';
import 'package:stockalert_app/presentation/screens/auth/cubit/login/auth_cubit.dart';
import 'package:stockalert_app/presentation/screens/auth/cubit/signup/signup_cubit.dart';
import 'package:stockalert_app/presentation/screens/home/cubit/dashboard_cubit.dart';
import 'package:stockalert_app/presentation/screens/movimientos/cubit/movimientos_cubit.dart';
import 'package:stockalert_app/presentation/screens/productos/cubit/productos_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await KeyValueStorageService.init();
  RefreshTokenService.instance;

  final usuarioRestaurado = await SessionService.restore();

  runApp(BlocsProviders(usuarioRestaurado: usuarioRestaurado));
}

class BlocsProviders extends StatelessWidget {
  final Usuario? usuarioRestaurado;

  const BlocsProviders({super.key, this.usuarioRestaurado});

  @override
  Widget build(context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => AuthCubit(
                AuthRepositoryImpl(AuthDatasourceImpl()),
                usuarioRestaurado: usuarioRestaurado,
              ),
        ),
        BlocProvider(
          create:
              (context) =>
                  SignupCubit(AuthRepositoryImpl(AuthDatasourceImpl())),
        ),
        BlocProvider(
          create:
              (context) => RouterSimpleCubit(
                initialRoute: usuarioRestaurado == null ? '/login' : '/',
              ),
        ),
        BlocProvider(
          create:
              (context) =>
                  NavigationCubit(router: context.read<RouterSimpleCubit>()),
        ),
        BlocProvider(
          create:
              (context) => DashboardCubit(
                DashboardRepositoryImpl(DashboardDatasourceImpl()),
              )..cargar(),
        ),
        BlocProvider(
          create:
              (context) => ProductosCubit(
                ProductosRepositoryImpl(ProductosDatasourceImpl()),
                CategoriasRepositoryImpl(CategoriasDatasourceImpl()),
              )..cargar(),
        ),
        BlocProvider(
          create:
              (context) => MovimientosCubit(
                MovimientosRepositoryImpl(MovimientosDatasourceImpl()),
                CategoriasRepositoryImpl(CategoriasDatasourceImpl()),
              )..cargar(),
        ),
        BlocProvider(
          create:
              (context) => AlertasCubit(
                AlertasRepositoryImpl(AlertasDatasourceImpl()),
              )..cargar(),
        ),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter appRouter = context.watch<RouterSimpleCubit>().state;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'StockAlert',
      routerConfig: appRouter,
      theme: AppTheme(selectedColor: 0).theme(),
      builder:
          (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
            value: appSystemUiStyle,
            child: child ?? const SizedBox.shrink(),
          ),
    );
  }
}
