import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VReplaySheet extends StatelessWidget {
  const VReplaySheet({super.key, required this.isLong, required this.onTap});

  final bool isLong;
  final Function(bool) onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () {
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset('assets/images/close@3x.png', width: 24),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: const BoxDecoration(
            color: Color(0xFFF9F9F9),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Reply mode',
                style: TextStyle(
                  color: Color(0xFF434343),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: _buildItem(
                      'Short Reply:\nlike sms',
                      'assets/images/short@3x.png',
                      !isLong,
                      onTap: () {
                        onTap(false);
                      },
                    ),
                  ),
                  Expanded(
                    child: _buildItem(
                      'Long Reply:\nlike story',
                      'assets/images/long@3x.png',
                      isLong,
                      onTap: () {
                        onTap(true);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItem(
    String title,
    String icon,
    bool isSelected, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0x1AFFFFFF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: BoxBorder.all(
                    width: 2,
                    color: isSelected
                        ? const Color(0xFF55CFDA)
                        : Colors.transparent,
                  ),
                ),
                child: Column(
                  spacing: 12,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(icon, width: 32),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF181818),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
