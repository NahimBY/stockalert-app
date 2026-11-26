import 'package:flutter/material.dart';
import 'package:stockalert_app/config/theme/app_theme.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool alert;
  final String? detalle;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.alert = false,
    this.detalle,
  });

  @override
  Widget build(BuildContext context) {
    final acento = alert ? AppColors.error : AppColors.marino;
    final fondo = alert ? AppColors.error10 : AppColors.marino10;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.marino20.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppFonts.caption.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: fondo,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: acento),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: AppFonts.headline2.copyWith(color: AppColors.marino),
          ),
          if (detalle != null) ...[
            const SizedBox(height: 6),
            Text(
              detalle!,
              style: AppFonts.caption.copyWith(color: AppColors.softText),
            ),
          ],
        ],
      ),
    );
  }
}
