import 'package:flutter/material.dart';

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
          Container(
            width: 64,
            height: 64,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0x40FFFFFF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                backgroundColor: Color(0x80FFFFFF),
                strokeWidth: 3,
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            "AI Crafting...",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Creating your digital masterpiece...",
            style: TextStyle(
              color: Color(0xBFffffff),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Great art takes computational power and time — every moment you wait turns into pixels that spark wonder.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xBFffffff),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
