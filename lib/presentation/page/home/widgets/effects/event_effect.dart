import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EventEffect extends StatefulWidget {
  final VoidCallback? onCompleted;
  const EventEffect({this.onCompleted, super.key});

  @override
  State<EventEffect> createState() => _EventEffectState();
}

class _EventEffectState extends State<EventEffect>
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
            'assets/animations/merry_christmas_shake_effect.json',
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
