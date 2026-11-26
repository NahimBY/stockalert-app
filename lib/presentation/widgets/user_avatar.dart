import 'package:flutter/material.dart';
import 'package:stockalert_app/config/theme/app_theme.dart';

class UserAvatar extends StatelessWidget {
  final String nombre;
  final double size;
  final VoidCallback? onTap;

  const UserAvatar({
    super.key,
    required this.nombre,
    this.size = 38,
    this.onTap,
  });

  String get _initial {
    final trimmed = nombre.trim();
    if (trimmed.isEmpty) return '?';
    return trimmed.characters.first.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final label = Text(
      _initial,
      style: AppFonts.bodyText2.copyWith(
        color: Colors.white,
        fontSize: size * 0.42,
        fontWeight: FontWeight.w600,
      ),
    );

    if (onTap == null) {
      return Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: AppColors.marino,
          shape: BoxShape.circle,
        ),
        child: label,
      );
    }

    return Semantics(
      button: true,
      label: 'Cuenta de $nombre',
      child: Material(
        color: AppColors.marino,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox.square(
            dimension: size,
            child: Center(child: label),
          ),
        ),
      ),
    );
  }
}
