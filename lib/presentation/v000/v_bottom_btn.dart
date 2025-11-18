import 'package:flutter/material.dart';
import 'package:soul_talk/presentation/v000/v_button.dart';

class VBottomBtn extends StatelessWidget {
  const VBottomBtn({super.key, this.onTap, required this.title, this.children});

  final void Function()? onTap;
  final String title;
  final Widget? children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFF2F9), Color(0xFFFFFFFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          VButton(
            height: 48,
            color: const Color(0xFF55CFDA),
            onTap: onTap,
            margin: const EdgeInsets.symmetric(horizontal: 28),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          children ?? const SizedBox.shrink(),
          const SizedBox(height: 8),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
