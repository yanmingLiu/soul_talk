import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:soul_talk/app/di_depency.dart';
import 'package:soul_talk/core/analytics/analytics_service.dart';
import 'package:soul_talk/domain/value_objects/enums.dart';
import 'package:soul_talk/router/nav_to.dart';

class VTextLock extends StatelessWidget {
  const VTextLock({super.key, this.onTap, required this.textContent});

  final void Function()? onTap;
  final String textContent;

  void _unLockTextGems() async {
    logEvent('c_news_locktext');
    if (!DI.login.vipStatus.value) {
      NTO.pushVip(VipSF.locktext);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 120,
      child: GestureDetector(
        onTap: _unLockTextGems,
        child: Stack(
          alignment: AlignmentDirectional.topStart,
          children: [
            Positioned(top: 8, right: 0, bottom: 0, child: _buildContainer()),
            _buildLabel(),
            _buildLock(),
          ],
        ),
      ),
    );
  }

  Widget _buildContainer() {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      color: const Color(0x801C1C1C),
      child: Text(
        textContent,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    ).blurred(
      borderRadius: BorderRadius.circular(12),
      colorOpacity: 0.9,
      blur: 100,
      blurColor: const Color(0x1A1C1C1C),
    );
  }

  Widget _buildLock() {
    return Column(
      children: [
        const SizedBox(height: 26),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "*****Tap to see the messages *****",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFFFC584),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'message',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFF00AB8E),
              ),
              child: Row(
                children: [
                  Image.asset('assets/images/unlock_icon.png', width: 22),
                  Text(
                    'Unlock',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildLabel() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 20,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: const Color(0xFFFFC584),
          ),
          child: Text(
            'Unlock Text Reply',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
