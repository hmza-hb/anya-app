import 'anya_expression.dart';
import 'face_params.dart';
import 'masters/curious_master.dart';
import 'masters/idle_master.dart';
import 'masters/surprised_master.dart';
import 'masters/excited_master.dart';
import 'masters/happy_master.dart';
import 'masters/sad_master.dart';
import 'masters/accepted_master.dart';
import 'masters/angry_master.dart';
import 'masters/in_love_master.dart';
import 'masters/proud_master.dart';
import 'masters/processing_master.dart';
import 'masters/error_master.dart';
import 'masters/winking_master.dart';

FaceParams paramsFor(AnyaExpression e) => _map[e] ?? IdleMaster.params;

final Map<AnyaExpression, FaceParams> _map = {
  AnyaExpression.idle: IdleMaster.params,
  AnyaExpression.curious: CuriousMaster.params,
  AnyaExpression.happy: HappyMaster.params,
  AnyaExpression.sad: SadMaster.params,
  AnyaExpression.excited: ExcitedMaster.params,
  AnyaExpression.thinking: const FaceParams(
    eyeWidth: 24,
    eyeHeight: 76,
    question: 1,
  ),
  AnyaExpression.sleepy: const FaceParams(archCurve: 0.75, eyeHeight: 32, eyeWidth: 64),
  AnyaExpression.surprised: SurprisedMaster.params,
  AnyaExpression.winking: WinkingMaster.params,
  AnyaExpression.angry: AngryMaster.params,
  AnyaExpression.inLove: InLoveMaster.params,
  AnyaExpression.accepted: AcceptedMaster.params,
  AnyaExpression.speaking: const FaceParams(soundRight: 1, eyeWidth: 26, eyeHeight: 74),
  AnyaExpression.listening: const FaceParams(soundLeft: 1, soundRight: 1),
  AnyaExpression.shy: const FaceParams(archCurve: 0.7, blush: 1, eyeHeight: 48),
  AnyaExpression.proud: ProudMaster.params,
  AnyaExpression.lookUp: const FaceParams(gazeArrow: 1, lookY: -1),
  AnyaExpression.lookDown: const FaceParams(gazeArrow: 1, lookY: 1),
  AnyaExpression.lookLeft: const FaceParams(gazeArrow: 1, lookX: -1),
  AnyaExpression.lookRight: const FaceParams(gazeArrow: 1, lookX: 1),
  AnyaExpression.thinkingHard: const FaceParams(
    narrowEyes: 1,
    sparkle: 0.6,
    eyeHeight: 16,
    eyeWidth: 56,
  ),
  AnyaExpression.confused: const FaceParams(
    leftSlant: -0.25,
    rightSlant: 0.35,
    question: 0.8,
    eyeHeight: 68,
  ),
  AnyaExpression.listeningActive: const FaceParams(
    soundLeft: 1,
    soundRight: 1,
    soundBoost: 1,
  ),
  AnyaExpression.speakingActive: const FaceParams(
    soundRight: 1,
    soundBoost: 1,
    eyeWidth: 26,
    eyeHeight: 74,
  ),
  AnyaExpression.processing: ProcessingMaster.params,
  AnyaExpression.connecting: const FaceParams(showLink: 1, eyeWidth: 0, eyeHeight: 0),
  AnyaExpression.error: ErrorMaster.params,
  AnyaExpression.charging: const FaceParams(batteryLevel: 0.65),
  AnyaExpression.lowBattery: const FaceParams(batteryLevel: 0.12),
};