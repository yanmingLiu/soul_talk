import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/core/analytics/analytics_service.dart';
import 'package:soul_talk/domain/entities/figure.dart';
import 'package:soul_talk/presentation/v000/v_image.dart';
import 'package:soul_talk/router/nav_to.dart';

class FloatItem extends StatelessWidget {
  const FloatItem({super.key, required this.role, required this.sessionId});

  final Figure role;
  final int sessionId;

  @override
  Widget build(BuildContext context) {
    if (role.videoChat == true) return _buildVideoItem();
    return const SizedBox();
  }

  void _onTapPhoneVideo() {
    logEvent('c_videocall');
    NTO.pushPhoneGuide(role: role);
  }

  Widget _buildVideoItem() {
    final guide = role.characterVideoChat?.firstWhereOrNull(
      (e) => e.tag == 'guide',
    );
    final url = guide?.gifUrl ?? role.avatar;

    return SizedBox(
      width: 86,
      height: 86,
      child: GestureDetector(
        onTap: _onTapPhoneVideo,
        child: Stack(
          children: [
            VImage(
              url: url,
              width: 80,
              height: 80,
              borderRadius: BorderRadius.circular(16),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Image.asset(
                'assets/images/msgvideo@3x.png',
                width: 20,
                height: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
