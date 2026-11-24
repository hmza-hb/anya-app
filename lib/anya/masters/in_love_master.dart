import '../face_params.dart';
import 'idle_master.dart';

/// **In love** — one glowing heart centered where the eyes sit (no separate pupils).
abstract final class InLoveMaster {
  static const double eyeGap = IdleMaster.eyeGap;
  static const double eyesCenterYOffset = IdleMaster.eyesCenterYOffset;

  /// Heart width in design px — matches idle [IdleMaster.eyeHeight] (same scale as the pills).
  static const double heartSizeDesign = IdleMaster.eyeHeight;

  static const FaceParams params = FaceParams(
    eyeGap: eyeGap,
    eyeWidth: 0,
    eyeHeight: 0,
    bodyOffsetY: eyesCenterYOffset,
    centerHeart: 1,
  );
}