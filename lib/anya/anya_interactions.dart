import 'package:flutter/material.dart';

import 'anya_expression.dart';
import 'anya_face_controller.dart';
import 'masters/excited_master.dart';

/// Maps touch gestures to Anya's expressions.
///
/// Each input maps to exactly one expression (no shared buttons or multi-tap chains):
///
/// | Input | Gesture | Expression |
/// |-------|---------|------------|
/// | Primary | tap | Wink |
/// | Primary | double tap | Surprised |
/// | Primary | long press left / center / right third | Curious / Processing / Proud (release → idle) |
/// | Primary | flick up | Excited |
/// | Primary | flick down gentle / hard | Sad / Angry |
/// | Primary | flick left gentle / hard | Look left / Error |
/// | Primary | flick right | Look right |
/// | Secondary | click | In love |
/// | Secondary | hold | Happy |
/// | Tertiary | click | Accepted (middle button only; no hold action) |
class AnyaInteractionLayer extends StatefulWidget {
  const AnyaInteractionLayer({
    super.key,
    required this.controller,
    required this.child,
  });

  final AnyaFaceController controller;
  final Widget child;

  @override
  State<AnyaInteractionLayer> createState() => _AnyaInteractionLayerState();
}

class _AnyaInteractionLayerState extends State<AnyaInteractionLayer> {
  Offset? _dragStart;
  bool _longPressHeld = false;

  static const _flickMin = 120.0;
  static const _flickAngry = 300.0;
  static const _flickError = 300.0;

  void _onTap() {
    widget.controller.triggerBlink();
    widget.controller.setExpression(AnyaExpression.winking, transient: true);
  }

  void _onDoubleTap() {
    widget.controller.playSurpriseJump();
  }

  void _onSecondaryTap() {
    widget.controller.playHeartGesture();
  }

  void _onLongPressStart(LongPressStartDetails details) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    _longPressHeld = true;
    final local = box.globalToLocal(details.globalPosition);
    final x = local.dx / box.size.width;
    if (x < 0.35) {
      widget.controller.setExpression(AnyaExpression.curious);
    } else if (x > 0.65) {
      widget.controller.setExpression(AnyaExpression.proud);
    } else {
      widget.controller.setExpression(AnyaExpression.processing);
    }
  }

  void _onLongPressEnd() {
    _longPressHeld = false;
    widget.controller.setExpression(AnyaExpression.idle);
  }

  void _onLongPressCancel() => _longPressHeld = false;

  void _onPanStart(DragStartDetails d) => _dragStart = d.localPosition;

  void _onPanEnd(DragEndDetails d) {
    final start = _dragStart;
    _dragStart = null;
    if (start == null || _longPressHeld) return;

    final v = d.velocity.pixelsPerSecond;
    if (v.distance < _flickMin) return;

    final dx = v.dx;
    final dy = v.dy;

    if (dx.abs() > dy.abs()) {
      if (dx > 0) {
        widget.controller.setExpression(AnyaExpression.lookRight, transient: true);
      } else if (v.distance >= _flickError) {
        widget.controller.playErrorGesture();
      } else {
        widget.controller.setExpression(AnyaExpression.lookLeft, transient: true);
      }
    } else if (dy < 0) {
      widget.controller.setExpression(
        AnyaExpression.excited,
        duration: Duration(milliseconds: ExcitedMaster.morphDurationMs),
        transient: true,
      );
    } else if (v.distance >= _flickAngry) {
      widget.controller.playAngryGesture();
    } else {
      widget.controller.setExpression(AnyaExpression.sad, transient: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _onTap,
      onDoubleTap: _onDoubleTap,
      onSecondaryTap: _onSecondaryTap,
      onSecondaryLongPress: widget.controller.playHappyGesture,
      onTertiaryTapUp: (_) => widget.controller.playAcceptedGesture(),
      onLongPressStart: _onLongPressStart,
      onLongPressEnd: (_) => _onLongPressEnd(),
      onLongPressCancel: _onLongPressCancel,
      onPanStart: _onPanStart,
      onPanEnd: _onPanEnd,
      child: widget.child,
    );
  }
}

class ExpressionRibbon extends StatelessWidget {
  const ExpressionRibbon({
    super.key,
    required this.controller,
    required this.expressions,
  });

  final AnyaFaceController controller;
  final List<AnyaExpression> expressions;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xAA0D0F12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF2A3038)),
              ),
              child: SizedBox(
                height: 54,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: expressions.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 6),
                  itemBuilder: (context, i) {
                    final e = expressions[i];
                    final selected = controller.expression == e;
                    return ActionChip(
                      label: Text(
                        e.label,
                        style: TextStyle(
                          fontSize: 12,
                          color: selected ? const Color(0xFF061014) : const Color(0xFFD8ECF8),
                        ),
                      ),
                      backgroundColor:
                          selected ? const Color(0xFF5CE1FF) : const Color(0xFF1A2028),
                      side: BorderSide(
                        color: selected ? const Color(0xFF5CE1FF) : const Color(0xFF2F3844),
                      ),
                      onPressed: () => controller.setExpression(e),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}