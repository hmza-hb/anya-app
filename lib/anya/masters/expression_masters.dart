import '../anya_expression.dart';

export 'curious_master.dart';
export 'excited_master.dart';
export 'happy_master.dart';
export 'sad_master.dart';
export 'accepted_master.dart';
export 'angry_master.dart';
export 'in_love_master.dart';
export 'proud_master.dart';
export 'processing_master.dart';
export 'error_master.dart';
export 'surprised_master.dart';
export 'winking_master.dart';
export 'design_scale.dart';
export 'eye_glow_style.dart';
export 'idle_master.dart';

/// Index of **locked-in** expression master files (jump to these in the repo).
///
/// | Expression | Master class    | File |
/// |------------|-----------------|------|
/// | idle       | [IdleMaster]    | `masters/idle_master.dart` |
/// | happy      | [HappyMaster]   | `masters/happy_master.dart` |
/// | sad        | [SadMaster]     | `masters/sad_master.dart` |
/// | curious    | [CuriousMaster]   | `masters/curious_master.dart` |
/// | surprised  | [SurprisedMaster] | `masters/surprised_master.dart` |
/// | winking    | [WinkingMaster]   | `masters/winking_master.dart` |
/// | excited    | [ExcitedMaster]   | `masters/excited_master.dart` |
/// | inLove     | [InLoveMaster]    | `masters/in_love_master.dart` |
/// | accepted   | [AcceptedMaster]  | `masters/accepted_master.dart` |
/// | angry      | [AngryMaster]     | `masters/angry_master.dart` |
/// | proud      | [ProudMaster]     | `masters/proud_master.dart` |
/// | processing | [ProcessingMaster] | `masters/processing_master.dart` |
/// | error      | [ErrorMaster]     | `masters/error_master.dart` |
abstract final class ExpressionMasters {
  static const locked = <AnyaExpression, String>{
    AnyaExpression.idle: 'lib/anya/masters/idle_master.dart',
    AnyaExpression.happy: 'lib/anya/masters/happy_master.dart',
    AnyaExpression.sad: 'lib/anya/masters/sad_master.dart',
    AnyaExpression.curious: 'lib/anya/masters/curious_master.dart',
    AnyaExpression.surprised: 'lib/anya/masters/surprised_master.dart',
    AnyaExpression.winking: 'lib/anya/masters/winking_master.dart',
    AnyaExpression.excited: 'lib/anya/masters/excited_master.dart',
    AnyaExpression.inLove: 'lib/anya/masters/in_love_master.dart',
    AnyaExpression.accepted: 'lib/anya/masters/accepted_master.dart',
    AnyaExpression.angry: 'lib/anya/masters/angry_master.dart',
    AnyaExpression.proud: 'lib/anya/masters/proud_master.dart',
    AnyaExpression.processing: 'lib/anya/masters/processing_master.dart',
    AnyaExpression.error: 'lib/anya/masters/error_master.dart',
  };

  static String? pathFor(AnyaExpression e) => locked[e];
}