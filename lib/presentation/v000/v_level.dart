import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:soul_talk/presentation/ap/cc002/c/msg_bloc.dart';

class LevelDialog extends StatefulWidget {
  const LevelDialog({super.key});

  @override
  State<LevelDialog> createState() => _LevelDialogState();
}

class _LevelDialogState extends State<LevelDialog> {
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF00120A),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Level up Intimacy",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            children: datas
                .map((e) => _buildRow(e['icon'], e['text'], e['gems']))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String icon, String text, int gems) {
    final width = (MediaQuery.of(context).size.width - 100) / 2;
    return Container(
      padding: const EdgeInsets.all(12),
      width: width,
      height: width,
      child: Column(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(icon, style: const TextStyle(fontSize: 27)),
          Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/coins.png', width: 12),
              Text(
                "+ $gems",
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChatLevelUpDialog extends StatefulWidget {
  const ChatLevelUpDialog({super.key, required this.rewards});

  final int rewards;

  @override
  State<ChatLevelUpDialog> createState() => _ChatLevelUpDialogState();
}

class _ChatLevelUpDialogState extends State<ChatLevelUpDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isAnimationReady = false;

  @override
  void initState() {
    super.initState();

    // 初始化 AnimationController
    _controller = AnimationController(vsync: this);

    // 监听动画状态
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // 动画完成时的处理逻辑
        SmartDialog.dismiss();
      }
    });
  }

  void _startAnimation() {
    if (_isAnimationReady && _controller.duration != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        // 显示动画
        _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/json/up.json',
        controller: _controller,
        onLoaded: (composition) {
          // 设置动画时长
          _controller.duration = composition.duration;
          _isAnimationReady = true;
          _startAnimation();
        },
      ),
    );
  }
}
