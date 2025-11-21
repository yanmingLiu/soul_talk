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
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        leading: const NavBackBtn(color: Colors.black),
        actions: [
          VButton(
            onTap: () {
              controller.pushEditPage();
            },
            height: 28,
            type: ButtonType.border,
            borderColor: const Color(0xFF55CFDA),
            borderWidth: 1,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            borderRadius: BorderRadius.circular(8),
            child: Row(
              spacing: 4,
              children: [
                Image.asset('assets/images/add@3x.png', width: 16),
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
          const SizedBox(width: 12),
        ],
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Your Profile Mask',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Here you can set your own profile to achieve the desired chat effect. Please note that only one mask can be used in a chat, but you can open a new chat to use other cards.",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF595959),
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.maskList.isEmpty && controller.emptyType.value != null) {
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
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                border: Border.all(
                  color: isSelected ? const Color(0xFF55CFDA) : Colors.white,
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Gender.fromValue(
                            mask.gender,
                          ).color.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
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
                              Gender.fromValue(mask.gender).name,
                              style: TextStyle(
                                color: Gender.fromValue(mask.gender).color,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Image.asset('assets/images/edit@3x.png', width: 16),
                    ],
                  ),
                  Text(
                    mask.description ?? '',
                    style: const TextStyle(
                      color: Color(0xFF262626),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            PositionedDirectional(
              top: 0,
              end: 0,
              child: GestureDetector(
                child: Container(
                  width: 44,
                  height: 44,
                  color: Colors.transparent,
                ),
                onTap: () {
                  controller.pushEditPage(mask: mask);
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
