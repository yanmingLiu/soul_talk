import 'package:flutter/material.dart';
import 'package:soul_talk/app/di_depency.dart';
import 'package:soul_talk/core/constants/vs.dart';
import 'package:soul_talk/core/data/lo_pi.dart';
import 'package:soul_talk/domain/value_objects/enums.dart';
import 'package:soul_talk/presentation/v000/v_button.dart';
import 'package:soul_talk/presentation/v000/v_dialog.dart';
import 'package:soul_talk/router/nav_to.dart';

class VRewardView extends StatelessWidget {
  const VRewardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: -36,
            child: Image.asset(
              'assets/images/diamond22_bg@3x.png',
              width: 300,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
          DI.login.vipStatus.value ? _buildPro() : _buildNoPro(),
        ],
      ),
    );
  }

  Widget _buildPro() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          spacing: 4,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Daily Reward',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            Text(
              '+50',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 160),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 2,
          children: [
            const Text(
              'Pro',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            const Text(
              '50',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFFDF78B1),
              ),
            ),
            Image.asset('assets/images/diamond.png', width: 16),
            const Text(
              '/day',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        VButton(
          width: 240,
          onTap: () async {
            await LoginApi.getDailyReward();
            await DI.login.fetchUserInfo();
            VDialog.dismiss(tag: VS.loginRewardTag);
          },
          height: 48,
          borderRadius: BorderRadius.circular(12),
          color: Color(0xFFDF78B1),
          constraints: const BoxConstraints(minWidth: 44),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Center(
            child: Text(
              'Collect',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(height: 48),
      ],
    );
  }

  Widget _buildNoPro() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          spacing: 4,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Daily Reward',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            Text(
              '+20',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 160),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 2,
          children: [
            const Text(
              'Pro',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            const Text(
              '50',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFFDF78B1),
              ),
            ),
            Image.asset('assets/images/diamond.png', width: 16),
            const Text(
              '/day',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        VButton(
          onTap: () {
            NTO.pushVip(VipSF.dailyrd);
          },
          height: 48,
          width: 240,
          color: const Color(0xFFDF78B1),
          borderRadius: BorderRadius.circular(12),
          constraints: const BoxConstraints(minWidth: 44),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Center(
            child: Text(
              'Go to pro',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        VButton(
          width: 240,
          onTap: () async {
            await LoginApi.getDailyReward();
            await DI.login.fetchUserInfo();
            VDialog.dismiss(tag: VS.loginRewardTag);
          },
          height: 48,
          borderRadius: BorderRadius.circular(12),
          color: const Color(0x1AFFFFFF),
          constraints: const BoxConstraints(minWidth: 44),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Center(
            child: Text(
              'Collect',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
