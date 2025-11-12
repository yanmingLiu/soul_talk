import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:soul_talk/domain/entities/message.dart';
import 'package:soul_talk/presentation/ap/cc002/v/v_typing.dart';

class VSend extends StatelessWidget {
  const VSend({super.key, required this.msg});

  final Message msg;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final sendText = msg.question ?? '';
    final showLoading = _shouldShowLoadingIndicator();
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: isRTL
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        _buildMessageContainer(sendText, screenWidth, context),
        if (showLoading) _buildLoadingIndicator(context),
      ],
    );
  }

  /// 构建消息容器
  Widget _buildMessageContainer(
    String text,
    double screenWidth,
    BuildContext context,
  ) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Align(
      alignment: isRTL ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: const BoxDecoration(
          color: Color(0xFF38ADB7),
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        constraints: BoxConstraints(maxWidth: screenWidth * 0.8),
        child: RepaintBoundary(
          child: VTyping(text: text, isSend: false, isTypingAnimation: false),
        ),
      ),
    );
  }

  /// 判断是否显示加载指示器
  bool _shouldShowLoadingIndicator() {
    try {
      return msg.onAnswer == true;
    } catch (e) {
      debugPrint('[SendContainer] 检查加载状态失败: $e');
      return false;
    }
  }

  /// 构建加载指示器
  Widget _buildLoadingIndicator(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Align(
      alignment: isRTL ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: 64.0,
        height: 44.0,
        margin: const EdgeInsets.only(top: 16.0),
        decoration: const BoxDecoration(
          color: Color(0x801C1C1C),
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        child: Center(
          child: LoadingAnimationWidget.progressiveDots(
            color: const Color(0xFF55CFDA),
            size: 30.0,
          ),
        ),
      ),
    );
  }
}
