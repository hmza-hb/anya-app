import 'package:flutter/material.dart';

import 'anya_face_controller.dart';
import 'anya_face_painter.dart';

/// Full-screen OLED face. No bezel, no chrome.
class AnyaRobotScreen extends StatelessWidget {
  const AnyaRobotScreen({super.key, required this.controller});

  final AnyaFaceController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return ColoredBox(
          color: Colors.black,
          child: CustomPaint(
            painter: AnyaFacePainter(
              params: controller.renderedParams,
              processingAngle: controller.processingAngle,
              wavePhase: controller.wavePhase,
              dotPhase: controller.dotPhase,
            ),
            child: const SizedBox.expand(),
          ),
        );
      },
    );
  }
}
