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
            _buildContainer(),
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
      color: const Color(0x80000000),
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
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
        bottomRight: Radius.circular(16),
      ),
      colorOpacity: 0.9,
      blur: 3,
      blurColor: const Color(0x1A1C1C1C),
    );
  }

  Widget _buildLock() {
    return Column(
      children: [
        _buildLabel(),
        const SizedBox(height: 10),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "** Tap to see the messages **",
              style: TextStyle(
                color: Color(0xFFDF78B1),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 28,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0x80DF78B1),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Unlock',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildLabel() {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        gradient: LinearGradient(
          colors: [Color(0x29DF78B1), Color(0x00DF78B1)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          const Text(
            'Unlock Text Reply',
            style: TextStyle(
              color: Color(0xFFDF78B1),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
          Image.asset(
            'assets/images/locktext@3x.png',
            width: 16,
          ),
        ],
      ),
    );
  }
}
