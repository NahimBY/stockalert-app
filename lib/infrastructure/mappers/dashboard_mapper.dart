import 'package:stockalert_app/domain/entities/dashboard.dart';
import 'package:stockalert_app/infrastructure/models/dashboarddb/dashboard_response.dart';

class DashboardMapper {
  static Dashboard responseToEntity(DashboardResponse response) => Dashboard(
        meses: response.meses,
        periodo: response.periodo,
        stockBajo: response.stockBajo,
        unidadesVendidas: response.unidadesVendidas,
        categoriaTop: response.categoriaTop,
        porMes: response.porMes,
        porCategoria: response.porCategoria,
        porReponer: response.porReponer,
      );
}
