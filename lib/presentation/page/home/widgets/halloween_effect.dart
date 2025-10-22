import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HalloweenEffect extends StatefulWidget {
  final VoidCallback? onCompleted;
  const HalloweenEffect({this.onCompleted, super.key});

  @override
  State<HalloweenEffect> createState() => _HalloweenEffectState();
}

class _HalloweenEffectState extends State<HalloweenEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onCompleted?.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        color: Colors.black.withOpacity(0.3),
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Lottie.asset(
            'assets/animations/ghost.json',
            fit: BoxFit.cover,
            controller: _controller,
            onLoaded: (composition) {
              _controller.duration = composition.duration;
              _controller.forward();
            },
            repeat: false,
          ),
        ),
      ),
    );
  }
}
