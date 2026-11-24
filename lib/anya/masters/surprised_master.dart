import 'package:flutter/material.dart' show Color;

import '../face_params.dart';
import 'curious_master.dart';
import 'eye_glow_style.dart';
import 'idle_master.dart';

/// **Surprised** — taller/wider eyes, `!` at **top-left** of left eye, `?` at **top-right** of right eye (10px margin).
abstract final class SurprisedMaster {
  static const double eyeGap = IdleMaster.eyeGap;
  static const double eyeWidth = IdleMaster.eyeWidth;
  static const double eyeHeight = IdleMaster.eyeHeight;

  /// Added to rendered pill width/height in **logical pixels** (both eyes).
  static const double eyeWidthExtraPx = 5;
  static const double eyeHeightExtraPx = 5;

  static const double exclaimMarginPx = CuriousMaster.questionMarginPx;
  static const double questionMarginPx = CuriousMaster.questionMarginPx;

  static const double exclaimFontSize = 58;
  static const double questionFontSize = CuriousMaster.questionFontSize;
  static const double markOpacity = 1;

  static const Color markCore = EyeGlowStyle.eyeCore;
  static const Color markGlow = EyeGlowStyle.eyeGlow;

  static const FaceParams params = FaceParams(
    eyeGap: eyeGap,
    eyeWidth: eyeWidth,
    eyeHeight: eyeHeight,
    eyeWidthExtraPx: eyeWidthExtraPx,
    eyeHeightExtraPx: eyeHeightExtraPx,
    question: markOpacity,
    questionOnRightEye: 1,
    questionFontSize: questionFontSize,
    exclaim: markOpacity,
    exclaimOnLeftEye: 1,
    exclaimFontSize: exclaimFontSize,
  );
}