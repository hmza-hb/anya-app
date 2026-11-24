import 'package:flutter/material.dart';

import 'anya_face_controller.dart';
import 'anya_interactions.dart';
import 'anya_robot_screen.dart';

class AnyaHomePage extends StatefulWidget {
  const AnyaHomePage({super.key});

  @override
  State<AnyaHomePage> createState() => _AnyaHomePageState();
}

class _AnyaHomePageState extends State<AnyaHomePage> with TickerProviderStateMixin {
  late final AnyaFaceController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnyaFaceController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnyaInteractionLayer(
        controller: _controller,
        child: AnyaRobotScreen(controller: _controller),
      ),
    );
  }
}
