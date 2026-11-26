import 'package:stockalert_app/domain/entities/dashboard.dart';

class DashboardResponse {
  final int meses;
  final PeriodoDashboard periodo;
  final StockBajoDashboard stockBajo;
  final UnidadesVendidasDashboard unidadesVendidas;
  final CategoriaTopDashboard? categoriaTop;
  final List<MesDashboard> porMes;
  final List<CategoriaDashboard> porCategoria;
  final List<ProductoPorReponer> porReponer;

  const DashboardResponse({
    required this.meses,
    required this.periodo,
    required this.stockBajo,
    required this.unidadesVendidas,
    required this.porMes,
    required this.porCategoria,
    required this.porReponer,
    this.categoriaTop,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    final periodo = Map<String, dynamic>.from(json['periodo'] ?? {});
    final stockBajo = Map<String, dynamic>.from(json['stockBajo'] ?? {});
    final vendidas = Map<String, dynamic>.from(json['unidadesVendidas'] ?? {});
    final categoriaTopJson = json['categoriaTop'];

    return DashboardResponse(
      meses: (json['meses'] as num?)?.toInt() ?? 6,
      periodo: PeriodoDashboard(
        inicio: periodo['inicio'] != null
            ? DateTime.tryParse(periodo['inicio'])
            : null,
        fin: periodo['fin'] != null ? DateTime.tryParse(periodo['fin']) : null,
      ),
      stockBajo: StockBajoDashboard(
        productos: (stockBajo['productos'] as num?)?.toInt() ?? 0,
        total: (stockBajo['total'] as num?)?.toInt() ?? 0,
      ),
      unidadesVendidas: UnidadesVendidasDashboard(
        actual: (vendidas['actual'] as num?)?.toInt() ?? 0,
        anterior: (vendidas['anterior'] as num?)?.toInt(),
        variacion: (vendidas['variacion'] as num?)?.toDouble(),
      ),
      categoriaTop: categoriaTopJson is Map
          ? CategoriaTopDashboard(
              categoria: categoriaTopJson['categoria'] ?? '',
              unidades:
                  (categoriaTopJson['unidades'] as num?)?.toInt() ?? 0,
              participacion:
                  (categoriaTopJson['participacion'] as num?)?.toDouble() ?? 0,
            )
          : null,
      porMes: (json['porMes'] as List<dynamic>? ?? const [])
          .map(
            (e) => MesDashboard(
              mes: e['mes'] ?? '',
              entradas: (e['entradas'] as num?)?.toInt() ?? 0,
              salidas: (e['salidas'] as num?)?.toInt() ?? 0,
            ),
          )
          .toList(),
      porCategoria: (json['porCategoria'] as List<dynamic>? ?? const [])
          .map(
            (e) => CategoriaDashboard(
              categoria: e['categoria'] ?? '',
              unidades: (e['unidades'] as num?)?.toInt() ?? 0,
            ),
          )
          .toList(),
      porReponer: (json['porReponer'] as List<dynamic>? ?? const [])
          .map(
            (e) => ProductoPorReponer(
              id: (e['id_producto'] as num?)?.toInt() ?? 0,
              nombre: e['nombre'] ?? '',
              categoria: e['categoria'] as String?,
              stockActual: (e['stock_actual'] as num?)?.toInt() ?? 0,
              stockMinimo: (e['stock_minimo'] as num?)?.toInt() ?? 0,
              faltante: (e['faltante'] as num?)?.toInt() ?? 0,
            ),
          )
          .toList(),
    );
  }
}
