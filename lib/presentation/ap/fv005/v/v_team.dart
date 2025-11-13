import 'package:flutter/material.dart';
import 'package:soul_talk/router/nav_to.dart';

enum PolicyBottomType { gems, vip1, vip2 }

class PrivacyView extends StatelessWidget {
  const PrivacyView({super.key, required this.type});

  final PolicyBottomType type;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case PolicyBottomType.gems:
        return _buildGemsBottom();
      case PolicyBottomType.vip1:
        return _buildVipBottom(const Color(0x80FFFFFF), true);
      case PolicyBottomType.vip2:
        return _buildVipBottom(const Color(0x80FFFFFF), false);
    }
  }

  // 提取公共逻辑，减少重复
  Widget _buildVipBottom(Color buttonColor, bool showSubscriptionText) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton("Privacy policy", () => NTO.toPrivacy(), buttonColor),
            _buildSeparator(),
            _buildButton("Terms of use", () => NTO.toTerms(), buttonColor),
          ],
        ),
        if (showSubscriptionText) ...[
          const SizedBox(height: 12),
          const Text(
            "Subscriptions auto-renew until canceled, as described in the Terms. Cancel anytime, Cancel at least 24 hours prior to renewal to avoid additional charges. Please note that you cannot get any refund even if the subscription period is not expired.",
            style: TextStyle(
              color: Color(0x80FFFFFF),
              fontSize: 9,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildGemsBottom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButton("Terms of use", () => NTO.toTerms(), null),
        _buildSeparator(),
        _buildButton("Privacy policy", () => NTO.toPrivacy(), null),
      ],
    );
  }

  // 提取分隔符部分
  Widget _buildSeparator() {
    return Container(
      width: 1,
      height: 12,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: const Color(0x40ffffff),
    );
  }

  Widget _buildButton(String title, VoidCallback onTap, Color? color) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          color: const Color(0x40ffffff),
          fontWeight: FontWeight.w300,
          decoration: TextDecoration.underline,
          decorationColor: color ?? const Color(0x40ffffff),
          decorationThickness: 1.0,
        ),
      ),
    );
  }
}
