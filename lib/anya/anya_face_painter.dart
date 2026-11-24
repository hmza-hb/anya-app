import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 'face_params.dart';
import 'masters/curious_master.dart';
import 'masters/accepted_master.dart';
import 'masters/excited_master.dart';
import 'masters/sad_master.dart';
import 'masters/proud_master.dart';
import 'masters/processing_master.dart';
import 'masters/error_master.dart';
import 'masters/in_love_master.dart';
import 'masters/surprised_master.dart';
import 'masters/design_scale.dart';
import 'masters/eye_glow_style.dart';

/// Draws Anya's OLED-style face from interpolated [FaceParams].
class AnyaFacePainter extends CustomPainter {
  AnyaFacePainter({
    required this.params,
    required this.processingAngle,
    required this.wavePhase,
    required this.dotPhase,
  });

  final FaceParams params;
  final double processingAngle;
  final double wavePhase;
  final double dotPhase;

  late Size _size;
  double get _s => _size.height / DesignScale.referenceHeight;

  double _px(double design) => design * _s;

  @override
  void paint(Canvas canvas, Size size) {
    _size = size;
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.black);

    final center = Offset(
      size.width / 2 + _px(params.bodyOffsetX),
      size.height / 2 + _px(params.bodyOffsetY) + _px(params.surpriseJump),
    );

    canvas.save();
    if (params.shake.abs() > 0.01) {
      canvas.translate(params.shake * _px(10) * math.sin(wavePhase * 8), 0);
    }
    if (params.nod.abs() > 0.01) {
      canvas.translate(0, params.nod * _px(8) * math.sin(wavePhase * 6));
    }

    final heartT = params.centerHeart.clamp(0.0, 1.0);
    final checkT = params.checkStroke.clamp(0.0, 1.0);
    final errorT = params.errorStroke.clamp(0.0, 1.0);
    final procT = params.processing.clamp(0.0, 1.0);
    final centerFade = [heartT, checkT, errorT, procT].reduce(math.max);
    if (heartT > 0.001) {
      _drawHeart(
        canvas,
        center,
        _px(InLoveMaster.heartSizeDesign),
        heartT,
      );
    }
    if (checkT > 0.001) {
      _drawAcceptedTick(canvas, center, checkT);
    }
    if (errorT > 0.001) {
      _drawErrorCross(canvas, center, errorT);
    }
    if (procT > 0.001) {
      _drawProcessing(canvas, center, procT);
    }
    if (procT <= 0.5) {
      if (params.showLink > 0.5) {
        _drawLink(canvas, center, size.shortestSide * 0.18);
      } else if (params.batteryLevel >= 0) {
        _drawBattery(canvas, center, size.shortestSide * 0.26);
      } else if (params.thinkingDots > 0.4 && params.heart < 0.5 && params.cross < 0.5) {
        _drawThinkingDots(canvas, center);
      }
    }
    if (centerFade < 0.999) {
      _drawEyes(canvas, center, size, opacity: 1 - centerFade);
    }

    _drawOverlays(canvas, center, size);
    canvas.restore();
  }

  void _drawOverlays(Canvas canvas, Offset center, Size size) {
    final gap = _px(params.eyeGap);
    final look = Offset(_px(params.lookX * 14), _px(params.lookY * 14));
    final extraW = params.eyeWidthExtraPx;
    final extraH = params.eyeHeightExtraPx;
    final leftCenter = center + Offset(-gap / 2, 0) + look;
    final rightCenter = center + Offset(gap / 2, 0) + look;
    final lW = _px(params.leftEyeWidth ?? params.eyeWidth) + extraW;
    final rW = _px(params.rightEyeWidth ?? params.eyeWidth) + extraW;
    final lH = _px(params.leftEyeHeight ?? params.eyeHeight) + extraH;
    final rH = _px(params.rightEyeHeight ?? params.eyeHeight) + extraH;

    if (params.exclaim > 0.05 && params.exclaimOnLeftEye > 0.5) {
      final topLeftLeftEye = leftCenter + Offset(-lW / 2, -lH / 2);
      _drawGlyphTopLeftOutside(
        canvas,
        corner: topLeftLeftEye,
        margin: SurprisedMaster.exclaimMarginPx,
        char: '!',
        fontSize: _px(params.exclaimFontSize),
        opacity: params.exclaim,
        coreColor: SurprisedMaster.markCore,
        glowColor: SurprisedMaster.markGlow,
      );
    }

    if (params.question > 0.05 && params.questionOnRightEye > 0.5) {
      final topRightRightEye = rightCenter + Offset(rW / 2, -rH / 2);
      final margin = params.exclaimOnLeftEye > 0.5
          ? SurprisedMaster.questionMarginPx
          : CuriousMaster.questionMarginPx;
      final core = params.exclaimOnLeftEye > 0.5
          ? SurprisedMaster.markCore
          : CuriousMaster.questionCore;
      final glow = params.exclaimOnLeftEye > 0.5
          ? SurprisedMaster.markGlow
          : CuriousMaster.questionGlow;
      _drawGlyphTopRightOutside(
        canvas,
        corner: topRightRightEye,
        margin: margin,
        char: '?',
        fontSize: _px(params.questionFontSize),
        opacity: params.question,
        coreColor: core,
        glowColor: glow,
      );
    } else if (params.question > 0.05) {
      _drawGlyph(
        canvas,
        center + Offset(0, -_px(128)),
        '?',
        _px(48),
        opacity: params.question,
      );
    }

    if (params.exclaim > 0.05 && params.exclaimOnLeftEye < 0.5) {
      _drawGlyph(
        canvas,
        center + Offset(0, -_px(136)),
        '!',
        _px(40),
        opacity: params.exclaim,
        repeat: 3,
      );
    }
    if (params.sparkle > 0.05 && params.sparkleOnRightEye > 0.5) {
      final topRightRightEye = rightCenter + Offset(rW / 2, -rH * 0.35);
      _drawSparklesTopRightOutside(
        canvas,
        corner: topRightRightEye,
        margin: _px(ProudMaster.sparkleMarginPx),
        amount: params.sparkle,
      );
    } else if (params.sparkle > 0.05) {
      _drawSparkle(
        canvas,
        center + Offset(_px(120), -_px(112)),
        params.sparkle,
      );
    }
  }

  void _drawEyes(Canvas canvas, Offset center, Size size, {double opacity = 1}) {
    if (opacity <= 0.01) return;
    final gap = _px(params.eyeGap);
    final look = Offset(_px(params.lookX * 14), _px(params.lookY * 14));
    final leftCenter = center + Offset(-gap / 2, 0) + look;
    final rightCenter = center + Offset(gap / 2, 0) + look;

    final extraW = params.eyeWidthExtraPx;
    final extraH = params.eyeHeightExtraPx;
    final lW = _px(params.leftEyeWidth ?? params.eyeWidth) + extraW;
    final rW = _px(params.rightEyeWidth ?? params.eyeWidth) + extraW;
    final lH = _px(params.leftEyeHeight ?? params.eyeHeight) + extraH;
    final rH = _px(params.rightEyeHeight ?? params.eyeHeight) + extraH;

    if (params.cross > 0.05) {
      _drawCrossEye(canvas, leftCenter, lW * 1.4, params.cross * opacity);
      _drawCrossEye(canvas, rightCenter, rW * 1.4, params.cross * opacity);
      return;
    }

    if (params.heart > 0.05) {
      _drawHeart(canvas, leftCenter, lW + 18, params.heart * opacity);
      _drawHeart(canvas, rightCenter, rW + 18, params.heart * opacity);
      return;
    }

    if (params.gazeArrow > 0.5) {
      _drawGazeArrow(canvas, leftCenter, lW, params.lookX, params.lookY);
      _drawGazeArrow(canvas, rightCenter, rW, params.lookX, params.lookY);
      return;
    }

    _drawSingleEye(
      canvas,
      leftCenter,
      lW,
      lH,
      params.leftSlant,
      wink: 0,
      isRightEye: false,
      opacity: opacity,
    );
    _drawSingleEye(
      canvas,
      rightCenter,
      rW,
      rH,
      params.rightSlant,
      wink: params.wink,
      isRightEye: true,
      opacity: opacity,
    );

    if (params.blush > 0.05) {
      _drawBlush(canvas, leftCenter, params.blush);
      _drawBlush(canvas, rightCenter, params.blush);
    }

    if (params.soundLeft > 0.05) {
      _drawWaves(canvas, leftCenter - Offset(lW + _px(22), 0), params.soundLeft, left: true);
    }
    if (params.soundRight > 0.05) {
      _drawWaves(canvas, rightCenter + Offset(rW + _px(22), 0), params.soundRight, left: false);
    }
  }

  void _drawSingleEye(
    Canvas canvas,
    Offset c,
    double w,
    double h,
    double slant, {
    required double wink,
    required bool isRightEye,
    double opacity = 1,
  }) {
    final close = params.blinkClose.clamp(0.0, 1.0);
    final narrow = params.narrowEyes.clamp(0.0, 1.0);

    if (params.angryEye > 0.02) {
      final amount = params.angryEye.clamp(0.0, 1.0);
      if (amount < 0.98) {
        _fillCapsule(canvas, c, w, h, opacity: (1 - amount) * opacity);
      }
      _fillGlowingPath(
        canvas,
        _angryEyePath(c, w, h, isRightEye: isRightEye, blink: close),
        opacity: amount * opacity,
      );
      return;
    }

    if (params.archCurve < -0.12) {
      if (params.archStrokeDesign > 0.01) {
        final rise =
            h * (1 - narrow * 0.25) * (1 - close * 0.85);
        _drawSadArch(
          canvas,
          c,
          w,
          rise,
          strokeDesign: params.archStrokeDesign,
          strength: params.archCurve.abs(),
          opacity: opacity,
        );
        return;
      }
      _strokePath(
        canvas,
        _archPath(c, w, params.archCurve, h),
        strokeWidth: _px(SadMaster.archStrokeDesign * 0.55),
        opacity: opacity,
      );
      return;
    }

    if (params.archCurve > 0.12) {
      if (params.archStrokeDesign > 0.01) {
        final rise =
            h * (1 - narrow * 0.25) * (1 - close * 0.85);
        _drawHappyArch(
          canvas,
          c,
          w,
          rise,
          strokeDesign: params.archStrokeDesign,
          strength: params.archCurve,
          opacity: opacity,
        );
        return;
      }
      h = lerpDouble(h, 4, close)!;
      w = lerpDouble(w, w * 1.1, close)!;
      h = lerpDouble(h, math.max(10, h * 0.35), narrow)!;
      w = lerpDouble(w, w * 1.35, narrow)!;
      _strokePath(
        canvas,
        _archPath(c, w, params.archCurve, h),
        strokeWidth: _px(4.2),
        opacity: opacity,
      );
      return;
    }

    h = lerpDouble(h, 4, close)!;
    w = lerpDouble(w, w * 1.1, close)!;
    h = lerpDouble(h, math.max(10, h * 0.35), narrow)!;
    w = lerpDouble(w, w * 1.35, narrow)!;

    if (wink > 0.5) {
      _strokePath(canvas, _chevronPath(c, w, h, inward: true, flip: true), opacity: opacity);
      return;
    }

    final chevronT = params.chevronIn.clamp(0.0, 1.0);
    if (chevronT > 0.001) {
      final pillFade = (1 - Curves.easeInOut.transform(chevronT)) * opacity;
      final chevGrow = Curves.easeOutBack.transform(chevronT).clamp(0.0, 1.0);
      final squeeze = math.sin(chevronT * math.pi) * ExcitedMaster.morphSquishStrength;
      final mw = w * (1 + squeeze);
      final mh = h * (1 - squeeze * 0.85);
      if (pillFade > 0.02) {
        _fillCapsule(canvas, c, mw, mh, opacity: pillFade);
      }
      _drawBracketEye(
        canvas,
        c,
        isRightEye: isRightEye,
        amount: chevGrow,
        morphProgress: chevronT,
        blinkClose: close,
        bounce: Curves.easeOutBack.transform(chevronT),
        opacity: opacity,
      );
      return;
    }

    if (slant.abs() > 0.1) {
      _strokePath(canvas, _slantPath(c, w, h, slant), opacity: opacity);
      return;
    }

    _fillCapsule(canvas, c, w, h, opacity: opacity);
  }

  void _drawBracketEye(
    Canvas canvas,
    Offset c, {
    required bool isRightEye,
    required double amount,
    required double morphProgress,
    double blinkClose = 0,
    double bounce = 1,
    double opacity = 1,
  }) {
    final grow = amount.clamp(0.0, 1.0);
    final blink = blinkClose.clamp(0.0, 1.0);
    final blinkEase = Curves.easeInOut.transform(blink);
    final legScale = 1 - blinkEase * ExcitedMaster.bracketBlinkLegSquash;
    // Legs grow in; tip stays fixed; open tracks leg so tip angle stays at target °.
    final tighten = Curves.easeOutCubic.transform(morphProgress.clamp(0.0, 1.0));
    final legDesign = ExcitedMaster.bracketLegHalfHeight * (0.55 + 0.45 * grow) * legScale;
    final angleDeg = lerpDouble(
      ExcitedMaster.bracketInternalAngleDegMorph,
      ExcitedMaster.bracketInternalAngleDeg,
      tighten,
    )!;
    var tipD = ExcitedMaster.bracketTipInsetDesign;
    var openD = ExcitedMaster.openDesignFor(
      legHalfHeight: legDesign,
      tipDesign: tipD,
      angleDeg: angleDeg,
    );
    openD = lerpDouble(
      openD,
      openD * (1 - ExcitedMaster.bracketBlinkOpenPull),
      blinkEase,
    )!;
    tipD = lerpDouble(
      tipD,
      tipD - ExcitedMaster.bracketBlinkTipPullDesign,
      blinkEase,
    )!;
    final legH = _px(legDesign);
    final path = _angleBracketPath(
      c,
      legH,
      openOffset: _px(openD),
      tipOffset: _px(tipD),
      isLessThan: isRightEye,
    );
    final strokePop = (0.75 + 0.25 * grow) * legScale;
    _strokePath(
      canvas,
      path,
      strokeWidth: _px(ExcitedMaster.bracketStrokeWidth) * strokePop,
      opacity: (grow * (1 - blink * 0.35) * opacity).clamp(0.0, 1.0),
    );
  }

  /// `>` (left) / `<` (right) with tips toward center.
  Path _angleBracketPath(
    Offset c,
    double legHalfHeight, {
    required double openOffset,
    required double tipOffset,
    required bool isLessThan,
  }) {
    final path = Path();
    final open = openOffset;
    final tip = tipOffset;
    if (isLessThan) {
      path
        ..moveTo(c.dx + open, c.dy - legHalfHeight)
        ..lineTo(c.dx - tip, c.dy)
        ..lineTo(c.dx + open, c.dy + legHalfHeight);
    } else {
      path
        ..moveTo(c.dx - open, c.dy - legHalfHeight)
        ..lineTo(c.dx + tip, c.dy)
        ..lineTo(c.dx - open, c.dy + legHalfHeight);
    }
    return path;
  }

  /// Slanted brow + rounded base; `lx` is toward the other eye for both sides.
  Path _angryEyePath(
    Offset c,
    double w,
    double h, {
    required bool isRightEye,
    double blink = 0,
  }) {
    final shrink = 1 - blink.clamp(0.0, 1.0) * 0.94;
    Offset p(double lx, double ly) {
      final x = isRightEye ? c.dx - lx : c.dx + lx;
      return Offset(x, c.dy + ly * shrink);
    }

    final o0 = p(-w * 0.495, -h * 0.42);
    final o1 = p(w * 0.43, -h * 0.11);
    final o2 = p(w * 0.46, h * 0.06);
    final o3 = p(w * 0.32, h * 0.28);
    final o4 = p(w * 0.05, h * 0.46);
    final o5 = p(-w * 0.44, h * 0.38);
    final o6 = p(-w * 0.50, h * 0.04);
    return Path()
      ..moveTo(o0.dx, o0.dy)
      ..lineTo(o1.dx, o1.dy)
      ..quadraticBezierTo(o2.dx, o2.dy, o3.dx, o3.dy)
      ..quadraticBezierTo(o4.dx, o4.dy, o5.dx, o5.dy)
      ..quadraticBezierTo(o6.dx, o6.dy, o0.dx, o0.dy)
      ..close();
  }

  void _fillGlowingPath(Canvas canvas, Path path, {double opacity = 1}) {
    if (opacity <= 0.01) return;
    final bounds = path.getBounds();
    final w = bounds.width;
    final h = bounds.height;

    for (final blur in [18.0, 12.0, 6.0]) {
      canvas.drawPath(
        path,
        Paint()
          ..color = EyeGlowStyle.eyeBackGlow
              .withValues(alpha: EyeGlowStyle.backGlowAlpha * 0.9 * opacity)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur),
      );
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = EyeGlowStyle.eyeHalo.withValues(alpha: EyeGlowStyle.glowHaloAlpha * opacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, w * 0.35),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = EyeGlowStyle.eyeGlow.withValues(alpha: EyeGlowStyle.glowMidAlpha * opacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, w * 0.18),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = EyeGlowStyle.eyeCore.withValues(alpha: opacity)
        ..style = PaintingStyle.fill,
    );
  }

  void _fillCapsule(
    Canvas canvas,
    Offset c,
    double w,
    double h, {
    double opacity = 1,
  }) {
    if (opacity <= 0.01) return;
    final radius = math.min(w, h) / 2;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: c, width: w, height: h),
      Radius.circular(radius),
    );

    final spread = w * EyeGlowStyle.backGlowSpreadFactor;
    final backRrect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: c,
        width: w + spread * 2,
        height: h + spread * 2,
      ),
      Radius.circular(radius + spread),
    );
    canvas.drawRRect(
      backRrect,
      Paint()
        ..color = EyeGlowStyle.eyeBackGlow
            .withValues(alpha: EyeGlowStyle.backGlowAlpha * opacity)
        ..maskFilter = MaskFilter.blur(
          BlurStyle.normal,
          w * EyeGlowStyle.backGlowBlurFactor,
        ),
    );

    canvas.drawRRect(
      rrect,
      Paint()
        ..color = EyeGlowStyle.eyeHalo
            .withValues(alpha: EyeGlowStyle.glowHaloAlpha * opacity)
        ..maskFilter =
            MaskFilter.blur(BlurStyle.normal, w * EyeGlowStyle.glowHaloBlurFactor),
    );
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = EyeGlowStyle.eyeGlow
            .withValues(alpha: EyeGlowStyle.glowMidAlpha * opacity)
        ..maskFilter =
            MaskFilter.blur(BlurStyle.normal, w * EyeGlowStyle.glowMidBlurFactor),
    );
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = EyeGlowStyle.eyeGlow
            .withValues(alpha: EyeGlowStyle.coreLavenderWashAlpha * opacity)
        ..maskFilter = MaskFilter.blur(
          BlurStyle.normal,
          w * EyeGlowStyle.coreLavenderWashBlurFactor,
        ),
    );
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = EyeGlowStyle.eyeCore.withValues(alpha: opacity)
        ..style = PaintingStyle.fill,
    );
  }

  /// Happy eye: bottom semicircle ∩ (smile arch).
  Path _happyArchPath(Offset c, double span, double rise, double strength) {
    final s = strength.clamp(0.2, 1.0);
    final radius = math.min(span * 0.5, rise * s);
    final cy = c.dy + radius * 0.08 * s;
    final rect = Rect.fromCircle(center: Offset(c.dx, cy), radius: radius);
    return Path()..addArc(rect, math.pi, math.pi);
  }

  /// Sad eye: top semicircle ∪ (droopy arch, mirror of happy).
  Path _sadArchPath(Offset c, double span, double rise, double strength) {
    final s = strength.clamp(0.2, 1.0);
    final radius = math.min(span * 0.5, rise * s);
    final cy = c.dy - radius * 0.08 * s;
    final rect = Rect.fromCircle(center: Offset(c.dx, cy), radius: radius);
    return Path()..addArc(rect, 0, math.pi);
  }

  void _drawHappyArch(
    Canvas canvas,
    Offset c,
    double span,
    double rise, {
    required double strokeDesign,
    required double strength,
    double opacity = 1,
  }) {
    final path = _happyArchPath(c, span, rise, strength);
    final stroke = _px(strokeDesign);
    _strokePath(
      canvas,
      path,
      strokeWidth: stroke * 1.12,
      opacity: 0.42 * opacity,
    );
    _strokePath(
      canvas,
      path,
      strokeWidth: stroke,
      opacity: opacity,
    );
  }

  void _drawSadArch(
    Canvas canvas,
    Offset c,
    double span,
    double rise, {
    required double strokeDesign,
    required double strength,
    double opacity = 1,
  }) {
    final path = _sadArchPath(c, span, rise, strength);
    final stroke = _px(strokeDesign);
    _strokePath(
      canvas,
      path,
      strokeWidth: stroke * 1.12,
      opacity: 0.42 * opacity,
    );
    _strokePath(
      canvas,
      path,
      strokeWidth: stroke,
      opacity: opacity,
    );
  }

  Path _archPath(Offset c, double w, double curve, double h) {
    final path = Path();
    final sweep = math.pi * 0.95;
    final start = curve > 0 ? math.pi * 1.05 : math.pi * 0.05;
    final rect = Rect.fromCenter(
      center: c,
      width: w * 2.2,
      height: h * 1.6 * curve.abs().clamp(0.4, 1),
    );
    path.addArc(rect, start, sweep * (curve > 0 ? -1 : 1));
    return path;
  }

  Path _slantPath(Offset c, double w, double h, double slant) {
    final path = Path();
    final dx = w * 0.55;
    final dy = h * 0.45;
    final tilt = slant * w * 0.35;
    path.moveTo(c.dx - dx, c.dy - dy + tilt);
    path.quadraticBezierTo(c.dx, c.dy + dy, c.dx + dx, c.dy - dy - tilt);
    return path;
  }

  Path _chevronPath(
    Offset c,
    double w,
    double h, {
    required bool inward,
    bool flip = false,
  }) {
    final path = Path();
    final dir = (inward ? 1 : -1) * (flip ? -1 : 1);
    path.moveTo(c.dx - dir * w * 0.5, c.dy - h * 0.4);
    path.lineTo(c.dx + dir * w * 0.15, c.dy);
    path.lineTo(c.dx - dir * w * 0.5, c.dy + h * 0.4);
    return path;
  }

  void _drawGazeArrow(Canvas canvas, Offset c, double w, double lx, double ly) {
    final path = Path();
    final tip = c + Offset(lx * w * 0.35, ly * w * 0.35);
    if (ly < -0.5) {
      path.moveTo(tip.dx, tip.dy - w * 0.35);
      path.lineTo(tip.dx - w * 0.3, tip.dy);
      path.lineTo(tip.dx + w * 0.3, tip.dy);
    } else if (ly > 0.5) {
      path.moveTo(tip.dx, tip.dy + w * 0.35);
      path.lineTo(tip.dx - w * 0.3, tip.dy);
      path.lineTo(tip.dx + w * 0.3, tip.dy);
    } else if (lx < -0.5) {
      path.moveTo(tip.dx - w * 0.35, tip.dy);
      path.lineTo(tip.dx, tip.dy - w * 0.3);
      path.lineTo(tip.dx, tip.dy + w * 0.3);
    } else {
      path.moveTo(tip.dx + w * 0.35, tip.dy);
      path.lineTo(tip.dx, tip.dy - w * 0.3);
      path.lineTo(tip.dx, tip.dy + w * 0.3);
    }
    _strokePath(canvas, path, style: PaintingStyle.fill);
  }

  void _drawCrossEye(Canvas canvas, Offset c, double size, double amount) {
    final path = Path();
    final h = size * 0.5 * amount;
    path.moveTo(c.dx - h, c.dy - h);
    path.lineTo(c.dx + h, c.dy + h);
    path.moveTo(c.dx + h, c.dy - h);
    path.lineTo(c.dx - h, c.dy + h);
    _strokePath(canvas, path, strokeWidth: 4);
  }

  Path _acceptedTickPath(Offset c) {
    final h = _px(AcceptedMaster.tickHeightDesign);
    final w = h * AcceptedMaster.tickWidthFactor;
    final start = c + Offset(-w * 0.38, h * 0.04);
    final knee = c + Offset(-w * 0.08, h * 0.34);
    final end = c + Offset(w * 0.4, -h * 0.38);
    return Path()
      ..moveTo(start.dx, start.dy)
      ..lineTo(knee.dx, knee.dy)
      ..lineTo(end.dx, end.dy);
  }

  void _drawAcceptedTick(Canvas canvas, Offset c, double strokeT) {
    final t = Curves.easeOutCubic.transform(strokeT.clamp(0.0, 1.0));
    if (t <= 0.001) return;
    final metrics = _acceptedTickPath(c).computeMetrics();
    for (final m in metrics) {
      final path = m.extractPath(0, m.length * t);
      _strokePath(
        canvas,
        path,
        strokeWidth: _px(AcceptedMaster.tickStrokeDesign),
        opacity: (0.35 + 0.65 * t).clamp(0.0, 1.0),
      );
    }
  }

  Path _errorCrossPath(Offset c) {
    final half = _px(ErrorMaster.crossSizeDesign) * 0.42;
    return Path()
      ..moveTo(c.dx - half, c.dy - half)
      ..lineTo(c.dx + half, c.dy + half)
      ..moveTo(c.dx + half, c.dy - half)
      ..lineTo(c.dx - half, c.dy + half);
  }

  void _drawErrorCross(Canvas canvas, Offset c, double strokeT) {
    final t = Curves.easeOutCubic.transform(strokeT.clamp(0.0, 1.0));
    if (t <= 0.001) return;
    final metrics = _errorCrossPath(c).computeMetrics();
    for (final m in metrics) {
      final path = m.extractPath(0, m.length * t);
      _strokePath(
        canvas,
        path,
        strokeWidth: _px(ErrorMaster.crossStrokeDesign),
        opacity: (0.35 + 0.65 * t).clamp(0.0, 1.0),
      );
    }
  }

  void _drawHeart(Canvas canvas, Offset c, double size, double amount) {
    final path = Path();
    final w = size * amount;
    final h = size * 0.9 * amount;
    path.moveTo(c.dx, c.dy + h * 0.35);
    path.cubicTo(
      c.dx - w * 0.55,
      c.dy - h * 0.15,
      c.dx - w * 0.2,
      c.dy - h * 0.55,
      c.dx,
      c.dy - h * 0.15,
    );
    path.cubicTo(
      c.dx + w * 0.2,
      c.dy - h * 0.55,
      c.dx + w * 0.55,
      c.dy - h * 0.15,
      c.dx,
      c.dy + h * 0.35,
    );
    _strokePath(canvas, path, style: PaintingStyle.fill);
  }

  void _drawBlush(Canvas canvas, Offset c, double amount) {
    final paint = _glowPaint(strokeWidth: 2.5, opacity: 0.5 * amount);
    for (var i = -1; i <= 1; i++) {
      final path = Path()
        ..moveTo(c.dx - 18, c.dy + 22 + i * 4)
        ..lineTo(c.dx - 8, c.dy + 18 + i * 4);
      canvas.drawPath(path, paint);
    }
  }

  void _drawWaves(Canvas canvas, Offset c, double amount, {required bool left}) {
    final lines = params.soundBoost > 0.5 ? 3 : 2;
    final paint = _glowPaint(strokeWidth: 2.8);
    for (var i = 0; i < lines; i++) {
      final phase = wavePhase + i * 0.4;
      final amp = 6 + i * 4 + math.sin(phase * math.pi * 2) * 2;
      final path = Path();
      final dir = left ? -1.0 : 1.0;
      path.moveTo(c.dx, c.dy - 18);
      path.quadraticBezierTo(
        c.dx + dir * amp * amount,
        c.dy,
        c.dx,
        c.dy + 18,
      );
      canvas.drawPath(path, paint..color = paint.color.withValues(alpha: 0.4 + 0.25 * amount));
    }
  }

  void _drawProcessing(Canvas canvas, Offset c, double opacity) {
    final count = ProcessingMaster.dotCount;
    final ringR = _px(ProcessingMaster.ringRadiusDesign);
    final dotR = _px(ProcessingMaster.dotRadiusDesign);
    final head = processingAngle / (2 * math.pi) * count;

    for (var i = 0; i < count; i++) {
      final ang = -math.pi / 2 + i * 2 * math.pi / count;
      final p = c + Offset(math.cos(ang), math.sin(ang)) * ringR;

      var trail = (i - head) % count;
      if (trail < 0) trail += count;
      final alpha = (math.pow(0.68, trail) * 0.82 + 0.14).toDouble() * opacity;

      final glow = Paint()
        ..color = EyeGlowStyle.eyeGlow.withValues(alpha: 0.35 * alpha)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, dotR * 1.6);
      canvas.drawCircle(p, dotR * 1.65, glow);
      canvas.drawCircle(
        p,
        dotR,
        Paint()
          ..color = EyeGlowStyle.eyeCore.withValues(alpha: alpha)
          ..style = PaintingStyle.fill,
      );
    }
  }

  void _drawLink(Canvas canvas, Offset c, double size) {
    final paint = _glowPaint(strokeWidth: 3.5);
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: c + const Offset(-14, 0), width: size, height: size * 0.55),
          const Radius.circular(6),
        ),
      )
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: c + Offset(size * 0.35, 0), width: size, height: size * 0.55),
          const Radius.circular(6),
        ),
      );
    canvas.drawPath(path, paint..style = PaintingStyle.stroke);
    canvas.drawCircle(c + const Offset(-2, 0), 4, paint..style = PaintingStyle.fill);
  }

  void _drawBattery(Canvas canvas, Offset c, double size) {
    final frame = RRect.fromRectAndRadius(
      Rect.fromCenter(center: c, width: size * 1.3, height: size * 0.65),
      const Radius.circular(8),
    );
    _strokeRRect(canvas, frame, strokeWidth: 3);
    final cap = RRect.fromRectAndRadius(
      Rect.fromCenter(center: c + Offset(size * 0.72, 0), width: size * 0.12, height: size * 0.28),
      const Radius.circular(3),
    );
    _strokeRRect(canvas, cap, strokeWidth: 2.5);

    final level = params.batteryLevel.clamp(0, 1);
    final fillColor = level < 0.2 ? const Color(0xFFFF5577) : EyeGlowStyle.eyeCore;
    final fill = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        c.dx - size * 0.58,
        c.dy - size * 0.22,
        size * 1.1 * level,
        size * 0.44,
      ),
      const Radius.circular(5),
    );
    canvas.drawRRect(fill, _glowPaint(opacity: 0.9)..color = fillColor..style = PaintingStyle.fill);

    if (level > 0.35) {
      _drawGlyph(canvas, c, '⚡', size * 0.35, opacity: 0.95);
    }
  }

  void _drawThinkingDots(Canvas canvas, Offset center) {
    for (var i = 0; i < 3; i++) {
      final bounce = math.sin(dotPhase * math.pi * 2 + i * 0.8) * 4;
      final p = center + Offset((i - 1) * 22, bounce);
      canvas.drawCircle(p, 5, _glowPaint(opacity: 0.9)..style = PaintingStyle.fill);
    }
  }

  Path _fourPointStarPath(Offset c, double radius) {
    final path = Path();
    for (var i = 0; i < 8; i++) {
      final r = i.isEven ? radius : radius * 0.34;
      final ang = -math.pi / 2 + i * math.pi / 4;
      final p = Offset(c.dx + math.cos(ang) * r, c.dy + math.sin(ang) * r);
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    path.close();
    return path;
  }

  void _drawGlitterStar(Canvas canvas, Offset c, double radius, {double opacity = 1}) {
    final path = _fourPointStarPath(c, radius);
    _strokePath(canvas, path, strokeWidth: radius * 0.08, opacity: 0.4 * opacity);
    _fillGlowingPath(canvas, path, opacity: opacity);
  }

  void _drawSparklesTopRightOutside(
    Canvas canvas, {
    required Offset corner,
    required double margin,
    required double amount,
  }) {
    final primary = corner + Offset(margin + _px(ProudMaster.sparkleSizeDesign) * 0.5, -margin);
    final secondary = primary +
        Offset(
          _px(ProudMaster.sparkleSecondOffsetX),
          _px(ProudMaster.sparkleSecondOffsetY),
        );
    _drawGlitterStar(
      canvas,
      primary,
      _px(ProudMaster.sparkleSizeDesign) * 0.5,
      opacity: amount,
    );
    _drawGlitterStar(
      canvas,
      secondary,
      _px(ProudMaster.sparkleSmallSizeDesign) * 0.5,
      opacity: amount * 0.92,
    );
  }

  void _drawSparkle(Canvas canvas, Offset c, double amount) {
    _drawGlitterStar(canvas, c, _px(10), opacity: amount);
  }

  void _drawGlyphTopRightOutside(
    Canvas canvas, {
    required Offset corner,
    required double margin,
    required String char,
    required double fontSize,
    double opacity = 1,
    Color? coreColor,
    Color? glowColor,
  }) {
    final core = coreColor ?? EyeGlowStyle.eyeCore;
    final glow = glowColor ?? EyeGlowStyle.eyeGlow;
    final tp = TextPainter(
      text: TextSpan(
        text: char,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w300,
          color: core.withValues(alpha: opacity),
          shadows: [
            Shadow(color: glow.withValues(alpha: 0.75), blurRadius: 14),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final center = corner +
        Offset(margin + tp.width / 2, -(margin + tp.height / 2));
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  void _drawGlyphTopLeftOutside(
    Canvas canvas, {
    required Offset corner,
    required double margin,
    required String char,
    required double fontSize,
    double opacity = 1,
    Color? coreColor,
    Color? glowColor,
  }) {
    final core = coreColor ?? EyeGlowStyle.eyeCore;
    final glow = glowColor ?? EyeGlowStyle.eyeGlow;
    final tp = TextPainter(
      text: TextSpan(
        text: char,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w300,
          color: core.withValues(alpha: opacity),
          shadows: [
            Shadow(color: glow.withValues(alpha: 0.75), blurRadius: 14),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final center = corner +
        Offset(-(margin + tp.width / 2), -(margin + tp.height / 2));
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  void _drawGlyph(
    Canvas canvas,
    Offset c,
    String char,
    double size, {
    double opacity = 1,
    int repeat = 1,
    Color? coreColor,
    Color? glowColor,
    FontWeight fontWeight = FontWeight.w300,
  }) {
    final core = coreColor ?? EyeGlowStyle.eyeCore;
    final glow = glowColor ?? EyeGlowStyle.eyeGlow;
    final tp = TextPainter(
      text: TextSpan(
        text: repeat > 1 ? List.filled(repeat, char).join() : char,
        style: TextStyle(
          fontSize: size,
          fontWeight: fontWeight,
          color: core.withValues(alpha: opacity),
          shadows: [
            Shadow(color: glow.withValues(alpha: 0.75), blurRadius: 14),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, c - Offset(tp.width / 2, tp.height / 2));
  }

  void _strokeRRect(Canvas canvas, RRect r, {double strokeWidth = 3.8}) {
    _strokePath(canvas, Path()..addRRect(r), strokeWidth: strokeWidth);
  }

  void _strokePath(
    Canvas canvas,
    Path path, {
    double strokeWidth = 3.8,
    PaintingStyle style = PaintingStyle.stroke,
    double opacity = 1,
  }) {
    for (var blur = 16.0; blur >= 4; blur -= 4) {
      canvas.drawPath(
        path,
        Paint()
          ..color = EyeGlowStyle.eyeGlow.withValues(alpha: 0.12 * opacity)
          ..style = style
          ..strokeWidth = strokeWidth + blur * 0.15
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur),
      );
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = style == PaintingStyle.fill
            ? EyeGlowStyle.eyeCore.withValues(alpha: 0.95 * opacity)
            : EyeGlowStyle.eyeCore.withValues(alpha: opacity)
        ..style = style
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  Paint _glowPaint({double strokeWidth = 3, double opacity = 1}) {
    return Paint()
      ..color = EyeGlowStyle.eyeCore.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
  }

  @override
  bool shouldRepaint(covariant AnyaFacePainter oldDelegate) =>
      oldDelegate.params != params ||
      oldDelegate.processingAngle != processingAngle ||
      oldDelegate.wavePhase != wavePhase ||
      oldDelegate.dotPhase != dotPhase;
}