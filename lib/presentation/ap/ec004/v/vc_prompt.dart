import 'package:flutter/material.dart';

class VcPrompt extends StatelessWidget {
  const VcPrompt(
      {super.key, this.onTap, this.customPrompt, required this.isVideo});

  final void Function()? onTap;

  final String? customPrompt;

  final bool isVideo;

  @override
  Widget build(BuildContext context) {
    bool hasCustomPrompt = customPrompt != null && customPrompt!.isNotEmpty;

    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Text(
            "Custom Prompt",
            style: TextStyle(
              color: Color(0xFF595959),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              hasCustomPrompt
                  ? customPrompt!
                  : isVideo
                      ? "e.g: A woman takes off her clothes, exposing her breasts and nipples, naked, undressed, nude"
                      : "e.g: bikini,lingerie",
              style: TextStyle(
                color: hasCustomPrompt
                    ? const Color(0xFF1C1C1C)
                    : const Color(0xFFB3B3B3),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
