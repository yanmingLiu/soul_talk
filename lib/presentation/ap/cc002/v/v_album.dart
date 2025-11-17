import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/app/di_depency.dart';
import 'package:soul_talk/domain/entities/figure_image.dart';
import 'package:soul_talk/presentation/ap/cc002/c/msg_bloc.dart';
import 'package:soul_talk/presentation/v000/v_image.dart';

class VAlbum extends StatefulWidget {
  const VAlbum({super.key});

  @override
  State<VAlbum> createState() => _VAlbumState();
}

class _VAlbumState extends State<VAlbum> {
  final imageHeight = 64.0;
  bool _isExpanded = true;

  final ctr = Get.find<MsgBloc>();

  RxList<FigureImage> images = <FigureImage>[].obs;

  @override
  void initState() {
    super.initState();

    images.value = ctr.role.images ?? [];

    ever(ctr.roleImagesChaned, (_) {
      images.value = ctr.role.images ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          return _buildImages();
        }),
      ],
    );
  }

  Widget _buildImages() {
    final imageCount = images.length;

    if (!DI.storage.isBest || imageCount == 0 || images.isEmpty) {
      return Container(height: 1, color: const Color(0x801C1C1C));
    }

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300), // 动画持续时间
          curve: Curves.easeInOut, // 动画曲线
          margin: const EdgeInsets.only(bottom: 12),
          height: _isExpanded ? 64 : 0, // 根据状态动态调整高度
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, idx) {
              final image = images[idx];
              final unlocked = image.unlocked ?? false;
              return VAlbumItem(
                imageHeight: imageHeight,
                image: image,
                avatar: ctr.role.avatar,
                unlocked: unlocked,
                onTap: () {
                  if (unlocked) {
                    ctr.onTapImage(image);
                  } else {
                    ctr.onTapUnlockImage(image);
                  }
                },
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(width: 12);
            },
            itemCount: imageCount,
          ),
        ),
        Row(
          children: [
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 1,
                color: const Color(0x80FFFFFF),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Row(
                children: [
                  const Text(
                    'Moments',
                    style: TextStyle(
                      color: Color(0x80FFFFFF),
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Icon(
                    color: const Color(0x80FFFFFF),
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 16,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 1,
                color: const Color(0x80FFFFFF),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
        const SizedBox(height: 8)
      ],
    );
  }
}

class VAlbumItem extends StatelessWidget {
  const VAlbumItem({
    super.key,
    required this.imageHeight,
    required this.image,
    required this.unlocked,
    this.onTap,
    this.avatar,
  });

  final double imageHeight;
  final FigureImage image;
  final bool unlocked;
  final void Function()? onTap;
  final String? avatar;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(18)),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: imageHeight,
          width: imageHeight,
          color: const Color(0xff000000),
          child: Stack(
            children: [
              VImage(
                url: !unlocked ? avatar : image.imageUrl,
                width: imageHeight,
                height: imageHeight,
                cacheWidth: 800,
                cacheHeight: 800,
                borderRadius: BorderRadius.circular(18),
              ),
              if (!unlocked)
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: const Color(0x80000000),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 20,
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/diamond.png',
                                  width: 20,
                                  height: 20,
                                ),
                                Text(
                                  '${image.gems ?? 0}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
