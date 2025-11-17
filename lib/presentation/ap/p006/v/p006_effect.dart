import 'dart:async';

import 'package:flutter/material.dart';

class P006Effect extends StatefulWidget {
  final double width;
  final double height;
  final Color color;
  final double borderWidth;
  final int rippleSpacing;
  final double scaleMultiplier;

  const P006Effect({
    super.key,
    required this.width,
    required this.height,
    required this.color,
    required this.borderWidth,
    required this.rippleSpacing,
    required this.scaleMultiplier,
  });

  @override
  State<P006Effect> createState() => _P006EffectState();
}

class _P006EffectState extends State<P006Effect> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  late List<Timer> _timers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (index) {
      return AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
      );
    });

    _animations = _controllers.map((controller) {
      return CurvedAnimation(parent: controller, curve: Curves.linear);
    }).toList();

    _timers = List.generate(3, (index) {
      return Timer(Duration(milliseconds: widget.rippleSpacing * index), () {
        _controllers[index].repeat();
      });
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var timer in _timers) {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            double scale =
                1.0 + _animations[index].value * widget.scaleMultiplier;
            return Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: 1.0 - _animations[index].value,
                child: Container(
                  width: widget.width,
                  height: widget.height,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.color,
                      width: widget.borderWidth,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
