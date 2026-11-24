import '../face_params.dart';
import 'idle_master.dart';

/// **Processing** — eight glowing dots in a ring with a chasing opacity tail.
abstract final class ProcessingMaster {
  static const double eyesCenterYOffset = IdleMaster.eyesCenterYOffset;

  static const int dotCount = 8;
  static const double ringRadiusDesign = 54;
  static const double dotRadiusDesign = 6.5;
  /// Ring rotations per 4s ambient loop ([AnyaFaceController._ambientController]).
  static const double spinTurnsPerAmbientCycle = 2.5;

  static const FaceParams params = FaceParams(
    eyeGap: IdleMaster.eyeGap,
    eyeWidth: 0,
    eyeHeight: 0,
    bodyOffsetY: eyesCenterYOffset,
    processing: 1,
  );
}