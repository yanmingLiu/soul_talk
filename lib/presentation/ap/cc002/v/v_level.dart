import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/presentation/ap/cc002/c/msg_bloc.dart';
import 'package:soul_talk/presentation/v000/v_ani_progress.dart';
import 'package:soul_talk/router/nav_to.dart';

class VLevel extends StatelessWidget {
  const VLevel({super.key});

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
          NTO.pushProfile(ctr.role);
        },
        child: Container(
          width: 120,
          padding: const EdgeInsets.symmetric(vertical: 4),
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
                      Text(
                        'Lv $level',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFDF78B1),
                        ),
                      ),
                      Text(
                        '$value%',
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        rewards,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFDF78B1),
                        ),
                      ),
                      Image.asset('assets/images/diamond.png', width: 10),
                    ],
                  ),
                  AnimationProgress(
                    progress: progress,
                    height: 4,
                    borderRadius: 2,
                    width: 120,
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
