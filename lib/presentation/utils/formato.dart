String formatoNumero(int valor) {
  final negativo = valor < 0;
  final texto = valor.abs().toString();
  final buffer = StringBuffer(negativo ? '-' : '');
  for (var i = 0; i < texto.length; i++) {
    if (i > 0 && (texto.length - i) % 3 == 0) buffer.write(',');
    buffer.write(texto[i]);
  }
  return buffer.toString();
}

String formatoPorcentaje(double valor) {
  final porcentaje = valor * 100;
  final redondeado = (porcentaje * 10).round() / 10;
  final texto = redondeado == redondeado.roundToDouble()
      ? redondeado.toStringAsFixed(0)
      : redondeado.toStringAsFixed(1);
  return '${texto.replaceAll('.', ',')}%';
}

String formatoMoneda(double valor) {
  final centavos = (valor * 100).round();
  final enteros = centavos ~/ 100;
  final resto = (centavos % 100).abs();
  return '\$${formatoNumero(enteros)}.${resto.toString().padLeft(2, '0')}';
}

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

String etiquetaMes(String mes) {
  final partes = mes.split('-');
  if (partes.length < 2) return mes;
  final numero = int.tryParse(partes[1]);
  if (numero == null || numero < 1 || numero > 12) return mes;
  return '${_mesesCortos[numero - 1]} ${partes[0]}';
}
