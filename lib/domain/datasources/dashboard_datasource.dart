import 'package:stockalert_app/domain/entities/dashboard.dart';

abstract class DashboardDatasource {
  Future<Dashboard> obtener({int meses = 6});
}
