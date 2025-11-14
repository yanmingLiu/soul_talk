import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:soul_talk/domain/value_objects/enums.dart';
import 'package:soul_talk/presentation/ap/cc002/c/domino_edit_bloc.dart';
import 'package:soul_talk/presentation/v000/nav_back_btn.dart';
import 'package:soul_talk/presentation/v000/v_button.dart';

class DominoEditPasge extends GetView<DominoEditBloc> {
  static const double titleSpace = 8.0;
  static const double iconSize = 24.0;
  static const double genderIconSize = 16.0;

  const DominoEditPasge({super.key});

  @override
  Widget build(BuildContext context) {
    // 初始化控制器
    Get.put(DominoEditBloc());

    return GestureDetector(
      onTap: () {
        // 点击空白处关闭键盘
        Get.focusScope?.unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        appBar: _buildAppBar(),
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(child: _buildFormContent()),
              _buildBottomButton(context),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建应用栏
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      titleSpacing: 0.0,
      leadingWidth: 70,
      leading: const NavBackBtn(color: Colors.black),
      // title: Obx(() {
      //   return Text(
      //     controller.title.value,
      //     style: const TextStyle(
      //       color: Color(0xFF181818),
      //       fontSize: 16,
      //       fontWeight: FontWeight.w500,
      //     ),
      //   );
      // }),
    );
  }

  /// 构建表单内容
  Widget _buildFormContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 100),
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            return Text(
              controller.title.value,
              style: const TextStyle(
                color: Color(0xFF181818),
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            );
          }),
          _buildNameField(),
          _buildGenderField(),
          _buildAgeField(),
          _buildDescriptionField(),
          _buildOtherInfoField(),
        ],
      ),
    );
  }

  /// 构建姓名输入字段
  Widget _buildNameField() {
    return Column(
      spacing: DominoEditPasge.titleSpace,
      children: [
        Obx(
          () => _buildTitle(
            '* Your Name',
            subtitle:
                '(${controller.nameLength.value}/${DominoEditBloc.maxNameLength})',
          ),
        ),
        _buildTextFieldContainer(
          child: TextField(
            controller: controller.nameController,
            maxLength: DominoEditBloc.maxNameLength,
            inputFormatters: [_NoLeadingSpaceFormatter()],
            decoration: _buildInputDecoration(
              'The name that you want bots to call you',
            ),
            style: _buildTextStyle(),
          ),
        ),
      ],
    );
  }

  /// 构建性别选择字段
  Widget _buildGenderField() {
    return Column(
      spacing: DominoEditPasge.titleSpace,
      children: [
        _buildTitle('Your Gender'),
        Row(
          spacing: 8,
          children: [
            Expanded(child: _buildGenderOption(Gender.female)),
            Expanded(child: _buildGenderOption(Gender.male)),
            Expanded(child: _buildGenderOption(Gender.nonBinary)),
          ],
        ),
      ],
    );
  }

  /// 构建性别选项
  Widget _buildGenderOption(Gender gender) {
    return Obx(() {
      final isSelected = controller.selectedGender.value == gender;
      return GestureDetector(
        onTap: () {
          controller.selectGender(gender);
        },
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              width: 2,
              color: isSelected ? const Color(0xFF55CFDA) : Colors.white,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 4,
            children: [
              Image.asset(
                gender.icon,
                width: 12,
                color: isSelected ? gender.color : null,
              ),
              Text(
                gender.display,
                style: TextStyle(
                  color: gender.color,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  /// 构建年龄输入字段
  Widget _buildAgeField() {
    return Column(
      spacing: DominoEditPasge.titleSpace,
      children: [
        _buildTitle('Your Age', query: false),
        _buildTextFieldContainer(
          child: TextField(
            controller: controller.ageController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(5),
              _AgeInputFormatter(),
            ],
            decoration: _buildInputDecoration('Please enter your age'),
            style: _buildTextStyle(),
          ),
        ),
      ],
    );
  }

  /// 构建描述输入字段
  Widget _buildDescriptionField() {
    return Column(
      spacing: DominoEditPasge.titleSpace,
      children: [
        Obx(
          () => _buildTitle(
            'Description',
            subtitle:
                '(${controller.descriptionLength.value}/${DominoEditBloc.maxDescriptionLength})',
            query: true,
          ),
        ),
        _buildMultilineTextFieldContainer(
          child: TextField(
            controller: controller.descriptionController,
            maxLength: DominoEditBloc.maxDescriptionLength,
            maxLines: null,
            inputFormatters: [_NoLeadingSpaceFormatter()],
            decoration: _buildInputDecoration(
              'Like: What are your hobbies?\nDislike: What Is your dislike?\nWhat topics do you like to talk about?',
            ),
            style: _buildTextStyle(),
          ),
        ),
      ],
    );
  }

  /// 构建其他信息输入字段
  Widget _buildOtherInfoField() {
    return Column(
      spacing: DominoEditPasge.titleSpace,
      children: [
        Obx(
          () => _buildTitle(
            'Other info',
            subtitle:
                '(${controller.otherInfoLength.value}/${DominoEditBloc.maxOtherInfoLength})',
            query: false,
          ),
        ),
        _buildMultilineTextFieldContainer(
          child: TextField(
            controller: controller.otherInfoController,
            maxLength: DominoEditBloc.maxOtherInfoLength,
            maxLines: null,
            inputFormatters: [_NoLeadingSpaceFormatter()],
            decoration: _buildInputDecoration(
              'Your relationship with the character Or important events',
            ),
            style: _buildTextStyle(),
          ),
        ),
      ],
    );
  }

  /// 构建文本输入框容器
  Widget _buildTextFieldContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: child,
    );
  }

  /// 构建多行文本输入框容器
  Widget _buildMultilineTextFieldContainer({required Widget child}) {
    return Container(
      constraints: const BoxConstraints(minHeight: 88),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: child,
    );
  }

  /// 构建输入框装饰
  InputDecoration _buildInputDecoration(String hintText) {
    return InputDecoration(
      counterText: '',
      hintText: hintText,
      border: InputBorder.none,
      hintStyle: const TextStyle(color: Color(0xFFEAEAEA), fontSize: 14),
    );
  }

  /// 构建文本样式
  TextStyle _buildTextStyle() {
    return const TextStyle(
      color: Color(0xFF262626),
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );
  }

  /// 构建底部按钮
  Widget _buildBottomButton(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ).copyWith(bottom: context.mediaQueryPadding.bottom),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF2F9), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: VButton(
          onTap: controller.saveMask,
          color: const Color(0xFF55CFDA),
          child: !controller.isEditMode
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 4,
                  children: [
                    Image.asset('assets/images/diamond.png', width: 20),
                    Text(
                      '${controller.createCost}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'to creat',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildTitle(String title, {String? subtitle, bool query = true}) {
    return Row(
      spacing: 2,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF595959),
            fontWeight: FontWeight.w400,
          ),
        ),
        if (query)
          const Text(
            '*',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFE44341),
              fontWeight: FontWeight.w400,
            ),
          ),
        if (subtitle != null)
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF8C8C8C),
              fontWeight: FontWeight.w400,
            ),
          ),
      ],
    );
  }
}

class _AgeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final int? value = int.tryParse(newValue.text);
    if (value == null || value > 99999) {
      return oldValue;
    }

    return newValue;
  }
}

class _NoLeadingSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // 如果新值为空，直接返回
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // 只阻止第一个字符前面的空格
    // 如果文本以空格开头，且这是新输入的空格，则阻止
    if (newValue.text.startsWith(' ') && !oldValue.text.startsWith(' ')) {
      return oldValue;
    }

    return newValue;
  }
}
