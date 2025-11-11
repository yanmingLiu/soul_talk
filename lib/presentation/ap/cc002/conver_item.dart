import 'package:flutter/material.dart';
import 'package:soul_talk/presentation/v000/v_button.dart';
import 'package:soul_talk/presentation/v000/v_image.dart';

class ConverItem extends StatelessWidget {
  const ConverItem({
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
      borderRadius: BorderRadius.circular(0),
      color: Colors.transparent,
      onTap: onTap,
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        spacing: 12,
        children: [
          VImage(
            url: avatar,
            width: 50,
            height: 50,
            cacheWidth: 100,
            cacheHeight: 100,
            shape: BoxShape.circle,
            borderRadius: BorderRadius.circular(25),
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
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      formatSessionTime(
                        updateTime ?? DateTime.now().millisecondsSinceEpoch,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF797C7B),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Text(
                  lastMsg ?? '-',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF797C7B),
                    fontSize: 12,
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
