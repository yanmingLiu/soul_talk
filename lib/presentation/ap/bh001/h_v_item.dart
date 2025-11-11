import 'package:flutter/material.dart';
import 'package:soul_talk/app/di_depency.dart';
import 'package:soul_talk/domain/entities/figure.dart';
import 'package:soul_talk/domain/repositories/figure_repository.dart';
import 'package:soul_talk/presentation/ap/bh001/h_bloc.dart';
import 'package:soul_talk/presentation/v000/v_image.dart';
import 'package:soul_talk/router/app_routers.dart';

class HomeItem extends StatelessWidget {
  const HomeItem({
    super.key,
    required this.role,
    required this.onCollect,
    required this.cate,
  });

  final Figure role;
  final void Function(Figure role) onCollect;
  final HCate cate;

  void _onTap() {
    FocusManager.instance.primaryFocus?.unfocus();

    final id = role.id;
    if (id == null) {
      return;
    }

    if (cate == HCate.video) {
      AppRoutes.pushPhoneGuide(role: role);
    } else {
      AppRoutes.pushChat(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCollect = role.collect ?? false;

    final isBigScreen = DI.storage.isBest;

    // 优化标签处理逻辑
    final displayTags = role.buildDisplayTags();
    final shouldShowTags = displayTags.isNotEmpty && isBigScreen;

    return GestureDetector(
      onTap: _onTap,
      child: Stack(
        children: [
          Positioned.fill(
            child: VImage(
              url: role.avatar,
              borderRadius: BorderRadius.circular(20),
              border: role.vip == true
                  ? BoxBorder.all(color: const Color(0xFF85FFCD), width: 2)
                  : null,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black],
                stops: const [0.7, 1.0],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(),
                Row(
                  spacing: 8,
                  children: [
                    Flexible(
                      child: Text(
                        role.name ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (role.age != null)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0x80DF78B1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          role.age.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                  ],
                ),
                if (shouldShowTags) ...[
                  _buildTags(displayTags),
                  const SizedBox(height: 4),
                ],
                Text(
                  role.aboutMe ?? '',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),

          PositionedDirectional(
            top: 0,
            end: 0,
            child: _buildCollectButton(isCollect),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectButton(bool isCollected) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        onCollect(role);
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0x66000000),
          borderRadius: BorderRadiusDirectional.only(
            topEnd: Radius.circular(20),
            bottomStart: Radius.circular(20),
          ),
        ),

        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 2,
          children: [
            Image.asset(
              isCollected
                  ? 'assets/images/like_s.png'
                  : 'assets/images/like_d.png',
              width: 12,
            ),
            const SizedBox(width: 2),
            Text(
              '${role.likes ?? 0}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTags(List<String> displayTags) {
    return Wrap(
      spacing: 4,
      crossAxisAlignment: WrapCrossAlignment.start,
      children: [
        for (int i = 0; i < displayTags.length; i++) ...[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0x29DF78B1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0x40DF78B1), width: 1),
            ),
            child: Text(
              displayTags[i],
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w400,
                color: _getTagColor(displayTags[i]),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Color _getTagColor(String text) {
    return const Color(0xFFFFDFF1);
  }
}
