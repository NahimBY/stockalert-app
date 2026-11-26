import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stockalert_app/config/theme/colors_theme.dart';
import 'package:stockalert_app/config/theme/fonts_theme.dart';

export 'package:stockalert_app/config/theme/colors_theme.dart';
export 'package:stockalert_app/config/theme/fonts_theme.dart';

const SystemUiOverlayStyle appSystemUiStyle = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.light,
  systemNavigationBarColor: Colors.transparent,
  systemNavigationBarIconBrightness: Brightness.dark,
  systemStatusBarContrastEnforced: false,
  systemNavigationBarContrastEnforced: false,
);

class AppTheme {
  final int selectedColor;

  AppTheme({this.selectedColor = 0})
    : assert(
        selectedColor >= 0 && selectedColor < AppColors.palette.length,
        'Colors must be between 0 and ${AppColors.palette.length - 1}',
      );

  ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: AppColors.palette[selectedColor],
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: GoogleFonts.interTextTheme().copyWith(
        headlineLarge: AppFonts.headline1,
        bodyLarge: AppFonts.bodyText1,
      ),
      appBarTheme: AppBarTheme(
        titleTextStyle: AppFonts.appBarTitle,
        iconTheme: const IconThemeData(color: AppColors.text, size: 26),
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: AppColors.background,
        systemOverlayStyle: appSystemUiStyle,
      ),
      iconTheme: const IconThemeData(color: AppColors.text, size: 25),
      navigationBarTheme: NavigationBarThemeData(
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
