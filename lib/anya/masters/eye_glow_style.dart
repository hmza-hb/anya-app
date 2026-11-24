import 'package:flutter/material.dart' show Color;

/// Lavender pill colors + glow strengths (shared by idle and other pill-based looks).
abstract final class EyeGlowStyle {
  static const Color eyeCore = Color(0xFFF2EAFF);
  static const Color eyeGlow = Color(0xFFD8B4FF);
  static const Color eyeHalo = Color(0xFFB88AF0);
  static const Color eyeBackGlow = Color(0xFF8B5FD4);

  static const double backGlowAlpha = 0.12;
  static const double backGlowBlurFactor = 2.1;
  static const double backGlowSpreadFactor = 0.22;
  static const double glowHaloAlpha = 0.16;
  static const double glowHaloBlurFactor = 0.85;
  static const double glowMidAlpha = 0.34;
  static const double glowMidBlurFactor = 0.42;
  static const double coreLavenderWashAlpha = 0.2;
  static const double coreLavenderWashBlurFactor = 0.14;
}