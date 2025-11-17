import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/app/di_depency.dart';
import 'package:soul_talk/core/analytics/analytics_service.dart';
import 'package:soul_talk/domain/entities/message.dart';
import 'package:soul_talk/domain/value_objects/enums.dart';
import 'package:soul_talk/presentation/ap/cc002/v/v_text.dart';
import 'package:soul_talk/presentation/v000/v_image.dart';
import 'package:soul_talk/router/nav_to.dart';

class VVideo extends StatelessWidget {
  const VVideo({super.key, required this.msg});

  final Message msg;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VText(msg: msg),
          const SizedBox(height: 8),
          if (!msg.typewriterAnimated) _buildImageWidget(),
        ],
      ),
    );
  }

  Widget _buildImageWidget() {
    var imageUrl = msg.thumbLink ?? msg.imgUrl ?? '';
    var isLockImage = msg.mediaLock == MsgLock.private.value;
    var imageWidth = 200.0;
    var imageHeight = 240.0;

    var videoUrl = msg.videoUrl ?? '';

    var imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: VImage(
        url: imageUrl,
        width: imageWidth,
        height: imageHeight,
        borderRadius: BorderRadius.circular(16),
      ),
    );

    return Obx(() {
      var isHide = !DI.login.vipStatus.value && isLockImage;
      return isHide
          ? _buildCover(imageWidth, imageHeight, imageWidget)
          : _buildVideoButton(videoUrl, imageWidget);
    });
  }

  Widget _buildCover(
    double imageWidth,
    double imageHeight,
    Widget imageWidget,
  ) {
    return GestureDetector(
      onTap: _onTapUnlock,
      child: Container(
        width: imageWidth,
        height: imageHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0x801C1C1C),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: Alignment.center,
          children: [
            imageWidget,
            ClipRect(
              child: BackdropFilter(
                blendMode: BlendMode.srcIn,
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  alignment: Alignment.center,
                  height: double.infinity,
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Color(0x801C1C1C)),
                ),
              ),
            ),
            Image.asset('assets/images/lock@3x.png', width: 28),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: const BoxDecoration(
                  color: Color(0x80000000),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Hot Video',
                  style: TextStyle(
                    color: Color(0xFFDF78B1),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoButton(String videoUrl, Widget imageWidget) {
    return InkWell(
      onTap: () {
        NTO.pushVideoPreview(videoUrl);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [imageWidget, const Icon(Icons.play_circle, size: 32)],
      ),
    );
  }

  void _onTapUnlock() async {
    logEvent('c_news_lockvideo');
    final isVip = DI.login.vipStatus.value;
    if (!isVip) {
      NTO.pushVip(VipSF.lockpic);
    }
  }
}
