import 'package:dotted_border/dotted_border.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/domain/entities/mask.dart';
import 'package:soul_talk/domain/value_objects/enums.dart';
import 'package:soul_talk/presentation/ap/cc002/c/domino_bloc.dart';
import 'package:soul_talk/presentation/v000/empty_view.dart';
import 'package:soul_talk/presentation/v000/nav_back_btn.dart';
import 'package:soul_talk/presentation/v000/v_button.dart';
import 'package:soul_talk/presentation/v000/v_dialog.dart';

class DominoPage extends GetView<DominoBloc> {
  const DominoPage({super.key});

  void _handleChangeMask() async {
    if (controller.needConfirmChange) {
      VDialog.alert(
        message:
            "This chat already has a mask loaded. You can restart a chat to use another mask. After restarting, the history will lose.",
        onConfirm: () async {
          VDialog.dismiss();
          await controller.changeMask();
        },
      );
    } else {
      await controller.changeMask();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 初始化控制器
    Get.put(DominoBloc());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0.0,
        leadingWidth: 70,
        leading: const NavBackBtn(color: Colors.black),
        title: const Text(
          'Select Your Profile Mask',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: EasyRefresh.builder(
              controller: controller.refreshController,
              onRefresh: controller.onRefresh,
              onLoad: controller.onLoad,
              childBuilder: (context, physics) {
                return _buildContent(context, physics);
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFF2F9), Color(0xFFFFFFFF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: VButton(
                onTap: _handleChangeMask,
                color: const Color(0xFF55CFDA),
                child: const Center(
                  child: Text(
                    'Pick it',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建主要内容
  Widget _buildContent(BuildContext context, ScrollPhysics physics) {
    final bottom = MediaQuery.of(context).padding.bottom + 44;
    return SingleChildScrollView(
      physics: physics,
      padding: const EdgeInsets.all(16).copyWith(bottom: bottom),
      child: Column(
        children: [
          const Text(
            "Here you can set your own profile to achieve the desired chat effect. Please note that only one mask can be used in a chat, but you can open a new chat to use other cards.",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF4D4D4D),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              controller.pushEditPage();
            },
            child: DottedBorder(
              options: const RoundedRectDottedBorderOptions(
                color: Color(0x8000AB8E),
                strokeWidth: 1,
                dashPattern: [6, 6],
                radius: Radius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                child: Column(
                  spacing: 4,
                  children: [
                    Image.asset('assets/images/add@3x.png', width: 24),
                    const Text(
                      'Create',
                      style: TextStyle(
                        color: Color(0xFF00AB8E),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),
          Obx(() {
            if (controller.maskList.isEmpty &&
                controller.emptyType.value != null) {
              return SizedBox(
                width: double.infinity,
                height: 400,
                child: EmptyView(
                  type: controller.emptyType.value!,
                  paddingTop: 20,
                  physics: const NeverScrollableScrollPhysics(),
                  onReload: controller.emptyType.value == EmptyType.noNetwork
                      ? () => controller.refreshController.callRefresh()
                      : null,
                ),
              );
            }
            if (controller.maskList.isNotEmpty) {
              return _buildGridItems();
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  /// 构建网格项目列表
  Widget _buildGridItems() {
    return Obx(
      () => ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) {
          return _buildItem(controller.maskList[index]);
        },
        separatorBuilder: (_, idx) => const SizedBox(height: 16),
        itemCount: controller.maskList.length,
      ),
    );
  }

  /// 构建Mask项目
  Widget _buildItem(Mask mask) {
    return Obx(() {
      final isSelected = controller.selectedMask.value?.id == mask.id;
      return GestureDetector(
        onTap: () {
          controller.selectMask(mask);
        },
        child: Row(
          spacing: 8,
          children: [
            GestureDetector(
              onTap: () => controller.pushEditPage(mask: mask),
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Image.asset('assets/images/edit@3x.png', width: 24),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    margin: const EdgeInsets.only(top: 12),
                    width: double.infinity,
                    constraints: const BoxConstraints(minHeight: 44),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF00AB8E)
                            : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mask.description ?? '',
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.black,
                          border: Border.all(
                            color: const Color(0x33FFFFFF),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          spacing: 4,
                          children: [
                            Image.asset(
                              Gender.fromValue(mask.gender).icon,
                              color: Gender.fromValue(mask.gender).color,
                              width: 14,
                            ),
                            Text(
                              mask.profileName ?? '',
                              style: TextStyle(
                                fontSize: 10,
                                color: Gender.fromValue(mask.gender).color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
