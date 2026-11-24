import '../face_params.dart';
import 'idle_master.dart';

/// **Accepted** — centered glowing checkmark; [checkStroke] 0→1 draws the tick.
abstract final class AcceptedMaster {
  static const double eyeGap = IdleMaster.eyeGap;
  static const double eyesCenterYOffset = IdleMaster.eyesCenterYOffset;

  /// Tick height in design px (same scale as idle pills / in-love heart).
  static const double tickHeightDesign = IdleMaster.eyeHeight;
  static const double tickWidthFactor = 0.92;
  static const double tickStrokeDesign = 6;

  /// Morph duration — time to complete the stroke from 0→1.
  static const int morphDurationMs = 720;

  static const FaceParams params = FaceParams(
    eyeGap: eyeGap,
    eyeWidth: 0,
    eyeHeight: 0,
    bodyOffsetY: eyesCenterYOffset,
    checkStroke: 1,
  );
}