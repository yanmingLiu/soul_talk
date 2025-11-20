import 'package:flutter/material.dart';

class AzListItemView extends StatelessWidget {
  const AzListItemView({
    super.key,
    required this.name,
    this.isShowSeparator = false,
    this.onTap,
    this.isChoosed = false,
  });

  final String name;

  final bool isShowSeparator;
  final bool isChoosed;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: isShowSeparator
              ? Border(bottom: BorderSide(color: Colors.grey[300]!, width: 0.5))
              : null,
        ),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  color: Color(0xFF595959),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            isChoosed
                ? Image.asset(
                    'assets/images/choose@3x.png',
                    width: 24,
                    height: 24,
                  )
                : const SizedBox.shrink(),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
