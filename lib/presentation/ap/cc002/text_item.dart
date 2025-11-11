import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/app/di_depency.dart';
import 'package:soul_talk/domain/entities/message.dart';
import 'package:soul_talk/domain/value_objects/enums.dart';
import 'package:soul_talk/presentation/ap/cc002/message_edit_screen.dart';
import 'package:soul_talk/presentation/ap/cc002/msg_bloc.dart';
import 'package:soul_talk/presentation/ap/cc002/rich_text_itemd.dart';
import 'package:soul_talk/presentation/ap/cc002/send_item.dart';
import 'package:soul_talk/presentation/ap/cc002/text_lock_item.dart';
import 'package:soul_talk/presentation/v000/v_button.dart';
import 'package:soul_talk/router/app_routers.dart';

/// 文本消息容器组件
class TextItem extends StatefulWidget {
  const TextItem({super.key, required this.msg, this.title});

  final Message msg;
  final String? title;

  @override
  State<TextItem> createState() => _TextItemState();
}

class _TextItemState extends State<TextItem> {
  static const Color _bgColor = Color(0x801C1C1C);
  static const BorderRadius _borderRadius = BorderRadius.all(
    Radius.circular(16.0),
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
            child: SendItem(msg: widget.msg),
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

      if (!isVip && isLocked) {
        return TextLockItem(textContent: widget.msg.answer ?? '');
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

  /// 翻译显示逻辑配置
  (bool, bool, String) _calculateTranslationState(Message msg) {
    final hasTranslation =
        msg.translateAnswer != null && msg.translateAnswer!.isNotEmpty;
    final isAutoTranslateEnabled = DI.login.currentUser?.autoTranslate == true;
    final isEnglishLocale = Get.deviceLocale?.languageCode == 'en';
    final userRequestedTranslation = msg.showTranslate == true;

    // 错误隔离设计：安全获取原始内容
    final originalContent = msg.answer ?? '';
    final translatedContent = msg.translateAnswer ?? '';

    bool shouldShowTranslate = false;
    bool shouldShowTransBtn = true;
    String displayContent = originalContent;

    if (isAutoTranslateEnabled) {
      // 自动翻译模式
      shouldShowTransBtn = false;
      if (hasTranslation) {
        shouldShowTranslate = true;
        displayContent = translatedContent;
      } else {
        shouldShowTranslate = false;
        displayContent = originalContent;
      }
    } else {
      // 手动翻译模式
      if (isEnglishLocale) {
        // 英语环境下不显示翻译按钮
        shouldShowTransBtn = false;
      }

      if (userRequestedTranslation && hasTranslation) {
        shouldShowTranslate = true;
        displayContent = translatedContent;
      } else {
        shouldShowTranslate = false;
        displayContent = originalContent;
      }
    }

    return (shouldShowTranslate, shouldShowTransBtn, displayContent);
  }

  Widget _buildText(BuildContext context) {
    final msg = widget.msg;

    // 使用优化后的翻译状态计算逻辑
    final (showTranslate, showTransBtn, content) = _calculateTranslationState(
      msg,
    );

    // 性能优化：预计算屏幕宽度约束
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
                      color: Colors.red,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              RichTextItem(
                text: content,
                isSend: false,
                isTypingAnimation: msg.typewriterAnimated == true,
                onAnimationComplete: () => _handleAnimationComplete(msg),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        if (!_isTypingAnimationActive(msg))
          _buildActionButtons(
            msg: msg,
            showTranslate: showTranslate,
            showTransBtn: showTransBtn,
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

        // 翻译按钮
        if (showTransBtn) _buildTranslateButton(showTranslate),
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
      width: 24.0,
      height: 24.0,
      onTap: AppRoutes.report,
      child: Image.asset('assets/images/reportmsg.png'),
    );
  }

  /// 构建翻译按钮
  Widget _buildTranslateButton(bool showTranslate) {
    return RepaintBoundary(
      child: VButton(
        onTap: () => _handleTranslateMessage(),
        width: 24.0,
        height: 24.0,

        child: Image.asset(
          showTranslate
              ? 'assets/images/transed.png'
              : 'assets/images/trans.png',
          width: 24.0,
        ),
      ),
    );
  }

  /// 处理翻译消息事件
  void _handleTranslateMessage() {
    try {
      _ctr.translateMsg(widget.msg);
    } catch (e) {
      debugPrint('[TextContainer] 翻译消息失败: $e');
    }
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
        child: Image.asset(
          'assets/images/continuebtn.png',
          width: 48,
          height: 24,
        ),
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
      child: Image.asset('assets/images/editbtn.png', width: 24),
    );
  }

  /// 处理编辑消息事件
  void _handleEditMessage(Message msg) {
    try {
      Get.bottomSheet(
        MessageEditScreen(
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
        child: Image.asset('assets/images/rewrite.png', width: 24),
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
