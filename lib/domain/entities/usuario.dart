class Usuario {
  final int id;
  final String nombre;
  final String correo;
  final String rol;
  final int? empresaId;
  final String? empresaNombre;
  final bool estado;
  final DateTime? fechaRegistro;

  const Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.rol,
    this.empresaId,
    this.empresaNombre,
    this.estado = true,
    this.fechaRegistro,
  });

  bool get esPlataforma => rol == 'plataforma';
}
