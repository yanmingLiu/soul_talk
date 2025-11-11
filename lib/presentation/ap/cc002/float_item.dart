import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/core/analytics/analytics_service.dart';
import 'package:soul_talk/domain/entities/figure.dart';
import 'package:soul_talk/presentation/v000/v_image.dart';
import 'package:soul_talk/router/app_routers.dart';

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
    AppRoutes.pushPhoneGuide(role: role);
  }

  Widget _buildVideoItem() {
    final guide = role.characterVideoChat?.firstWhereOrNull(
      (e) => e.tag == 'guide',
    );
    final url = guide?.gifUrl ?? role.avatar;

    return GestureDetector(
      onTap: _onTapPhoneVideo,
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: VImage(
              url: url,
              width: 64,
              height: 64,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
          Image.asset('assets/images/msgvideo@3x.png', width: 20, height: 20),
        ],
      ),
    );
  }
}
