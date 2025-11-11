import 'package:flutter/material.dart';

class LinkedItem extends StatelessWidget {
  const LinkedItem({
    super.key,
    required this.animation,
    required this.title,
    required this.isActive,
    required this.onTap,
    this.icon,
    this.textStyle,
    this.activeTextStyle,
    this.indicatorHeight = 4,
  });

  final Listenable animation;
  final String title;
  final bool isActive;
  final Widget? icon;
  final TextStyle? textStyle;
  final TextStyle? activeTextStyle;
  final void Function() onTap;
  final double? indicatorHeight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedBuilder(
        animation: animation,
        builder: (_, _) {
          return buildTabItem(title: title, isActive: isActive, onTap: onTap);
        },
      ),
    );
  }

  Widget buildTabItem({
    Key? key,
    required String title,
    required bool isActive,
    void Function()? onTap,
  }) {
    final style = isActive ? activeTextStyle : textStyle;

    return GestureDetector(
      key: key,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            spacing: 4,
            children: [
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                style:
                    style ??
                    TextStyle(
                      color: isActive
                          ? Color(0xFFDF78B1)
                          : const Color(0xFF8C8C8C),
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 16,
                    ),
              ),
              if (icon != null) icon!,
            ],
          ),
          Container(
            width: indicatorHeight,
            height: indicatorHeight,
            decoration: BoxDecoration(
              color: isActive ? Color(0xFFDF78B1) : Colors.transparent,
              borderRadius: BorderRadius.circular((indicatorHeight ?? 4) * 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
