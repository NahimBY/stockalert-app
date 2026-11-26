class Dashboard {
  final int meses;
  final PeriodoDashboard periodo;
  final StockBajoDashboard stockBajo;
  final UnidadesVendidasDashboard unidadesVendidas;
  final CategoriaTopDashboard? categoriaTop;
  final List<MesDashboard> porMes;
  final List<CategoriaDashboard> porCategoria;
  final List<ProductoPorReponer> porReponer;

  const Dashboard({
    required this.meses,
    required this.periodo,
    required this.stockBajo,
    required this.unidadesVendidas,
    required this.porMes,
    required this.porCategoria,
    required this.porReponer,
    this.categoriaTop,
  });
}

class PeriodoDashboard {
  final DateTime? inicio;
  final DateTime? fin;

  const PeriodoDashboard({this.inicio, this.fin});
}

class StockBajoDashboard {
  final int productos;
  final int total;

  const StockBajoDashboard({required this.productos, required this.total});
}

class UnidadesVendidasDashboard {
  final int actual;
  final int? anterior;
  final double? variacion;

  const UnidadesVendidasDashboard({
    required this.actual,
    this.anterior,
    this.variacion,
  });
}

class CategoriaTopDashboard {
  final String categoria;
  final int unidades;
  final double participacion;

  const CategoriaTopDashboard({
    required this.categoria,
    required this.unidades,
    required this.participacion,
  });
}

class MesDashboard {
  final String mes;
  final int entradas;
  final int salidas;

  const MesDashboard({
    required this.mes,
    required this.entradas,
    required this.salidas,
  });
}

class CategoriaDashboard {
  final String categoria;
  final int unidades;

  const CategoriaDashboard({required this.categoria, required this.unidades});
}

class ProductoPorReponer {
  final int id;
  final String nombre;
  final String? categoria;
  final int stockActual;
  final int stockMinimo;
  final int faltante;

  const ProductoPorReponer({
    required this.id,
    required this.nombre,
    required this.stockActual,
    required this.stockMinimo,
    required this.faltante,
    this.categoria,
  });
}
