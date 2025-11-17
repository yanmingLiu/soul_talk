import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class VCLoading extends StatelessWidget {
  const VCLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xE1000000),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 120),
          Text(
            "Generating your digital masterpiece...",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Great art consumes computational power and time. Every second you wait is transforming into pixels of wonder.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 40),
          LoadingAnimationWidget.hexagonDots(
            color: const Color(0xFF00AB8E),
            size: 40,
          ),
          const SizedBox(height: 14),
          const Text(
            "AI Generating...",
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
