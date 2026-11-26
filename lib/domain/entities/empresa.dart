class Empresa {
  final int id;
  final String nombre;
  final DateTime? fechaRegistro;
  final bool estado;
  final int usuarios;
  final int productos;

  const Empresa({
    required this.id,
    required this.nombre,
    required this.estado,
    required this.usuarios,
    required this.productos,
    this.fechaRegistro,
  });
}
