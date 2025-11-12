import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:soul_talk/presentation/ap/cc002/c/center_bloc.dart';
import 'package:soul_talk/presentation/v000/nav_back_btn.dart';
import 'package:soul_talk/presentation/v000/v_button.dart';
import 'package:soul_talk/presentation/v000/v_image.dart';
import 'package:soul_talk/router/nav_to.dart';

class ChaterCenterPage extends StatefulWidget {
  const ChaterCenterPage({super.key});

  @override
  State<ChaterCenterPage> createState() => _ChaterCenterPageState();
}

class _ChaterCenterPageState extends State<ChaterCenterPage> {
  // final ScrollController _scrollController = ScrollController();
  // final double _appBarOpacity = 0.0;
  // final double _roleAvatarBgTop = 0.0;

  final ctr = Get.put(ChaterCenterController());

  // final int _index = 0;

  @override
  void initState() {
    super.initState();

    // _scrollController.addListener(_onScroll);
  }

  // void _onScroll() {
  //   // 根据滚动的偏移量调整透明度（滚动 0 ~ 200）
  //   double offset = _scrollController.offset;
  //   final maxOffset = Get.width - kToolbarHeight;
  //   double opacity = (offset / maxOffset).clamp(0, 1); // 限制透明度在 0 到 1 的范围内

  //   // 计算roleAvatarBg的top值，使其跟随滚动
  //   // 使用负值，确保背景可以完全滚出屏幕
  //   double newTop = -offset; // 使用1:1的滚动比例，确保可以完全滚出

  //   setState(() {
  //     _appBarOpacity = opacity;
  //     _roleAvatarBgTop = newTop;
  //   });
  //   log.d(
  //     '_onScroll _appBarOpacity: $_appBarOpacity, _roleAvatarBgTop: $_roleAvatarBgTop',
  //   );
  // }

  // @override
  // void dispose() {
  //   _scrollController.removeListener(_onScroll);
  //   _scrollController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    double topSafeHeight = MediaQuery.of(context).padding.top;
    double appBarHeight = AppBar().preferredSize.height; // 获取默认高度
    double totalHeight = topSafeHeight + appBarHeight;

    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: const Color(0xFFF9F9F9),
        appBar: AppBar(
          leading: const NavBackBtn(),
          actions: [
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset('assets/images/more@3x.png', width: 24),
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Container(
              constraints: BoxConstraints(minHeight: height),
              child: SingleChildScrollView(
                // controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildInfo(width, totalHeight),
                    const SizedBox(height: 16),
                    // _buildIndex(),
                    // const SizedBox(height: 16),
                    _buildIntro(),
                    // _buildTags(),
                    // _buildImages(),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomButton(),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildIndex() {
  //   return Row(
  //     spacing: 24,
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       LinkedItem(
  //         title: 'Info',
  //         isActive: _index == 0,
  //         onTap: () {
  //           setState(() {
  //             _index = 0;
  //           });
  //         },
  //       ),
  //       LinkedItem(
  //         title: 'Moments',
  //         isActive: _index == 1,
  //         onTap: () {
  //           setState(() {
  //             _index = 1;
  //           });
  //         },
  //       ),
  //     ],
  //   );
  // }

  Stack _buildInfo(double width, double totalHeight) {
    return Stack(
      children: [
        VImage(url: ctr.role.avatar, width: width, height: width),
        Container(
          width: width,
          height: totalHeight,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xE6000000), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            width: width,
            height: 120,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Color(0xE6000000)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              spacing: 12,
              children: [
                const Spacer(),
                Row(
                  spacing: 4,
                  children: [
                    Flexible(
                      child: Text(
                        ctr.role.name ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (ctr.role.age != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0x80DF78B1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          ctr.role.age.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                  ],
                ),
                Row(
                  spacing: 20,
                  children: [
                    _buildCount(
                      'assets/images/conv_count@3x.png',
                      'Dialogue',
                      ctr.role.sessionCount ?? '0',
                      const Color(0xFF55CFDA),
                    ),
                    Obx(() {
                      final icon = ctr.collect.value
                          ? 'assets/images/like_s.png'
                          : 'assets/images/like_d.png';

                      final color = ctr.collect.value
                          ? const Color(0xFFDF78B1)
                          : Colors.white;

                      return _buildCount(
                        icon,
                        'Favorite',
                        ctr.role.likes ?? '0',
                        color,
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Row _buildCount(String icon, String title, String count, Color color) {
    return Row(
      spacing: 8,
      children: [
        Image.asset(icon, width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              count,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Widget _buildTags() {
  //   if (!DI.storage.isBest) {
  //     return const SizedBox();
  //   }

  //   var tags = ctr.role.tags;
  //   if (tags == null || tags.isEmpty) {
  //     return const SizedBox();
  //   }

  //   return Container(
  //     padding: const EdgeInsets.all(12),
  //     margin: const EdgeInsets.all(12),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(20),
  //     ),
  //     child: Column(
  //       spacing: 8,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text(
  //           'Tags',
  //           style: TextStyle(
  //             color: Color(0xFF8C8C8C),
  //             fontSize: 14,
  //             fontWeight: FontWeight.w400,
  //           ),
  //         ),
  //         Wrap(
  //           spacing: 8,
  //           runSpacing: 8,
  //           children: tags.map((text) {
  //             return Row(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Container(
  //                   padding: const EdgeInsets.symmetric(
  //                     horizontal: 12,
  //                     vertical: 4,
  //                   ),
  //                   decoration: BoxDecoration(
  //                     color: const Color(0x1ADF78B1),
  //                     borderRadius: const BorderRadius.all(Radius.circular(12)),
  //                     border: Border.all(
  //                       width: 1,
  //                       color: const Color(0x40DF78B1),
  //                     ),
  //                   ),
  //                   alignment: Alignment.center,
  //                   child: Text(
  //                     text,
  //                     style: const TextStyle(
  //                       fontSize: 12,
  //                       fontWeight: FontWeight.w400,
  //                       color: Color(0xFF595959),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             );
  //           }).toList(),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildIntro() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          const Text(
            'Intro',
            style: TextStyle(
              color: Color(0xFF8C8C8C),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            ctr.role.aboutMe ?? '',
            style: const TextStyle(
              color: Color(0xFF595959),
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildImages() {
  //   return Obx(() {
  //     final images = ctr.images;
  //     if (!DI.storage.isBest || images.isEmpty) {
  //       return const SizedBox();
  //     }
  //     final imageCount = images.length;
  //     return Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         const SizedBox(height: 20),
  //         const Text(
  //           'Moments',
  //           style: TextStyle(
  //             color: Color(0xFF4D4D4D),
  //             fontSize: 16,
  //             fontWeight: FontWeight.w700,
  //           ),
  //         ),
  //         const SizedBox(height: 12),
  //         GridView.builder(
  //           physics: const NeverScrollableScrollPhysics(),
  //           shrinkWrap: true,
  //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //             crossAxisCount: 4,
  //             mainAxisSpacing: 4,
  //             crossAxisSpacing: 4,
  //             childAspectRatio: 1.0,
  //           ),
  //           itemBuilder: (_, idx) {
  //             final image = images[idx];
  //             final unlocked = image.unlocked ?? false;
  //             return PhotoAlbumItem(
  //               image: image,
  //               unlocked: unlocked,
  //               onTap: () {
  //                 if (unlocked) {
  //                   ctr.msgCtr.onTapImage(image);
  //                 } else {
  //                   ctr.msgCtr.onTapUnlockImage(image);
  //                 }
  //               },
  //               imageHeight: (MediaQuery.of(context).size.width - 32 - 12) / 4,
  //             );
  //           },
  //           itemCount: imageCount,
  //         ),
  //       ],
  //     );
  //   });
  // }

  Widget _buildBottomButton() {
    final bottom = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ).copyWith(bottom: bottom),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFF2F9), Color(0xFFFFFFFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        spacing: 12,
        children: [
          Expanded(
            child: Obx(() {
              final color = ctr.collect.value
                  ? const Color(0xFFDF78B1)
                  : const Color(0xFF8C8C8C);

              final title = ctr.collect.value ? "Unfollow" : 'Follow';
              return VButton(
                onTap: () {
                  ctr.onCollect();
                },
                height: 44,
                type: ButtonType.border,
                borderColor: color,
                borderWidth: 2,
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              );
            }),
          ),
          Expanded(
            child: VButton(
              onTap: () => Get.back(),
              height: 44,
              color: const Color(0xFF55CFDA),
              child: const Center(
                child: Text(
                  'Chat',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFF2F9), Color(0xFFFFFFFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          const Text(
            'optionTitle',
            style: TextStyle(
              color: Color(0xFF4D4D4D),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: [
              VButton(
                height: 44,
                borderRadius: BorderRadius.circular(0),
                color: Colors.transparent,
                onTap: ctr.clearHistory,
                child: const Row(
                  spacing: 4,
                  children: [
                    // Image.asset('assets/images/btnclear.png', width: 18),
                    Text(
                      'clearHistory',
                      style: TextStyle(
                        color: Color(0xFF4D4D4D),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.chevron_right, color: Color(0xFF9D9D9D)),
                  ],
                ),
              ),
              Container(height: 1, color: const Color(0x1AFFFFFF)),
              VButton(
                onTap: () => NTO.report(),
                height: 44,
                borderRadius: BorderRadius.circular(0),
                color: Colors.transparent,
                child: const Row(
                  spacing: 4,
                  children: [
                    // Image.asset('assets/images/btnreport.png', width: 18),
                    Text(
                      'report',
                      style: TextStyle(
                        color: Color(0xFF4D4D4D),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.chevron_right, color: Color(0xFF9D9D9D)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          VButton(
            onTap: ctr.deleteChat,
            color: Colors.white,
            child: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'deleteChat',
                    style: TextStyle(
                      color: Color(0xFFF04A4C),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
