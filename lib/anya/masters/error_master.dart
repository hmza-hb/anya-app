import '../face_params.dart';
import 'idle_master.dart';

/// **Error** — centered glowing ✕; [errorStroke] 0→1 draws both legs.
abstract final class ErrorMaster {
  static const double eyeGap = IdleMaster.eyeGap;
  static const double eyesCenterYOffset = IdleMaster.eyesCenterYOffset;

  static const double crossSizeDesign = IdleMaster.eyeHeight;
  static const double crossStrokeDesign = 6;

  static const int morphDurationMs = 720;

  static const FaceParams params = FaceParams(
    eyeGap: eyeGap,
    eyeWidth: 0,
    eyeHeight: 0,
    bodyOffsetY: eyesCenterYOffset,
    errorStroke: 1,
  );
}