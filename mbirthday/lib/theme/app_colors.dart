import 'package:flutter/material.dart';

/// Colors ported 1:1 from DESIGN.md ("Cerulean Celebration").
class AppColors {
  AppColors._();

  static const surface = Color(0xFFFCF9F8);
  static const surfaceDim = Color(0xFFDCD9D9);
  static const surfaceBright = Color(0xFFFCF9F8);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFF6F3F2);
  static const surfaceContainer = Color(0xFFF0EDED);
  static const surfaceContainerHigh = Color(0xFFEAE7E7);
  static const surfaceContainerHighest = Color(0xFFE5E2E1);

  static const onSurface = Color(0xFF1C1B1B);
  static const onSurfaceVariant = Color(0xFF434653);
  static const inverseSurface = Color(0xFF313030);
  static const inverseOnSurface = Color(0xFFF3F0EF);

  static const outline = Color(0xFF737784);
  static const outlineVariant = Color(0xFFC3C6D5);

  static const primary = Color(0xFF00327D);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFF0047AB); // Royal Blue
  static const onPrimaryContainer = Color(0xFFA5BDFF);
  static const inversePrimary = Color(0xFFB1C5FF);

  static const secondary = Color(0xFF5D5E5F);
  static const onSecondary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFFE0DFDF);
  static const onSecondaryContainer = Color(0xFF626363);

  static const primaryFixed = Color(0xFFDAE2FF);
  static const primaryFixedDim = Color(0xFFB1C5FF);
  static const onPrimaryFixed = Color(0xFF001946);
  static const onPrimaryFixedVariant = Color(0xFF00419E);

  static const error = Color(0xFFBA1A1A);
  static const onError = Color(0xFFFFFFFF);

  static const background = Color(0xFFFCF9F8);
  static const onBackground = Color(0xFF1C1B1B);

  // Balloon palette used in the reveal celebration
  static const balloonColors = <Color>[
    primaryContainer,
    primaryFixedDim,
    primaryFixed,
    Color(0xFFFFFFFF),
    primary,
  ];
}
