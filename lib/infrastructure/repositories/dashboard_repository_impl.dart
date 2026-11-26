import 'package:stockalert_app/domain/datasources/dashboard_datasource.dart';
import 'package:stockalert_app/domain/entities/dashboard.dart';
import 'package:stockalert_app/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardDatasource datasource;

  DashboardRepositoryImpl(this.datasource);

  @override
  Future<Dashboard> obtener({int meses = 6}) => datasource.obtener(meses: meses);
}
