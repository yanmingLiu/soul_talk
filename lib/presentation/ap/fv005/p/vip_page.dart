import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/app/di_depency.dart';
import 'package:soul_talk/presentation/ap/fv005/c/vip_bloc.dart';
import 'package:soul_talk/presentation/ap/fv005/v/v_list.dart';
import 'package:soul_talk/presentation/ap/fv005/v/v_team.dart';
import 'package:soul_talk/presentation/ap/fv005/v/v_text_view.dart';
import 'package:soul_talk/presentation/v000/nav_back_btn.dart';
import 'package:soul_talk/utils/pay_utils.dart';

class VipPage extends GetView<VipController> {
  const VipPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(VipController());

    return Stack(
      children: [
        _buildBackground(),
        Scaffold(
          appBar: _buildAppBar(),
          body: _buildContent(context),
        ),
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0.0,
      backgroundColor: Colors.transparent,
      leading: Obx(
        () => controller.showBackButton.value
            ? const NavBackBtn(icon: 'assets/images/close@3x.png')
            : const SizedBox(),
      ),
      actions: [
        GestureDetector(
          onTap: () => PayUtils().restore(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 28,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(width: 1, color: const Color(0x80FFFFFF)),
                ),
                child: const Text(
                  'Restore',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFFFFFF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
      ],
    );
  }

  /// 构建背景
  Widget _buildBackground() {
    return Positioned.fill(
      child: Image.asset(
          DI.storage.isBest
              ? 'assets/images/x2@3x.png'
              : 'assets/images/x@3x.png',
          fit: BoxFit.cover),
    );
  }

  /// 构建内容
  Widget _buildContent(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final top = MediaQuery.of(context).padding.top;
    final bottom = MediaQuery.of(context).padding.bottom;
    double appBarHeight = AppBar().preferredSize.height; // 获取默认高度
    final minHeight = height - top - bottom - appBarHeight;

    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => VTextView(contentText: controller.contentText.value)),
            const SizedBox(height: 8),
            const SkuListWidget(),
            const SizedBox(height: 8),
            PrivacyView(
              type: !DI.storage.isBest
                  ? PolicyBottomType.vip2
                  : PolicyBottomType.vip1,
            ),
          ],
        ),
      ),
    );
  }
}
