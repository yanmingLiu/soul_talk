import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/presentation/ap/cc002/msg_bloc.dart';
import 'package:soul_talk/presentation/v000/v_ani_progress.dart';
import 'package:soul_talk/presentation/v000/v_image.dart';
import 'package:soul_talk/router/app_routers.dart';

class LevelWidget extends StatelessWidget {
  const LevelWidget({super.key});

  String formatNumber(double? value) {
    if (value == null) {
      return '0';
    }
    if (value % 1 == 0) {
      // 如果小数部分为 0，返回整数
      return value.toInt().toString();
    } else {
      // 如果有小数部分，返回原值
      return value.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<MsgBloc>();
    return Obx(() {
      final data = ctr.chatLevel.value;
      if (data == null) {
        return const SizedBox();
      }

      var level = data.level ?? 1;
      var progress = (data.progress ?? 0) / 100.0;
      var rewards = '+${data.rewards ?? 0}';

      var value = formatNumber(data.progress);
      // var total = data.upgradeRequirements?.toInt() ?? 0;
      // var proText = '$value/$total';

      return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          AppRoutes.pushProfile(ctr.role);
        },
        child: Container(
          width: 160,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0x801C1C1C),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 4,
                children: [
                  Row(
                    spacing: 4,
                    children: [
                      VImage(
                        url: ctr.role.avatar,
                        width: 20,
                        height: 20,
                        shape: BoxShape.circle,
                        cacheWidth: 80,
                        cacheHeight: 80,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      Expanded(
                        child: Text(
                          ctr.role.name ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AnimationProgress(
                    progress: progress,
                    height: 4,
                    borderRadius: 2,
                    width: 128,
                  ),
                  Row(
                    spacing: 4,
                    children: [
                      Text(
                        'Lv $level',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF85FFCD),
                        ),
                      ),
                      Text(
                        '$value%',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      Image.asset('assets/images/coins.png', width: 16),
                      Text(
                        rewards,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF85FFCD),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
