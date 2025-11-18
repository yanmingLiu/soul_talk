import 'package:flutter/material.dart';

class VTag extends StatelessWidget {
  const VTag({super.key, required this.tag});

  final String tag;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 20,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [Color(0xFF16C576), Color(0xFF4EAB7A)],
            ),
          ),
          child: Center(
            child: Text(
              tag,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

extension VTagExt on VTag {
  static VTag? tag(int? value) {
    if (value == 1) {
      return const VTag(tag: 'Best Value');
    }
    if (value == 2) {
      return const VTag(tag: 'Most Popular');
    }
    return null;
  }
}
