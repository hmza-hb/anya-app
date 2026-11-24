import '../face_params.dart';
import 'idle_master.dart';

/// **Angry** — slanted heavy brows, rounded under-eye (reference sheet).
abstract final class AngryMaster {
  static const double eyeGap = IdleMaster.eyeGap;
  static const double eyeWidth = IdleMaster.eyeWidth;
  static const double eyeHeight = IdleMaster.eyeHeight;
  static const double eyesCenterYOffset = IdleMaster.eyesCenterYOffset;

  static const FaceParams params = FaceParams(
    eyeGap: eyeGap,
    eyeWidth: eyeWidth,
    eyeHeight: eyeHeight,
    bodyOffsetY: eyesCenterYOffset,
    angryEye: 1,
  );
}