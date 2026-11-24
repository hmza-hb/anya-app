import '../face_params.dart';
import 'happy_master.dart';

/// **Proud** — happy ∩ eyes + glitter stars above the right eye (like curious `?`).
abstract final class ProudMaster {
  static const double eyeGap = HappyMaster.eyeGap;
  static const double eyeWidth = HappyMaster.eyeWidth;
  static const double eyeHeight = HappyMaster.eyeHeight;
  static const double eyesCenterYOffset = HappyMaster.eyesCenterYOffset;
  static const double archStrokeDesign = HappyMaster.archStrokeDesign;

  static const double sparkleMarginPx = 10;
  static const double sparkleSizeDesign = 26;
  static const double sparkleSmallSizeDesign = 16;
  /// Second star offset from the primary (design px, down-right).
  static const double sparkleSecondOffsetX = 18;
  static const double sparkleSecondOffsetY = 16;

  static const FaceParams params = FaceParams(
    eyeGap: eyeGap,
    eyeWidth: eyeWidth,
    eyeHeight: eyeHeight,
    bodyOffsetY: eyesCenterYOffset,
    archCurve: 1,
    archStrokeDesign: archStrokeDesign,
    sparkle: 1,
    sparkleOnRightEye: 1,
  );
}