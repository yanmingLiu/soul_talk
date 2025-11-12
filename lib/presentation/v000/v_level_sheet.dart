import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:soul_talk/presentation/ap/cc002/c/msg_bloc.dart';

class VLevelSheet extends StatefulWidget {
  const VLevelSheet({super.key});

  @override
  State<VLevelSheet> createState() => _VLevelSheetState();
}

class _VLevelSheetState extends State<VLevelSheet> {
  List<Map<String, dynamic>> datas = [];

  final ctr = Get.find<MsgBloc>();

  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<void> loadData() async {
    await ctr.loadChatLevel();
    setState(() {
      datas = ctr.chatLevelConfigs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Level up Intimacy",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF434343),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: datas.length,
          itemBuilder: (_, index) {
            final e = datas[index];
            return _buildRow(e['icon'], e['text'], e['gems']);
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 164.0 / 130.0,
          ),
        ),
      ],
    );
  }

  Widget _buildRow(String icon, String text, int gems) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x0FDF78FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        spacing: 12,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(icon, style: const TextStyle(fontSize: 27)),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF454545),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/diamond.png', width: 24),
              Text(
                "+$gems",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFDF78B1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// class ChatLevelUpDialog extends StatefulWidget {
//   const ChatLevelUpDialog({super.key, required this.rewards});

//   final int rewards;

//   @override
//   State<ChatLevelUpDialog> createState() => _ChatLevelUpDialogState();
// }

// class _ChatLevelUpDialogState extends State<ChatLevelUpDialog>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   bool _isAnimationReady = false;

//   @override
//   void initState() {
//     super.initState();

//     // 初始化 AnimationController
//     _controller = AnimationController(vsync: this);

//     // 监听动画状态
//     _controller.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         // 动画完成时的处理逻辑
//         SmartDialog.dismiss();
//       }
//     });
//   }

//   void _startAnimation() {
//     if (_isAnimationReady && _controller.duration != null) {
//       Future.delayed(const Duration(milliseconds: 500), () {
//         // 显示动画
//         _controller.forward();
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Lottie.asset(
//         'assets/json/up.json',
//         controller: _controller,
//         onLoaded: (composition) {
//           // 设置动画时长
//           _controller.duration = composition.duration;
//           _isAnimationReady = true;
//           _startAnimation();
//         },
//       ),
//     );
//   }
// }
