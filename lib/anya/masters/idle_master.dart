import '../face_params.dart';
import 'design_scale.dart';

/// **Idle** — locked-in default face. Tune eye size, spacing, and vertical position here.
abstract final class IdleMaster {
  static const double designReferenceHeight = DesignScale.referenceHeight;

  static const double eyeGap = 230;
  static const double eyeWidth = 70;
  static const double eyeHeight = 130;
  static const double eyesCenterYOffset = 0;

  /// Runtime [FaceParams] for idle (also the morph default for unset fields).
  static const FaceParams params = FaceParams(
    eyeGap: eyeGap,
    eyeWidth: eyeWidth,
    eyeHeight: eyeHeight,
    bodyOffsetY: eyesCenterYOffset,
  );
}

/// Back-compat alias while older imports migrate.
typedef AnyaFaceMaster = IdleMaster;