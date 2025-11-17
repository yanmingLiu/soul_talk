import 'package:flutter/material.dart';
import 'package:soul_talk/presentation/ap/p006/v/p006_effect.dart';

class P006Btn extends StatelessWidget {
  const P006Btn({
    super.key,
    required this.icon,
    this.animationColor,
    required this.onTap,
    this.isLinearGradientBg = false,
  });

  final String icon;
  final bool isLinearGradientBg;
  final Color? animationColor;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.circular(36),
            ),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (animationColor != null)
                    P006Effect(
                      width: 72,
                      height: 72,
                      color: animationColor!,
                      borderWidth: 1.0,
                      rippleSpacing: 300, // ripple interval in milliseconds
                      scaleMultiplier:
                          0.5, // adjust the scale multiplier to reduce the size change
                    ),
                  // icon,
                  Image.asset(icon),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
