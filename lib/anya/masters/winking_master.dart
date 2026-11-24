import '../face_params.dart';
import 'curious_master.dart';
import 'idle_master.dart';

/// **Winking** — same as [CuriousMaster], but a shorter **right** eye (trimmed top & bottom).
abstract final class WinkingMaster {
  static const double eyeGap = CuriousMaster.eyeGap;
  static const double eyeWidth = CuriousMaster.eyeWidth;
  static const double eyeHeight = CuriousMaster.eyeHeight;
  static const double eyesCenterYOffset = CuriousMaster.eyesCenterYOffset;

  /// Removed from each end of the right pill vs [IdleMaster.eyeHeight] (design units).
  static const double rightEyeTrimPerEnd = 30;
  static const double rightEyeHeight =
      IdleMaster.eyeHeight - (2 * rightEyeTrimPerEnd);

  static const double questionMarginPx = CuriousMaster.questionMarginPx;
  static const double questionFontSize = CuriousMaster.questionFontSize;
  static const double questionOpacity = CuriousMaster.questionOpacity;

  static const FaceParams params = FaceParams(
    eyeGap: eyeGap,
    eyeWidth: eyeWidth,
    eyeHeight: eyeHeight,
    bodyOffsetY: eyesCenterYOffset,
    rightEyeHeight: rightEyeHeight,
    question: questionOpacity,
    questionOnRightEye: 1,
    questionFontSize: questionFontSize,
  );
}