import 'package:flutter/material.dart' show Color;

import '../face_params.dart';
import 'eye_glow_style.dart';
import 'idle_master.dart';

/// **Curious** — same eyes as [IdleMaster], `?` at **top-right** of the **right** eye.
abstract final class CuriousMaster {
  static const double eyeGap = IdleMaster.eyeGap;
  static const double eyeWidth = IdleMaster.eyeWidth;
  static const double eyeHeight = IdleMaster.eyeHeight;
  static const double eyesCenterYOffset = IdleMaster.eyesCenterYOffset;

  /// Gap between the eye corner and the question mark (logical pixels).
  static const double questionMarginPx = 10;
  static const double questionFontSize = 58;
  static const double questionOpacity = 1;

  static const Color questionCore = EyeGlowStyle.eyeCore;
  static const Color questionGlow = EyeGlowStyle.eyeGlow;

  static const FaceParams params = FaceParams(
    eyeGap: eyeGap,
    eyeWidth: eyeWidth,
    eyeHeight: eyeHeight,
    bodyOffsetY: eyesCenterYOffset,
    question: questionOpacity,
    questionOnRightEye: 1,
    questionFontSize: questionFontSize,
  );
}