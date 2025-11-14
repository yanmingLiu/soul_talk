import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/app/di_depency.dart';
import 'package:soul_talk/core/data/ma_pi.dart';
import 'package:soul_talk/domain/entities/mask.dart';
import 'package:soul_talk/domain/value_objects/enums.dart';
import 'package:soul_talk/presentation/ap/cc002/c/msg_bloc.dart';
import 'package:soul_talk/presentation/v000/loading.dart';
import 'package:soul_talk/presentation/v000/toast.dart';
import 'package:soul_talk/presentation/v000/v_dialog.dart';
import 'package:soul_talk/router/nav_to.dart';

class DominoEditBloc extends GetxController {
  /// 页面常量定义
  static const int maxNameLength = 20;
  static const int maxDescriptionLength = 500;
  static const int maxOtherInfoLength = 500;
  static const int maxAge = 99999;

  // 文本控制器
  late final TextEditingController nameController;
  late final TextEditingController ageController;
  late final TextEditingController descriptionController;
  late final TextEditingController otherInfoController;

  // 响应式状态变量
  final RxInt nameLength = 0.obs;
  final RxInt descriptionLength = 0.obs;
  final RxInt otherInfoLength = 0.obs;
  final Rx<Gender?> selectedGender = Rx<Gender?>(null);
  final RxBool isChanged = false.obs;
  final RxBool isLoading = false.obs;

  // 编辑的聊天角色（新建时为null）
  Mask? chatMask;

  final msgCtr = Get.find<MsgBloc>();

  var title = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // 初始化文本控制器
    nameController = TextEditingController();
    ageController = TextEditingController();
    descriptionController = TextEditingController();
    otherInfoController = TextEditingController();

    // 设置监听器
    _setupTextListeners();

    // 初始化编辑数据
    _initializeEditData();
  }

  @override
  void onClose() {
    nameController.dispose();
    ageController.dispose();
    descriptionController.dispose();
    otherInfoController.dispose();
    super.onClose();
  }

  /// 设置文本监听器
  void _setupTextListeners() {
    nameController.addListener(() {
      nameLength.value = nameController.text.length;
      _updateChangeStatus();
    });

    descriptionController.addListener(() {
      descriptionLength.value = descriptionController.text.length;
      _updateChangeStatus();
    });

    otherInfoController.addListener(() {
      otherInfoLength.value = otherInfoController.text.length;
      _updateChangeStatus();
    });

    ageController.addListener(() {
      _updateChangeStatus();
    });
  }

  /// 更新变更状态
  void _updateChangeStatus() {
    if (chatMask == null) {
      // 新建模式：只要有内容就认为有变更
      isChanged.value =
          nameController.text.isNotEmpty ||
          ageController.text.isNotEmpty ||
          descriptionController.text.isNotEmpty ||
          otherInfoController.text.isNotEmpty ||
          selectedGender.value != null;
    } else {
      // 编辑模式：与原始数据比较
      isChanged.value =
          nameController.text != (chatMask?.profileName ?? '') ||
          ageController.text != (chatMask?.age?.toString() ?? '') ||
          descriptionController.text != (chatMask?.description ?? '') ||
          otherInfoController.text != (chatMask?.otherInfo ?? '') ||
          selectedGender.value?.code != chatMask?.gender;
    }
  }

  /// 初始化编辑数据
  void _initializeEditData() {
    chatMask = Get.arguments;

    title.value = 'Create Your Profile Mask';

    if (chatMask != null) {
      title.value = 'Edit Your Profile Mask';

      nameController.text = chatMask?.profileName ?? '';
      descriptionController.text = chatMask?.description ?? '';
      ageController.text = chatMask?.age == null
          ? ''
          : chatMask?.age.toString() ?? '';
      otherInfoController.text = chatMask?.otherInfo ?? '';
      selectedGender.value = Gender.values.firstWhereOrNull(
        (gender) => gender.code == chatMask?.gender,
      );

      // 更新字符计数
      nameLength.value = nameController.text.length;
      descriptionLength.value = descriptionController.text.length;
      otherInfoLength.value = otherInfoController.text.length;
    }

    // 初始状态下没有变更
    isChanged.value = false;
  }

  /// 选择性别
  void selectGender(Gender gender) {
    selectedGender.value = gender;
    _updateChangeStatus();
  }

  /// 验证表单数据
  String? _validateForm() {
    if (nameController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty ||
        selectedGender.value == null) {
      // return LocaleKeys.fill_required_info.tr;
      return "Please fill in the required information";
    }

    return null;
  }

  /// 显示错误提示
  void _showError(String message) {
    Toast.toast(message);
  }

  /// 保存角色信息
  Future<void> saveMask() async {
    // 验证表单
    final errorMessage = _validateForm();
    if (errorMessage != null) {
      _showError(errorMessage);
      return;
    }

    // 关闭键盘
    Get.focusScope?.unfocus();

    // 检查是否新建且余额不足
    if (chatMask == null) {
      final balance = DI.login.gemBalance.value;
      final profileChange = DI.login.configPrice?.profileChange ?? 5;
      if (balance < profileChange) {
        NTO.pushGem(ConsSF.mask);
        return;
      }
    }

    final isEditChoosed =
        chatMask != null && chatMask?.id == msgCtr.session.profileId;

    if (isEditChoosed && isChanged.value) {
      VDialog.alert(
        // message: LocaleKeys.edit_choose_mask.tr,
        // cancelText: LocaleKeys.cancel.tr,
        // confirmText: LocaleKeys.restart.tr,
        message:
            "This chat already has a mask loaded.You can restart a chat to use another mask.After restarting, the history will lose.",
        confirmText: 'Restart',
        onConfirm: () async {
          VDialog.dismiss();
          await _saveRequest();
        },
      );
    } else {
      await _saveRequest();
    }
  }

  /// 执行保存请求
  Future<void> _saveRequest() async {
    if (!isChanged.value) {
      Get.back();
      return;
    }

    isLoading.value = true;
    Loading.show();

    try {
      final success = await MaskApi.createOrUpdateMask(
        name: nameController.text.trim(),
        age: ageController.text.trim(),
        gender: selectedGender.value?.code ?? Gender.unknown.code,
        description: descriptionController.text.trim(),
        otherInfo: otherInfoController.text.trim(),
        id: chatMask?.id,
      );

      await DI.login.fetchUserInfo();

      if (success) {
        final isEditChoosed =
            chatMask != null && chatMask?.id == msgCtr.session.profileId;
        if (isEditChoosed) {
          final id = chatMask?.id;
          if (id != null) {
            await msgCtr.changeMask(id);
          }
        }
        Get.back();
      } else {
        // ToastWidget.toast(LocaleKeys.some_error_try_again.tr);
        Toast.toast("Hmm… we lost connection for a bit. Please try again!");
      }
    } catch (e) {
      // ToastWidget.toast(LocaleKeys.some_error_try_again.tr);
      Toast.toast("Hmm… we lost connection for a bit. Please try again!");
    } finally {
      isLoading.value = false;
      Loading.dismiss();
    }
  }

  /// 是否为编辑模式
  bool get isEditMode => chatMask != null;

  /// 获取创建成本
  int get createCost => DI.login.configPrice?.profileChange ?? 5;
}
