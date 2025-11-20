import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:soul_talk/app/di_depency.dart';
import 'package:soul_talk/presentation/ap/cc002/p/edit_screen.dart';
import 'package:soul_talk/presentation/ap/dm003/set_background_view.dart';
import 'package:soul_talk/presentation/v000/loading.dart';
import 'package:soul_talk/presentation/v000/toast.dart';
import 'package:soul_talk/presentation/v000/v_dialog.dart';
import 'package:soul_talk/utils/image_manager.dart';
import 'package:soul_talk/utils/info_utils.dart';

class SettingController extends GetxController {
  // final FocusNode _focusNode = FocusNode();
  // late TextEditingController _textEditingController;
  var version = ''.obs;
  var chatbgImagePath = ''.obs;
  var nickname = ''.obs;

  @override
  void onInit() {
    super.onInit();

    nickname.value = DI.login.currentUser?.nickname ?? '';

    _loadData();
  }

  void _loadData() async {
    final v = await InfoUtils.version();
    final n = await InfoUtils.buildNumber();
    version.value = '$v  $n';

    chatbgImagePath.value = DI.storage.chatBgImagePath;
  }

  void _editNameReq(String name) async {
    nickname.value = name;
    Loading.show();
    await DI.login.modifyUserNickname(nickname.value);
    await Loading.dismiss();
    VDialog.dismiss();
  }

  void changeNickName() {
    nickname.value = DI.login.currentUser?.nickname ?? '';
    // _textEditingController = TextEditingController(text: nickname.value);

    // VDialog.input(
    //   title: 'Your nickname',
    //   hintText: 'Input your nickname',
    //   focusNode: _focusNode,
    //   textEditingController: _textEditingController,
    //   onConfirm: () async {
    //     if (_textEditingController.text.trim().isEmpty) {
    //       Toast.toast('Input your nickname');
    //       return;
    //     }
    //     nickname.value = _textEditingController.text.trim();
    //     Loading.show();
    //     await DI.login.modifyUserNickname(nickname.value);
    //     await Loading.dismiss();
    //     VDialog.dismiss();
    //   },
    // );

    Get.bottomSheet(
      EditScreen(
        content: nickname.value,
        onInputTextFinish: (v) {
          if (v == nickname.value) {
            Get.back();
            return;
          }

          Get.back();
          _editNameReq(v);
        },
        hintText: 'Input your nickname',
        maxLenght: 20,
        subtitle: const Row(
          spacing: 4,
          children: [
            Text(
              'What should your AI girlfriend call you?',
              style: TextStyle(
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

  void resetChatBackground() async {
    await VDialog.dismiss();

    DI.storage.setChatBgImagePath('');
    chatbgImagePath.value = '';
  }

  void changeChatBackground() async {
    VDialog.show(
      child: SettingMessageBackground(
        onTapUpload: uploadImage,
        onTapUseChat: resetChatBackground,
        isUseChater: chatbgImagePath.isEmpty,
      ),
    );
  }

  void uploadImage() async {
    await VDialog.dismiss();

    var pickedFile = await ImageManager.pickImageFromGallery();

    if (pickedFile != null) {
      Loading.show();
      final directory = await getApplicationDocumentsDirectory();
      final fileName = path.basename(pickedFile.path);
      final cachedImagePath = path.join(directory.path, fileName);
      final File cachedImage = await File(
        pickedFile.path,
      ).copy(cachedImagePath);
      DI.storage.setChatBgImagePath(cachedImage.path);
      chatbgImagePath.value = cachedImage.path;
      await Future.delayed(const Duration(seconds: 2));
      Loading.dismiss();
      Toast.toast('Back updated successfully');
    }
  }
}
