import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockalert_app/domain/entities/dashboard.dart';
import 'package:stockalert_app/domain/repositories/dashboard_repository.dart';
import 'package:stockalert_app/infrastructure/errors/api_error.dart';
import 'package:stockalert_app/presentation/screens/home/cubit/dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  static const List<int> periodosDisponibles = [3, 6, 12];

  final DashboardRepository repository;

  int meses;

  DashboardCubit(this.repository, {this.meses = 6})
    : super(const DashboardInitial());

  Future<void> cargar() async {
    emit(DashboardLoading(anterior: _datosActuales));
    try {
      emit(DashboardSuccess(await repository.obtener(meses: meses)));
    } on ApiException catch (e) {
      emit(DashboardError(e.message));
    } catch (_) {
      emit(const DashboardError('No se pudo cargar el dashboard.'));
    }
  }

  Future<void> cambiarPeriodo(int meses) async {
    if (meses == this.meses) return;
    this.meses = meses;
    await cargar();
  }

  Dashboard? get _datosActuales {
    final state = this.state;
    if (state is DashboardSuccess) return state.dashboard;
    if (state is DashboardLoading) return state.anterior;
    return null;
  }
}
