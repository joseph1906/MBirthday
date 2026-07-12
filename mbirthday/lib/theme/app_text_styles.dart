import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Type scale ported from DESIGN.md.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle displayLg({Color color = AppColors.primary}) =>
      GoogleFonts.playfairDisplay(
        fontSize: 64,
        fontWeight: FontWeight.w700,
        height: 72 / 64,
        letterSpacing: -0.02 * 64,
        color: color,
      );

  static TextStyle displayLgMobile({Color color = AppColors.primary}) =>
      GoogleFonts.playfairDisplay(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        height: 48 / 40,
        letterSpacing: -0.01 * 40,
        color: color,
      );

  static TextStyle headlineMd({Color color = AppColors.primary}) =>
      GoogleFonts.playfairDisplay(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 40 / 32,
        color: color,
      );

  static TextStyle headlineSm({Color color = AppColors.primary}) =>
      GoogleFonts.playfairDisplay(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 32 / 24,
        color: color,
      );

  static TextStyle bodyLg({Color color = AppColors.onSurface}) =>
      GoogleFonts.sourceSans3(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 28 / 18,
        color: color,
      );

  static TextStyle bodyMd({Color color = AppColors.onSurface}) =>
      GoogleFonts.sourceSans3(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        color: color,
      );

  static TextStyle labelCaps({Color color = AppColors.onSurfaceVariant}) =>
      GoogleFonts.sourceSans3(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        height: 16 / 12,
        letterSpacing: 0.1 * 12,
        color: color,
      );
}
