import 'package:stockalert_app/domain/entities/dashboard.dart';

abstract class DashboardRepository {
  Future<Dashboard> obtener({int meses = 6});
}
