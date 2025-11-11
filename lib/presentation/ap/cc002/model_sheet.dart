import 'package:flutter/material.dart';

class ModeSheet extends StatelessWidget {
  const ModeSheet({super.key, required this.isLong, required this.onTap});

  final bool isLong;
  final Function(bool) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF00120A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0x80FFFFFF),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Reply mode',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                _buildItem(
                  'Short Reply: like sms',
                  !isLong,
                  onTap: () {
                    onTap(false);
                  },
                ),
                const SizedBox(height: 12),
                _buildItem(
                  'Long Reply: like story',
                  isLong,
                  onTap: () {
                    onTap(true);
                  },
                ),
                const SizedBox(height: 34),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(String title, bool isSelected, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0x1AFFFFFF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF85FFCD) : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (isSelected) Image.asset('assets/images/surebtn.png', width: 22),
          ],
        ),
      ),
    );
  }
}
