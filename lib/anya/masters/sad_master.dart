import '../face_params.dart';
import 'happy_master.dart';
import 'idle_master.dart';

/// **Sad** — thick semicircle ∪ arcs (mirror of [HappyMaster], same spacing).
abstract final class SadMaster {
  static const double eyeGap = IdleMaster.eyeGap;
  static const double eyesCenterYOffset = IdleMaster.eyesCenterYOffset;

  static const double eyeWidth = HappyMaster.eyeWidth;
  static const double eyeHeight = HappyMaster.eyeHeight;
  static const double archStrokeDesign = HappyMaster.archStrokeDesign;

  static const FaceParams params = FaceParams(
    eyeGap: eyeGap,
    eyeWidth: eyeWidth,
    eyeHeight: eyeHeight,
    bodyOffsetY: eyesCenterYOffset,
    archCurve: -1,
    archStrokeDesign: archStrokeDesign,
  );
}