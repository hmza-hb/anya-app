import 'dart:math' as math;

import '../face_params.dart';
import 'idle_master.dart';

/// **Excited** — glowing angle brackets `> <` morphing from idle pills ([chevronIn] 0→1).
abstract final class ExcitedMaster {
  static const double eyeGap = IdleMaster.eyeGap;
  static const double eyeWidth = IdleMaster.eyeWidth;
  static const double eyeHeight = IdleMaster.eyeHeight;
  static const double eyesCenterYOffset = IdleMaster.eyesCenterYOffset;

  /// Morph in/out duration (ms) — slightly longer for a bouncy feel.
  static const int morphDurationMs = 880;

  static const double bracketStrokeWidth = 5.5;

  /// Internal tip angle for both `>` and `<` (degrees).
  static const double bracketInternalAngleDeg = 30;
  /// Slightly wider angle at morph start, settles to [bracketInternalAngleDeg].
  static const double bracketInternalAngleDegMorph = 48;

  /// Tip offset toward the other eye (design px) — fixed so the vertex stays small.
  static const double bracketTipInsetDesign = 9;

  /// Caps open end so 30° fits inside the idle pill; raise for longer legs / wider brackets.
  static const double bracketMaxOpenDesign = IdleMaster.eyeWidth * 0.37;

  /// Leg length derived from 30° + [bracketMaxOpenDesign] + tip (both brackets use the same).
  static double get bracketLegHalfHeight {
    final halfRad = bracketInternalAngleDeg * math.pi / 180 / 2;
    return math.tan(halfRad) * (bracketMaxOpenDesign + bracketTipInsetDesign);
  }

  /// Open offset (design px) for a target tip angle: `θ = 2·atan(leg / (open + tip))`.
  static double openDesignFor({
    required double legHalfHeight,
    required double tipDesign,
    required double angleDeg,
  }) {
    final halfRad = angleDeg * math.pi / 180 / 2;
    final spread = legHalfHeight / math.tan(halfRad);
    return math.max(1, spread - tipDesign);
  }

  static double get bracketOpenWidthDesign => openDesignFor(
        legHalfHeight: bracketLegHalfHeight,
        tipDesign: bracketTipInsetDesign,
        angleDeg: bracketInternalAngleDeg,
      );

  static double get bracketOpenWidthDesignMorph => openDesignFor(
        legHalfHeight: bracketLegHalfHeight,
        tipDesign: bracketTipInsetDesign,
        angleDeg: bracketInternalAngleDegMorph,
      );

  /// Blink pinches brackets: leg shorten only (tip offset unchanged).
  static const double bracketBlinkLegSquash = 0.88;
  static const double bracketBlinkOpenPull = 0.12;
  static const double bracketBlinkTipPullDesign = 1.5;

  /// Squish pills briefly mid-morph (0–1 strength).
  static const double morphSquishStrength = 0.14;

  static const FaceParams params = FaceParams(
    eyeGap: eyeGap,
    eyeWidth: eyeWidth,
    eyeHeight: eyeHeight,
    bodyOffsetY: eyesCenterYOffset,
    chevronIn: 1,
  );
}