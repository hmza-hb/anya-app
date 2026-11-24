import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'anya_expression.dart';
import 'face_params.dart';
import 'face_params_catalog.dart';
import 'masters/accepted_master.dart';
import 'masters/excited_master.dart';
import 'masters/processing_master.dart';
import 'masters/error_master.dart';

class AnyaFaceController extends ChangeNotifier {
  AnyaFaceController({required TickerProvider vsync})
      : _morphController = AnimationController(
          vsync: vsync,
          duration: const Duration(milliseconds: 480),
        ),
        _ambientController = AnimationController(
          vsync: vsync,
          duration: const Duration(seconds: 4),
        )..repeat(),
        _blinkController = AnimationController(
          vsync: vsync,
          duration: const Duration(milliseconds: 140),
        ) {
    _morphController.addListener(notifyListeners);
    _ambientController.addListener(notifyListeners);
    _blinkController.addListener(notifyListeners);
    _scheduleBlink();
  }

  final AnimationController _morphController;
  final AnimationController _ambientController;
  final AnimationController _blinkController;

  AnyaExpression _target = AnyaExpression.idle;
  FaceParams _fromParams = paramsFor(AnyaExpression.idle);
  FaceParams _toParams = paramsFor(AnyaExpression.idle);

  Timer? _blinkTimer;
  Timer? _returnTimer;

  AnyaExpression get expression => _target;

  FaceParams get renderedParams {
    final t = _morphT(_morphController.value);
    var merged = FaceParams.lerp(_fromParams, _toParams, t);

    final blink = _blinkCurve(_blinkController.value);
    if (blink > 0.001) {
      merged = FaceParams.lerp(
        merged,
        FaceParams(
          archCurve: merged.archCurve,
          eyeWidth: merged.eyeWidth,
          eyeHeight: merged.eyeHeight,
          blinkClose: 1,
          eyeGap: merged.eyeGap,
          chevronIn: merged.chevronIn,
          centerHeart: merged.centerHeart,
          archStrokeDesign: merged.archStrokeDesign,
          checkStroke: merged.checkStroke,
          errorStroke: merged.errorStroke,
          questionOnRightEye: merged.questionOnRightEye,
          exclaimOnLeftEye: merged.exclaimOnLeftEye,
          leftEyeHeight: merged.leftEyeHeight,
          rightEyeHeight: merged.rightEyeHeight,
          angryEye: merged.angryEye,
          sparkleOnRightEye: merged.sparkleOnRightEye,
          processing: merged.processing,
        ),
        blink,
      );
    }

    return merged;
  }

  double _morphT(double raw) {
    final accepted = _target == AnyaExpression.accepted ||
        _toParams.checkStroke > 0.12 ||
        _fromParams.checkStroke > 0.12;
    if (accepted) {
      final drawing = _toParams.checkStroke >= _fromParams.checkStroke;
      return drawing
          ? Curves.easeOutCubic.transform(raw)
          : Curves.easeInCubic.transform(raw);
    }

    final error = _target == AnyaExpression.error ||
        _toParams.errorStroke > 0.12 ||
        _fromParams.errorStroke > 0.12;
    if (error) {
      final drawing = _toParams.errorStroke >= _fromParams.errorStroke;
      return drawing
          ? Curves.easeOutCubic.transform(raw)
          : Curves.easeInCubic.transform(raw);
    }

    final excited =
        _target == AnyaExpression.excited || _toParams.chevronIn > 0.15 || _fromParams.chevronIn > 0.15;
    if (!excited) {
      return Curves.easeInOutCubic.transform(raw);
    }
    final opening = _toParams.chevronIn >= _fromParams.chevronIn;
    if (opening) {
      return Curves.easeOutBack.transform(raw);
    }
    return Curves.easeInCubic.transform(raw);
  }

  double get processingAngle =>
      _ambientController.value *
      math.pi *
      2 *
      ProcessingMaster.spinTurnsPerAmbientCycle;
  double get wavePhase => _ambientController.value;
  double get dotPhase => _ambientController.value;

  void setExpression(
    AnyaExpression next, {
    Duration? duration,
    bool transient = false,
  }) {
    if (next == _target && _morphController.isCompleted) return;

    _returnTimer?.cancel();
    _target = next;
    _fromParams = renderedParams;
    _toParams = paramsFor(next);

    if (duration != null) {
      _morphController.duration = duration;
    } else if (next == AnyaExpression.excited) {
      _morphController.duration =
          Duration(milliseconds: ExcitedMaster.morphDurationMs);
    } else if (next == AnyaExpression.accepted) {
      _morphController.duration =
          Duration(milliseconds: AcceptedMaster.morphDurationMs);
    } else if (next == AnyaExpression.error) {
      _morphController.duration =
          Duration(milliseconds: ErrorMaster.morphDurationMs);
    } else {
      _morphController.duration = const Duration(milliseconds: 480);
    }

    _morphController.forward(from: 0).whenComplete(() {
      _fromParams = _toParams;

      if (transient) {
        _returnTimer = Timer(const Duration(seconds: 2), () {
          setExpression(AnyaExpression.idle);
        });
      }
    });

    notifyListeners();
  }

  void playSurpriseJump() {
    setExpression(
      AnyaExpression.surprised,
      duration: const Duration(milliseconds: 320),
      transient: true,
    );
  }

  void playHappyGesture() {
    setExpression(AnyaExpression.happy, transient: true);
  }

  void playAngryGesture() {
    setExpression(AnyaExpression.angry, transient: true);
  }

  void playProudGesture() {
    setExpression(AnyaExpression.proud, transient: true);
  }

  void playProcessing() {
    if (_target == AnyaExpression.processing && _morphController.isCompleted) {
      setExpression(AnyaExpression.idle);
    } else {
      setExpression(AnyaExpression.processing);
    }
  }

  void playAcceptedGesture() {
    setExpression(
      AnyaExpression.accepted,
      duration: Duration(milliseconds: AcceptedMaster.morphDurationMs),
      transient: true,
    );
  }

  void playErrorGesture() {
    setExpression(
      AnyaExpression.error,
      duration: Duration(milliseconds: ErrorMaster.morphDurationMs),
      transient: true,
    );
  }

  void playHeartGesture() {
    setExpression(
      AnyaExpression.inLove,
      duration: const Duration(milliseconds: 520),
    );
    _returnTimer?.cancel();
    _returnTimer = Timer(const Duration(seconds: 2), () {
      setExpression(AnyaExpression.idle);
    });
  }

  void playNod() {
    _toParams = paramsFor(_target).copyWithNod(1);
    notifyListeners();
    _returnTimer?.cancel();
    _returnTimer = Timer(const Duration(milliseconds: 700), () {
      _toParams = paramsFor(_target);
      notifyListeners();
    });
  }

  void playShake() {
    _toParams = paramsFor(_target).copyWithShake(1);
    notifyListeners();
    _returnTimer?.cancel();
    _returnTimer = Timer(const Duration(milliseconds: 700), () {
      _toParams = paramsFor(_target);
      notifyListeners();
    });
  }

  void triggerBlink() {
    if (_blinkController.isAnimating) return;
    _blinkController.forward(from: 0).whenComplete(() {
      _blinkController.reverse();
    });
  }

  void _scheduleBlink() {
    _blinkTimer?.cancel();
    final delay = Duration(milliseconds: 2600 + math.Random().nextInt(3200));
    _blinkTimer = Timer(delay, () {
      if (_target == AnyaExpression.idle ||
          _target == AnyaExpression.happy ||
          _target == AnyaExpression.sad ||
          _target == AnyaExpression.curious ||
          _target == AnyaExpression.excited ||
          _target == AnyaExpression.angry ||
          _target == AnyaExpression.proud) {
        triggerBlink();
      }
      _scheduleBlink();
    });
  }

  double _blinkCurve(double t) {
    if (t <= 0.5) return Curves.easeIn.transform(t * 2);
    return Curves.easeOut.transform((1 - t) * 2);
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    _returnTimer?.cancel();
    _morphController.dispose();
    _ambientController.dispose();
    _blinkController.dispose();
    super.dispose();
  }
}

extension on FaceParams {
  FaceParams copyWithSurprise(double v) => FaceParams(
        eyeGap: eyeGap,
        eyeWidth: eyeWidth,
        eyeHeight: eyeHeight,
        surpriseJump: v * -18,
        exclaim: exclaim,
      );

  FaceParams copyWithNod(double v) => FaceParams(
        eyeGap: eyeGap,
        eyeWidth: eyeWidth,
        eyeHeight: eyeHeight,
        archCurve: archCurve,
        nod: v,
      );

  FaceParams copyWithShake(double v) => FaceParams(
        eyeGap: eyeGap,
        eyeWidth: eyeWidth,
        eyeHeight: eyeHeight,
        archCurve: archCurve,
        shake: v,
      );
}