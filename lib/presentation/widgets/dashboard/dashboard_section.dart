import 'package:flutter/material.dart';
import 'package:stockalert_app/config/theme/app_theme.dart';

class DashboardSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;

  const DashboardSection({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.marino20.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: AppFonts.headline3),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              style: AppFonts.caption.copyWith(color: AppColors.softText),
            ),
          ],
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
