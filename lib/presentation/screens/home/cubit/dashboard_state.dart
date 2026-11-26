import 'package:stockalert_app/domain/entities/dashboard.dart';

abstract class DashboardState {
  const DashboardState();
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  final Dashboard? anterior;

  const DashboardLoading({this.anterior});
}

class DashboardSuccess extends DashboardState {
  final Dashboard dashboard;

  const DashboardSuccess(this.dashboard);
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);
}
