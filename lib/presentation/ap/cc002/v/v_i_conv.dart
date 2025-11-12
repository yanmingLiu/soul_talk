import 'package:flutter/material.dart';
import 'package:soul_talk/presentation/v000/v_button.dart';
import 'package:soul_talk/presentation/v000/v_image.dart';

class VIConvItem extends StatelessWidget {
  const VIConvItem({
    super.key,
    this.onTap,
    required this.avatar,
    required this.name,
    this.updateTime,
    this.lastMsg,
  });

  final void Function()? onTap;
  final String avatar;
  final String name;
  final String? lastMsg;
  final int? updateTime;

  String formatSessionTime(int timestamp) {
    DateTime messageTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime now = DateTime.now();
    final difference = now.difference(messageTime);
    String twoDigits(int n) {
      return n.toString().padLeft(2, '0');
    }

    if (difference.inHours < 24) {
      return '${twoDigits(messageTime.hour)}:${twoDigits(messageTime.minute)}';
    } else {
      return '${twoDigits(messageTime.month)}-${twoDigits(messageTime.day)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return VButton(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      height: 96,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      type: ButtonType.border,
      borderColor: Color(0x0F000000),
      child: Row(
        spacing: 12,
        children: [
          VImage(
            url: avatar,
            width: 80,
            height: 80,
            cacheWidth: 100,
            cacheHeight: 100,
            borderRadius: BorderRadius.circular(20),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      formatSessionTime(
                        updateTime ?? DateTime.now().millisecondsSinceEpoch,
                      ),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF8C8C8C),
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                Text(
                  lastMsg ?? '-',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF595959),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
