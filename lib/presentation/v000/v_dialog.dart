import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:soul_talk/core/constants/vs.dart';
import 'package:soul_talk/presentation/v000/v_alert.dart';
import 'package:soul_talk/presentation/v000/v_button.dart';
import 'package:soul_talk/presentation/v000/v_reward.dart';
import 'package:soul_talk/presentation/v000/v_sheet.dart';

import 'v_level_sheet.dart';
import 'v_rate.dart';

class VDialog {
  VDialog._();

  static Future<void> dismiss({String? tag}) {
    return SmartDialog.dismiss(status: SmartStatus.dialog, tag: tag);
  }

  static Future<void> show({
    required Widget child,
    bool? clickMaskDismiss = false,
    String? tag,
    bool? showCloseButton = false,
  }) async {
    final completer = Completer<void>();

    SmartDialog.show(
      clickMaskDismiss: clickMaskDismiss,
      keepSingle: true,
      debounce: true,
      tag: tag,
      maskColor: Colors.black.withValues(alpha: 0.85),
      builder: (context) {
        if (showCloseButton == true) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            spacing: 20,
            children: [
              child,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [_buildCloseButton()],
              ),
            ],
          );
        } else {
          return child;
        }
      },
      onDismiss: () {
        completer.complete();
      },
    );

    await completer.future;
  }

  static Future<void> alert({
    String? title,
    String? message,
    Widget? messageWidget,
    bool? clickMaskDismiss = false,
    String? cancelText,
    String? confirmText,
    void Function()? onCancel,
    void Function()? onConfirm,
  }) async {
    return show(
      clickMaskDismiss: false,
      child: VAlert(
        title: title,
        message: message,
        messageWidget: messageWidget,
        cancelText: cancelText,
        confirmText: confirmText,
        onCancel: onCancel,
        onConfirm: onConfirm,
      ),
    );
  }

  static Future<void> sheet({bool? clickMaskDismiss = false}) async {
    return show(clickMaskDismiss: false, child: const VSheet());
  }

  // static Future input({
  //   String? title,
  //   String? message,
  //   String? hintText,
  //   Widget? messageWidget,
  //   bool? clickMaskDismiss = false,
  //   String? cancelText,
  //   String? confirmText,
  //   void Function()? onCancel,
  //   void Function()? onConfirm,
  //   FocusNode? focusNode, // FocusNode 参数
  //   TextEditingController? textEditingController, // TextEditingController 参数
  // }) async {
  //   final focusNode1 = focusNode ?? FocusNode();
  //   final textController1 = textEditingController ?? TextEditingController();

  //   return SmartDialog.show(
  //     clickMaskDismiss: clickMaskDismiss,
  //     useAnimation: false, // 关闭动画
  //     maskWidget: ClipPath(
  //       child: BackdropFilter(
  //         filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
  //         child: Container(color: Colors.black.withValues(alpha: 0.8)),
  //       ),
  //     ),
  //     builder: (context) {
  //       WidgetsBinding.instance.addPostFrameCallback((_) {
  //         // 在渲染完成之后调用焦点请求，确保键盘弹出
  //         focusNode1.requestFocus();
  //       });

  //       double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

  //       return AnimatedPadding(
  //         duration: const Duration(milliseconds: 150),
  //         curve: Curves.easeOut,
  //         padding: EdgeInsets.only(bottom: keyboardHeight),
  //         child: Material(
  //           type: MaterialType.transparency,
  //           child: Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 16),
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 Stack(
  //                   children: [
  //                     Container(
  //                       padding: const EdgeInsets.symmetric(
  //                         horizontal: 20,
  //                         vertical: 36,
  //                       ),
  //                       decoration: BoxDecoration(
  //                         color: const Color(0xFF00120A), // 对话框背景色
  //                         borderRadius: BorderRadius.circular(12),
  //                       ),
  //                       child: Column(
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: [
  //                           _buildText(title, 18, FontWeight.w600),
  //                           if (title?.isNotEmpty == true)
  //                             const SizedBox(height: 16),
  //                           _buildText(message, 14, FontWeight.w500),
  //                           if (messageWidget != null) messageWidget,
  //                           const SizedBox(height: 16),
  //                           Container(
  //                             height: 40,
  //                             margin: const EdgeInsets.symmetric(
  //                               horizontal: 16,
  //                             ),
  //                             padding: const EdgeInsets.symmetric(
  //                               horizontal: 16,
  //                             ),
  //                             decoration: BoxDecoration(
  //                               color: const Color(0x1AFFFFFF),
  //                               borderRadius: BorderRadius.circular(12),
  //                             ),
  //                             child: Center(
  //                               child: TextField(
  //                                 autofocus: true,
  //                                 textInputAction: TextInputAction.done,
  //                                 onEditingComplete: () {},
  //                                 minLines: 1,
  //                                 maxLength: 20,
  //                                 textAlign: TextAlign.center,
  //                                 style: const TextStyle(
  //                                   height: 1,
  //                                   color: Colors.white,
  //                                   fontSize: 14,
  //                                   fontWeight: FontWeight.w700,
  //                                 ),
  //                                 controller: textController1,
  //                                 decoration: InputDecoration(
  //                                   hintText: hintText ?? 'input',
  //                                   counterText: '', // 去掉字数显示
  //                                   hintStyle: const TextStyle(
  //                                     color: Color(0xFFB3B3B3),
  //                                   ),
  //                                   fillColor: Colors.transparent,
  //                                   border: InputBorder.none,
  //                                   filled: true,
  //                                   isDense: true,
  //                                 ),
  //                                 focusNode: focusNode1,
  //                               ),
  //                             ),
  //                           ),
  //                           const SizedBox(height: 32),
  //                           Row(
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             children: [
  //                               Expanded(
  //                                 child: VButton(
  //                                   onTap: onConfirm,
  //                                   height: 48,
  //                                   borderRadius: BorderRadius.circular(12),
  //                                   child: Center(
  //                                     child: Text(
  //                                       'Confirm',
  //                                       style: const TextStyle(
  //                                         color: Colors.black,
  //                                         fontSize: 16,
  //                                         fontWeight: FontWeight.w700,
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 20),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [_buildCloseButton()],
  //                 ),
  //                 const SizedBox(height: 20),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  static Widget _buildCloseButton({void Function()? onTap}) {
    return VButton(
      onTap: () {
        SmartDialog.dismiss();
        onTap?.call();
      },
      width: 44,
      height: 44,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: const Center(child: Icon(Icons.close, color: Colors.white)),
    );
  }

  // static Widget _buildText(
  //   String? text,
  //   double fontSize,
  //   FontWeight fontWeight,
  // ) {
  //   if (text?.isNotEmpty != true) return const SizedBox.shrink();
  //   return Text(
  //     text!,
  //     textAlign: TextAlign.center,
  //     style: TextStyle(
  //       color: Colors.white,
  //       fontSize: fontSize,
  //       fontWeight: fontWeight,
  //     ),
  //   );
  // }

  static Future showChatLevel() async {
    return VSheet.show(const VLevelSheet());
  }

  static bool _isChatLevelDialogVisible = false;

  static Future<void> showChatLevelUp(int rewards) async {
    // 防止重复弹出
    if (_isChatLevelDialogVisible) return;

    // 设置标记为显示中
    _isChatLevelDialogVisible = true;

    try {
      await _showLevelUpToast(rewards);
    } finally {
      _isChatLevelDialogVisible = false;
    }
  }

  static Future<void> _showLevelUpToast(int rewards) async {
    final completer = Completer<void>();

    SmartDialog.show(
      displayTime: const Duration(milliseconds: 1500),
      maskColor: Colors.transparent,
      clickMaskDismiss: false,
      onDismiss: () => completer.complete(),
      builder: (context) {
        return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8,
                  children: [
                    Image.asset('assets/images/diamond.png', width: 24),
                    Text(
                      '+ $rewards',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

    await completer.future;

    // await _showLevelUpDialog(rewards);
  }

  // static Future<void> _showLevelUpDialog(int rewards) async {
  //   await SmartDialog.show(
  //     tag: VS.chatLevelUpTag,
  //     clickMaskDismiss: false,
  //     maskColor: Colors.transparent,
  //     keepSingle: true,
  //     builder: (context) {
  //       return ChatLevelUpDialog(rewards: rewards);
  //     },
  //   );
  // }

  static Future showLoginReward() async {
    if (checkExist(VS.loginRewardTag)) {
      return;
    }
    return show(
      tag: VS.loginRewardTag,
      clickMaskDismiss: true,
      child: const VRewardView(),
    );
  }

  static bool rateLevel3Shoed = false;

  static bool rateCollectShowd = false;

  static void showRateUs(String msg) async {
    VDialog.show(
      clickMaskDismiss: false,
      child: VRateApp(msg: msg),
      tag: VS.rateUsTag,
    );
  }

  static bool checkExist(String tag) {
    return SmartDialog.checkExist(tag: tag);
  }

  static Future<void> showRechargeSuccess(int number) async {
    return VDialog.show(
      child: GestureDetector(
        onTap: () {
          VDialog.dismiss();
        },
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 200),
                child: Image.asset(
                  'assets/images/diamond22_bg@3x.png',
                  fit: BoxFit.cover,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  Text(
                    '+$number',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Gems',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      clickMaskDismiss: true,
      tag: VS.rechargeSuccTag,
    );
  }
}
