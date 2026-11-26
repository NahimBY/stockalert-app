import 'package:flutter/material.dart';
import 'package:stockalert_app/config/theme/app_theme.dart';

class MiniLineChart extends StatelessWidget {
  final List<double> entradas;
  final List<double> salidas;
  final double height;

  const MiniLineChart({
    super.key,
    required this.entradas,
    required this.salidas,
    this.height = 160,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: _LinePainter(entradas: entradas, salidas: salidas),
        size: Size.infinite,
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  final List<double> entradas;
  final List<double> salidas;

  _LinePainter({required this.entradas, required this.salidas});

  @override
  void paint(Canvas canvas, Size size) {
    final total = [entradas, salidas].expand((e) => e);
    final maxValue = total.isEmpty
        ? 1.0
        : total.reduce((a, b) => a > b ? a : b).clamp(1.0, double.infinity);

    final grid = Paint()
      ..color = AppColors.grid
      ..strokeWidth = 1;

    for (var i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    _drawSeries(canvas, size, entradas, AppColors.blueSeries1, maxValue);
    _drawSeries(canvas, size, salidas, AppColors.orangeSeries2, maxValue);
  }

  void _drawSeries(
    Canvas canvas,
    Size size,
    List<double> values,
    Color color,
    double maxValue,
  ) {
    if (values.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = values.length == 1
          ? size.width / 2
          : size.width * i / (values.length - 1);
      final y = size.height - (values[i] / maxValue) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);

    final dot = Paint()..color = color;
    for (var i = 0; i < values.length; i++) {
      final x = values.length == 1
          ? size.width / 2
          : size.width * i / (values.length - 1);
      final y = size.height - (values[i] / maxValue) * size.height;
      canvas.drawCircle(Offset(x, y), 3.5, dot);
      canvas.drawCircle(
        Offset(x, y),
        3.5,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LinePainter oldDelegate) =>
      oldDelegate.entradas != entradas || oldDelegate.salidas != salidas;
}
