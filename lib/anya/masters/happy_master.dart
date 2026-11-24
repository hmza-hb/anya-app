import '../face_params.dart';
import 'idle_master.dart';

/// **Happy** — thick semicircle ∩ arcs (half inverse-U, same spacing as idle).
abstract final class HappyMaster {
  static const double eyeGap = IdleMaster.eyeGap;
  static const double eyesCenterYOffset = IdleMaster.eyesCenterYOffset;

  /// Semicircle diameter (design px) — [eyeHeight] caps radius (≈ dip depth).
  static const double eyeWidth = 88;
  static const double eyeHeight = 44;
  /// Stroke thickness (design px).
  static const double archStrokeDesign = 14;

  static const FaceParams params = FaceParams(
    eyeGap: eyeGap,
    eyeWidth: eyeWidth,
    eyeHeight: eyeHeight,
    bodyOffsetY: eyesCenterYOffset,
    archCurve: 1,
    archStrokeDesign: archStrokeDesign,
  );
}