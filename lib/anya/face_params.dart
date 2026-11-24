import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';

import 'masters/idle_master.dart';

/// Numeric description of the face — all expressions interpolate through these.
@immutable
class FaceParams {
  const FaceParams({
    this.eyeGap = IdleMaster.eyeGap,
    this.eyeWidth = IdleMaster.eyeWidth,
    this.eyeHeight = IdleMaster.eyeHeight,
    this.eyeWidthExtraPx = 0,
    this.eyeHeightExtraPx = 0,
    this.leftEyeWidth,
    this.rightEyeWidth,
    this.leftEyeHeight,
    this.rightEyeHeight,
    this.archCurve = 0,
    this.archStrokeDesign = 0,
    this.leftSlant = 0,
    this.rightSlant = 0,
    this.chevronIn = 0,
    this.heart = 0,
    this.cross = 0,
    this.wink = 0,
    this.blinkClose = 0,
    this.lookX = 0,
    this.lookY = 0,
    this.gazeArrow = 0,
    this.soundLeft = 0,
    this.soundRight = 0,
    this.soundBoost = 0,
    this.blush = 0,
    this.sparkle = 0,
    this.sparkleOnRightEye = 0,
    this.question = 0,
    this.questionOnRightEye = 0,
    this.questionFontSize = 48,
    this.exclaim = 0,
    this.exclaimOnLeftEye = 0,
    this.exclaimFontSize = 48,
    this.thinkingDots = 0,
    this.narrowEyes = 0,
    this.centerHeart = 0,
    this.checkStroke = 0,
    this.errorStroke = 0,
    this.bodyOffsetX = 0,
    this.bodyOffsetY = 0,
    this.processing = 0,
    this.showLink = 0,
    this.batteryLevel = -1,
    this.shake = 0,
    this.nod = 0,
    this.surpriseJump = 0,
    this.angryEye = 0,
  });

  final double eyeGap;
  final double eyeWidth;
  final double eyeHeight;
  final double eyeWidthExtraPx;
  final double eyeHeightExtraPx;
  final double? leftEyeWidth;
  final double? rightEyeWidth;
  final double? leftEyeHeight;
  final double? rightEyeHeight;

  /// −1 sad (∩), 0 pill, +1 happy (∪)
  final double archCurve;
  /// Thick stroked happy arcs (design px); 0 = legacy thin arc.
  final double archStrokeDesign;
  final double leftSlant;
  final double rightSlant;
  final double chevronIn;
  final double heart;
  final double cross;
  final double wink;
  final double blinkClose;
  final double lookX;
  final double lookY;
  final double gazeArrow;
  final double soundLeft;
  final double soundRight;
  final double soundBoost;
  final double blush;
  final double sparkle;
  /// 1 = glitter stars above top-right of right eye (see [ProudMaster]).
  final double sparkleOnRightEye;
  final double question;
  /// 1 = `?` at top-right of right eye ([questionFontSize], margin from master).
  final double questionOnRightEye;
  final double questionFontSize;
  final double exclaim;
  /// `!` at top-left of left eye with margin (see [SurprisedMaster]).
  final double exclaimOnLeftEye;
  final double exclaimFontSize;
  final double thinkingDots;
  final double narrowEyes;
  final double centerHeart;
  /// 0→1 progress along the accepted checkmark path (stroke draw).
  final double checkStroke;
  /// 0→1 progress drawing the centered error ✕ (stroke animation).
  final double errorStroke;
  final double bodyOffsetX;
  final double bodyOffsetY;
  final double processing;
  final double showLink;
  /// −1 hidden, 0–1 charge level (low battery uses ~0.15)
  final double batteryLevel;
  final double shake;
  final double nod;
  final double surpriseJump;
  /// 1 = filled angular angry eye shape (see [AngryMaster]).
  final double angryEye;

  static FaceParams lerp(FaceParams a, FaceParams b, double t) {
    double l(double x, double y) => lerpDouble(x, y, t)!;
    double? ln(double? x, double? y) {
      if (x == null && y == null) return null;
      return l(x ?? y!, y ?? x!);
    }

    return FaceParams(
      eyeGap: l(a.eyeGap, b.eyeGap),
      eyeWidth: l(a.eyeWidth, b.eyeWidth),
      eyeHeight: l(a.eyeHeight, b.eyeHeight),
      eyeWidthExtraPx: l(a.eyeWidthExtraPx, b.eyeWidthExtraPx),
      eyeHeightExtraPx: l(a.eyeHeightExtraPx, b.eyeHeightExtraPx),
      leftEyeWidth: ln(a.leftEyeWidth, b.leftEyeWidth),
      rightEyeWidth: ln(a.rightEyeWidth, b.rightEyeWidth),
      leftEyeHeight: ln(a.leftEyeHeight, b.leftEyeHeight),
      rightEyeHeight: ln(a.rightEyeHeight, b.rightEyeHeight),
      archCurve: l(a.archCurve, b.archCurve),
      archStrokeDesign: l(a.archStrokeDesign, b.archStrokeDesign),
      leftSlant: l(a.leftSlant, b.leftSlant),
      rightSlant: l(a.rightSlant, b.rightSlant),
      chevronIn: l(a.chevronIn, b.chevronIn),
      heart: l(a.heart, b.heart),
      cross: l(a.cross, b.cross),
      wink: l(a.wink, b.wink),
      blinkClose: l(a.blinkClose, b.blinkClose),
      lookX: l(a.lookX, b.lookX),
      lookY: l(a.lookY, b.lookY),
      gazeArrow: l(a.gazeArrow, b.gazeArrow),
      soundLeft: l(a.soundLeft, b.soundLeft),
      soundRight: l(a.soundRight, b.soundRight),
      soundBoost: l(a.soundBoost, b.soundBoost),
      blush: l(a.blush, b.blush),
      sparkle: l(a.sparkle, b.sparkle),
      sparkleOnRightEye: l(a.sparkleOnRightEye, b.sparkleOnRightEye),
      question: l(a.question, b.question),
      questionOnRightEye: l(a.questionOnRightEye, b.questionOnRightEye),
      questionFontSize: l(a.questionFontSize, b.questionFontSize),
      exclaim: l(a.exclaim, b.exclaim),
      exclaimOnLeftEye: l(a.exclaimOnLeftEye, b.exclaimOnLeftEye),
      exclaimFontSize: l(a.exclaimFontSize, b.exclaimFontSize),
      thinkingDots: l(a.thinkingDots, b.thinkingDots),
      narrowEyes: l(a.narrowEyes, b.narrowEyes),
      centerHeart: l(a.centerHeart, b.centerHeart),
      checkStroke: l(a.checkStroke, b.checkStroke),
      errorStroke: l(a.errorStroke, b.errorStroke),
      bodyOffsetX: l(a.bodyOffsetX, b.bodyOffsetX),
      bodyOffsetY: l(a.bodyOffsetY, b.bodyOffsetY),
      processing: l(a.processing, b.processing),
      showLink: l(a.showLink, b.showLink),
      batteryLevel: l(a.batteryLevel, b.batteryLevel),
      shake: l(a.shake, b.shake),
      nod: l(a.nod, b.nod),
      surpriseJump: l(a.surpriseJump, b.surpriseJump),
      angryEye: l(a.angryEye, b.angryEye),
    );
  }
}