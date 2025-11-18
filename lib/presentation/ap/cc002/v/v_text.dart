import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/app/di_depency.dart';
import 'package:soul_talk/domain/entities/message.dart';
import 'package:soul_talk/domain/value_objects/enums.dart';
import 'package:soul_talk/presentation/ap/cc002/c/msg_bloc.dart';
import 'package:soul_talk/presentation/ap/cc002/p/edit_screen.dart';
import 'package:soul_talk/presentation/ap/cc002/v/v_rich_text.dart';
import 'package:soul_talk/presentation/ap/cc002/v/v_send.dart';
import 'package:soul_talk/presentation/ap/cc002/v/v_text_lock.dart';
import 'package:soul_talk/presentation/v000/v_button.dart';
import 'package:soul_talk/router/nav_to.dart';

/// 文本消息容器组件
class VText extends StatefulWidget {
  const VText({super.key, required this.msg, this.title});

  final Message msg;
  final String? title;

  @override
  State<VText> createState() => _VTextState();
}

class _VTextState extends State<VText> {
  static const Color _bgColor = Color(0x80000000);
  static const _borderRadius = BorderRadiusDirectional.only(
    topStart: Radius.circular(16.0),
    topEnd: Radius.circular(16.0),
    bottomEnd: Radius.circular(16.0),
  );

  late final MsgBloc _ctr;

  late final bool _isBig;

  @override
  void initState() {
    super.initState();
    _ctr = Get.find<MsgBloc>();
    _isBig = DI.storage.isBest;
  }

  @override
  Widget build(BuildContext context) {
    final msg = widget.msg;

    // 错误隔离设计：安全获取消息内容
    final sendText = _getSendTextSafely(msg);
    final receivText = _getReceiveTextSafely(msg);

    // 优化后的显示逻辑判断
    final shouldShowSend = _shouldShowSendMessage(msg, sendText);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (shouldShowSend)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: VSend(msg: widget.msg),
          ),
        if (receivText != null) _buildReceiveText(context),
      ],
    );
  }

  /// 错误隔离设计：安全获取发送文本
  String? _getSendTextSafely(Message msg) {
    try {
      return msg.question;
    } catch (e) {
      debugPrint('[TextContainer] 获取发送文本失败: $e');
      return null;
    }
  }

  /// 错误隔离设计：安全获取接收文本
  String? _getReceiveTextSafely(Message msg) {
    try {
      return msg.answer;
    } catch (e) {
      debugPrint('[TextContainer] 获取接收文本失败: $e');
      return null;
    }
  }

  /// 优化后的发送消息显示判断逻辑
  bool _shouldShowSendMessage(Message msg, String? sendText) {
    try {
      if (msg.source == MsgType.clothe) {
        return false;
      }

      return msg.source == MsgType.sendText ||
          (sendText != null && msg.onAnswer != true);
    } catch (e) {
      debugPrint('[TextContainer] 判断发送消息显示失败: $e');
      return false;
    }
  }

  Widget _buildReceiveText(BuildContext context) {
    return Obx(() {
      final isVip = _getVipStatusSafely();
      final isLocked = _isMessageLocked();

      if (!isVip && !isLocked) {
        return VTextLock(textContent: widget.msg.answer ?? '');
      }

      return _buildText(context);
    });
  }

  bool _getVipStatusSafely() {
    return DI.login.vipStatus.value;
  }

  bool _isMessageLocked() {
    return widget.msg.textLock == MsgLock.private.value;
  }

  Widget _buildText(BuildContext context) {
    final msg = widget.msg;

    final textContent = msg.translateAnswer ??
        msg.answer ??
        "Hmm… we lost connection for a bit. Please try again!";

    final maxWidth = MediaQuery.of(context).size.width * 0.8;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: const BoxDecoration(
            color: _bgColor,
            borderRadius: _borderRadius,
          ),
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.title != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    widget.title!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFDF78B1),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              VRichText(
                text: textContent,
                isSend: false,
                isTypingAnimation: msg.typewriterAnimated == true,
                onAnimationComplete: () => _handleAnimationComplete(msg),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        if (!_isTypingAnimationActive(msg))
          _buildActionButtons(
            msg: msg,
            showTranslate: false,
            showTransBtn: false,
          ),
      ],
    );
  }

  /// 处理打字动画完成事件
  void _handleAnimationComplete(Message msg) {
    try {
      if (msg.typewriterAnimated == true) {
        setState(() {
          msg.typewriterAnimated = false;
          _ctr.list.refresh();
        });
      }
    } catch (e) {
      debugPrint('[TextContainer] 处理动画完成失败: $e');
    }
  }

  /// 检查打字动画是否激活
  bool _isTypingAnimationActive(Message msg) {
    try {
      return msg.typewriterAnimated == true;
    } catch (e) {
      debugPrint('[TextContainer] 检查动画状态失败: $e');
      return false;
    }
  }

  /// 构建操作按钮行
  Widget _buildActionButtons({
    required Message msg,
    required bool showTranslate,
    required bool showTransBtn,
  }) {
    return Wrap(
      spacing: 16,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // 只有最后一条消息才显示消息操作按钮
        if (_isLastMessage(msg)) ..._buildMsgActions(msg),

        // 举报按钮（非大屏模式下显示）
        if (!_isBig) _buildReportButton(),
      ],
    );
  }

  /// 检查是否为最后一条消息
  bool _isLastMessage(Message msg) {
    try {
      return widget.msg == _ctr.list.lastOrNull;
    } catch (e) {
      debugPrint('[TextContainer] 检查最后消息失败: $e');
      return false;
    }
  }

  /// 构建举报按钮
  Widget _buildReportButton() {
    return VButton(
      width: 40.0,
      height: 32.0,
      onTap: NTO.report,
      child: Image.asset('assets/images/report@3x.png'),
    );
  }

  /// 构建消息操作按钮组
  List<Widget> _buildMsgActions(Message msg) {
    final hasEditAndRefresh = _hasEditAndRefreshActions(msg);

    return [
      // 续写按钮
      _buildContinueButton(),

      // 编辑和刷新按钮（仅特定消息类型）
      if (hasEditAndRefresh) ...[
        _buildEditButton(msg),
        _buildRefreshButton(msg),
      ],
    ];
  }

  /// 判断消息是否支持编辑和刷新操作
  bool _hasEditAndRefreshActions(Message msg) {
    try {
      return msg.source == MsgType.text ||
          msg.source == MsgType.video ||
          msg.source == MsgType.audio ||
          msg.source == MsgType.photo;
    } catch (e) {
      debugPrint('[TextContainer] 检查编辑刷新权限失败: $e');
      return false;
    }
  }

  /// 构建续写按钮
  Widget _buildContinueButton() {
    return RepaintBoundary(
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () => _handleContinueWriting(),
        child: Image.asset('assets/images/write@3x.png', width: 48, height: 32),
      ),
    );
  }

  /// 处理续写事件
  void _handleContinueWriting() {
    try {
      _ctr.continueWriting();
    } catch (e) {
      debugPrint('[TextContainer] 续写失败: $e');
    }
  }

  /// 构建编辑按钮
  Widget _buildEditButton(Message msg) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () => _handleEditMessage(msg),
      child: Image.asset('assets/images/msg_edit@3x.png', width: 32),
    );
  }

  /// 处理编辑消息事件
  void _handleEditMessage(Message msg) {
    try {
      Get.bottomSheet(
        EditScreen(
          content: msg.answer ?? '',
          onInputTextFinish: (value) {
            Get.back();
            _ctr.editMsg(value, msg);
          },
        ),
        enableDrag: false, // 禁用底部表单拖拽，避免与文本选择冲突
        isScrollControlled: true,
        isDismissible: true,
        ignoreSafeArea: false,
      );
    } catch (e) {
      debugPrint('[TextContainer] 编辑消息失败: $e');
    }
  }

  /// 构建刷新按钮
  Widget _buildRefreshButton(Message msg) {
    return RepaintBoundary(
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () => _handleResendMessage(msg),
        child: Image.asset('assets/images/retry@3x.png', width: 32),
      ),
    );
  }

  /// 处理重发消息事件
  void _handleResendMessage(Message msg) {
    try {
      _ctr.resendMsg(msg);
    } catch (e) {
      debugPrint('[TextContainer] 重发消息失败: $e');
    }
  }
}
