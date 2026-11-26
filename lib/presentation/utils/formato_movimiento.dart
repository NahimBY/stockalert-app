const List<String> _mesesCortos = [
  'ene',
  'feb',
  'mar',
  'abr',
  'may',
  'jun',
  'jul',
  'ago',
  'sep',
  'oct',
  'nov',
  'dic',
];

String formatoFechaHora(DateTime? fecha) {
  if (fecha == null) return '—';
  final local = fecha.toLocal();
  final dia = local.day.toString().padLeft(2, '0');
  final mes = _mesesCortos[local.month - 1];
  final hora = local.hour.toString().padLeft(2, '0');
  final minuto = local.minute.toString().padLeft(2, '0');
  return '$dia $mes ${local.year} · $hora:$minuto';
}

String folioMovimiento(int id) {
  return 'MOV-${id.toString().padLeft(6, '0')}';
}

String folioAlerta(int id) {
  return 'ALT-${id.toString().padLeft(5, '0')}';
}

/// Las salidas restan; los ajustes pueden sumar o restar según el signo.
String cantidadConSigno(String tipo, int cantidad) {
  if (tipo == 'salida') return '−$cantidad';
  if (tipo == 'ajuste') {
    return cantidad > 0 ? '+$cantidad' : '−${-cantidad}';
  }
  return '+$cantidad';
}
