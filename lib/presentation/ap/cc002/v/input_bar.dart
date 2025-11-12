import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/app/di_depency.dart';
import 'package:soul_talk/core/analytics/analytics_service.dart';
import 'package:soul_talk/domain/value_objects/enums.dart';
import 'package:soul_talk/presentation/ap/cc002/c/msg_bloc.dart';
import 'package:soul_talk/presentation/ap/cc002/p/edit_screen.dart';
import 'package:soul_talk/presentation/ap/cc002/v/v_replay_sheet.dart';
import 'package:soul_talk/presentation/v000/toast.dart';
import 'package:soul_talk/presentation/v000/v_button.dart';
import 'package:soul_talk/presentation/v000/v_dialog.dart';
import 'package:soul_talk/router/nav_to.dart';
import 'package:soul_talk/utils/extensions.dart';

class InputBar extends StatefulWidget {
  const InputBar({super.key});

  @override
  State<InputBar> createState() => _InputBarState();
}

class _InputBarState extends State<InputBar> {
  late TextEditingController textEditingController;
  bool isSend = false;
  final FocusNode focusNode = FocusNode();
  final MsgBloc ctr = Get.find<MsgBloc>();

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    textEditingController.addListener(_onInputChange);
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.removeListener(_onInputChange);
    focusNode.dispose();
  }

  void firstClickChatInputBox() async {
    focusNode.unfocus();
    DI.storage.setFirstClickChatInputBox(false);
    setState(() {}); // 更新UI，移除覆盖层

    await VDialog.alert(
      message: 'Create a mask profile to interact with the character better',
      cancelText: 'Cancel',
      confirmText: 'Confirm',
      clickMaskDismiss: false,
      onConfirm: () {
        VDialog.dismiss();
        NTO.pushMask();
      },
    );
  }

  void _onInputChange() async {
    if (textEditingController.text.length > 500) {
      Toast.toast('Maximum input length: 500 characters');
      // 截断文本到500字符
      textEditingController.text = textEditingController.text.substring(0, 500);
      // 将光标移到文本末尾
      textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: textEditingController.text.length),
      );
    }
    isSend = textEditingController.text.isNotEmpty;
    setState(() {});
  }

  // 0  tease, 1 undress, 2 gift, 3 mask, 100 screen, 101 sortlong
  void onTapTag(int index) {
    if (index == 100) {
      editScene();
    } else if (index == 101) {
      // 聊天模型 chat_model short / long
      showChatModel();
    } else {
      final item = ctr.inputTags[index];
      final id = item['id'];

      if (id == 0) {
        List<String> list = item['list'];
        textEditingController.text = list.randomOrNull ?? '';
        onSend();
      } else if (id == 1) {
        // AppRoutes.pushUndr(ctr.role);
      } else if (id == 2) {
        // showGift();
      } else if (id == 3) {
        NTO.pushMask();
      } else {
        Toast.toast('Not support');
      }
    }
  }

  void editScene() {
    Get.bottomSheet(
      EditScreen(
        content: ctr.session.scene ?? '',
        onInputTextFinish: (v) {
          if (v == ctr.session.scene) {
            Get.back();
            return;
          }
          if (!DI.login.vipStatus.value) {
            NTO.pushVip(VipSF.scenario);
            return;
          }
          Get.back();
          ctr.editScene(v);
        },
        subtitle: Row(
          spacing: 4,
          children: [
            Text(
              'Edit scenario',
              style: const TextStyle(
                color: Color(0xFF434343),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      enableDrag: false, // 禁用底部表单拖拽，避免与文本选择冲突
      isScrollControlled: true,
      isDismissible: true,
      ignoreSafeArea: false,
    );
  }

  void showChatModel() {
    final isLong = ctr.session.chatModel == 'long';
    Get.bottomSheet(
      VReplaySheet(
        isLong: isLong,
        onTap: (bool v) {
          ctr.editChatMode(v);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0x00000000), Color(0xE6000000)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Obx(
        () => Column(
          children: [
            SizedBox(height: 8),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 80),
                      decoration: BoxDecoration(
                        color: Color(0x3D000000),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          width: 1.5,
                          color: Color(0x33FFFFFF),
                        ),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 12),
                          _buildSpecialButton(),
                          Flexible(child: _buildTextField()),
                          const SizedBox(width: 8),
                          VButton(
                            onTap: onSend,
                            child: Image.asset(
                              'assets/images/sent@3x.png',
                              width: 54,
                              height: 30,
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                      ),
                    ),
                  ),
                ),
                // 第一次使用时的覆盖层
                if (DI.storage.firstClickChatInputBox)
                  Positioned.fill(
                    child: GestureDetector(onTap: firstClickChatInputBox),
                  ),
              ],
            ),
            ctr.inputTags.isEmpty
                ? const SizedBox()
                : MsgInputButtons(
                    tags: ctr.inputTags.toList(),
                    onTap: onTapTag,
                  ),

            SizedBox(height: bottom > 0 ? bottom : 8),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      textInputAction: TextInputAction.send,
      onEditingComplete: onSend,
      minLines: 1,
      maxLines: null,
      style: const TextStyle(
        height: 1.2,
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      controller: textEditingController,
      enableInteractiveSelection: true, // 确保文本选择功能启用
      dragStartBehavior: DragStartBehavior.down, // 优化拖拽行为
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: 'Type here...',
        hintStyle: const TextStyle(
          color: Color(0x80FFFFFF),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        fillColor: Colors.transparent,
        border: InputBorder.none,
        filled: true,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      ),
      autofocus: false,
      focusNode: focusNode,
    );
  }

  void onSend() async {
    String content = textEditingController.text.trim();
    if (content.isNotEmpty) {
      focusNode.unfocus();
      ctr.sendMsg(content);
      textEditingController.clear();
    } else {
      textEditingController.clear();
      return;
    }
    logEvent('c_chat_send');
  }

  Widget _buildSpecialButton() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(focusNode);

        final text = textEditingController.text;
        final selection = textEditingController.selection;

        // Insert "**" at the current cursor position
        final newText = text.replaceRange(selection.start, selection.end, '**');

        // Update the text and set the cursor between the two asterisks
        textEditingController.value = TextEditingValue(
          text: newText,
          selection: TextSelection.fromPosition(
            TextPosition(offset: selection.start + 1),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.only(top: 4),
        width: 20,
        height: 32,
        child: const Center(
          child: Text(
            '*',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class MsgInputButtons extends StatelessWidget {
  const MsgInputButtons({super.key, required this.tags, required this.onTap});

  final List<dynamic> tags;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final item = tags[index];
                  int color = item['color'] ?? Colors.black;

                  return GestureDetector(
                    onTap: () => onTap(index),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            height: 26,
                            color: const Color(0x66000000),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              spacing: 2,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  item['icon'],
                                  width: 16,
                                  height: 16,
                                ),
                                Text(
                                  item['name'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(color),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemCount: tags.length,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              onTap(100);
            },
            child: Container(
              height: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Image.asset('assets/images/function@3x.png', width: 32),
            ),
          ),
          GestureDetector(
            onTap: () {
              onTap(101);
            },
            child: Container(
              height: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Image.asset('assets/images/switch@3x.png', width: 32),
            ),
          ),
        ],
      ),
    );
  }
}
