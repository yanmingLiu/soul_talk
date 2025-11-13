import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/app/di_depency.dart';
import 'package:soul_talk/domain/entities/sku.dart';
import 'package:soul_talk/presentation/ap/fv005/c/vip_bloc.dart';
import 'package:soul_talk/presentation/ap/fv005/v/v_item.dart';
import 'package:soul_talk/presentation/ap/fv005/v/v_timer.dart';
import 'package:soul_talk/presentation/v000/v_button.dart';

class SkuListWidget extends StatelessWidget {
  const SkuListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = VipController.to;

    return Obx(() {
      final skuList = controller.skuList;

      if (skuList.isEmpty) {
        return _buildEmptyState();
      }

      return Column(
        spacing: 16,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildSkuList(controller, skuList),
          if (DI.storage.isBest) const VipTimer(),
          if (!DI.storage.isBest) _buildSubscriptionInfo(controller),
          _buildPurchaseButton(controller),
        ],
      );
    });
  }

  /// 构建空状态
  Widget _buildEmptyState() {
    return const Center(
      child: SizedBox(
        height: 100,
        child: Text(
          "No subscription available",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  /// 构建SKU列表
  Widget _buildSkuList(VipController controller, List<SKU> skuList) {
    return SizedBox(
      height: 118,
      child: ListView.separated(
        controller: controller.scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(), // 更好的滚动体验
        clipBehavior: Clip.none, // 允许内容超出边界显示
        itemBuilder: (_, index) {
          final sku = skuList[index];

          return _ResponsiveSkuItem(controller: controller, skuData: sku);
        },
        separatorBuilder: (_, index) => const SizedBox(width: 8),
        itemCount: skuList.length,
      ),
    );
  }

  /// 构建订阅信息（小版本）
  Widget _buildSubscriptionInfo(VipController controller) {
    return Container(
      constraints: const BoxConstraints(minHeight: 42),
      child: Obx(
        () => Text(
          controller.subscriptionDescription,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0x80FFFFFF),
            fontSize: 10,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }

  /// 构建购买按钮
  Widget _buildPurchaseButton(VipController controller) {
    return VButton(
      onTap: controller.purchaseSelectedProduct,
      color: const Color(0xFFDF78B1),
      child: Center(
        child: Text(
          DI.storage.isBest ? 'Continue' : 'Subscribe',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

/// 响应式SKU项组件，仅在选中状态变化时重建
class _ResponsiveSkuItem extends StatelessWidget {
  final VipController controller;
  final SKU skuData;

  const _ResponsiveSkuItem({required this.controller, required this.skuData});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.selectedProduct.value?.sku == skuData.sku;

      return SkuItemWidget(
        skuData: skuData,
        isSelected: isSelected,
        onTap: () => controller.selectProduct(skuData),
      );
    });
  }
}
