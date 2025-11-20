import 'dart:ui';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/app/di_depency.dart';
import 'package:soul_talk/domain/entities/post.dart';
import 'package:soul_talk/domain/value_objects/enums.dart';
import 'package:soul_talk/presentation/ap/bh001/c/h_post_bloc.dart';
import 'package:soul_talk/presentation/v000/empty_view.dart';
import 'package:soul_talk/presentation/v000/v_image.dart';
import 'package:soul_talk/router/nav_to.dart';
import 'package:soul_talk/utils/extensions.dart';

class HPostPage extends StatefulWidget {
  const HPostPage({super.key});

  @override
  State<HPostPage> createState() => _HPostPageState();
}

class _HPostPageState extends State<HPostPage> {
  final ctr = Get.put(HPostBlock());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(300.milliseconds, () {
        ctr.onRefresh();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HPostBlock>(
      builder: (_) {
        return EasyRefresh.builder(
          controller: ctr.rfctr,
          onRefresh: ctr.onRefresh,
          onLoad: ctr.onLoad,
          childBuilder: (context, physics) {
            if (ctr.type != null) {
              return EmptyView(type: ctr.type!, physics: physics);
            }

            return ListView.separated(
              physics: physics,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemBuilder: (BuildContext context, int index) {
                final data = ctr.list[index];
                return _buildItem(data);
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 20);
              },
              itemCount: ctr.list.length,
            );
          },
        );
      },
    );
  }

  Widget _buildItem(Post data) {
    var isVideo = data.cover != null && data.duration != null;
    var imgUrl = isVideo ? data.cover : data.media;
    var istop = data.istop ?? false;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            ctr.onItemClick(data);
          },
          child: Row(
            spacing: 16,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  VImage(
                    url: data.characterAvatar,
                    width: 44,
                    height: 44,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00DCE8),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: Text(
                  data.characterName ?? '-',
                  style: const TextStyle(
                    color: Color(0xFF181818),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          data.text ?? '',
          style: const TextStyle(
            color: Color(0xFF595959),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 20 / 14.0,
          ),
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            GestureDetector(
              onTap: () {
                ctr.onPlay(data);
              },
              child: VImage(
                url: imgUrl,
                height: 188,
                width: double.infinity,
                borderRadius: BorderRadius.circular(20.0),
                shape: BoxShape.rectangle,
              ),
            ),
            Positioned.fill(
              child: _buildLock(istop, isVideo, data),
            ),
            Positioned(
              left: 12,
              top: 12,
              child: isVideo
                  ? Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0x1FFFFFFF),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Row(
                        children: [
                          Image.asset('assets/images/post_video.png', width: 16),
                          const SizedBox(width: 4),
                          Text(
                            formatVideoDuration(data.duration ?? 0),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0x1FFFFFFF),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Image.asset(
                        'assets/images/post_photo.png',
                        width: 16,
                      ),
                    ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLock(bool istop, bool isVideo, Post data) {
    Widget widget = GestureDetector(
      onTap: () {
        NTO.pushVip(isVideo ? VipSF.lpostvideo : VipSF.lpostpic);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18.0, sigmaY: 18.0),
          child: Container(
            width: double.infinity,
            height: 188,
            color: const Color(0x80000000),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0x80000000),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset('assets/images/locktext@3x.png'),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Subscribe to view posts',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Widget play = Center(
      child: GestureDetector(
        onTap: () {
          ctr.onPlay(data);
        },
        child: Center(
          child: Image.asset(
            'assets/images/post_play.png',
            width: 28,
          ),
        ),
      ),
    );

    return Obx(() {
      var isVip = DI.login.vipStatus.value;
      if (isVip || istop) {
        return isVideo ? play : const SizedBox();
      } else {
        return widget;
      }
    });
  }
}
