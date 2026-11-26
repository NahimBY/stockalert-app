import 'package:flutter/material.dart';
import 'package:stockalert_app/config/theme/app_theme.dart';

class BuscadorCampo extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;

  const BuscadorCampo({
    super.key,
    required this.controller,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      style: AppFonts.bodyText1,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppFonts.bodyText3.copyWith(color: AppColors.softText),
        prefixIcon: const Icon(
          Icons.search_rounded,
          size: 20,
          color: AppColors.softText,
        ),
        filled: true,
        fillColor: AppColors.row,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.marino20.withValues(alpha: 0.6),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.marino, width: 1.5),
        ),
      ),
    );
  }
}
