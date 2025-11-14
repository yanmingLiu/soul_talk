import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/core/data/ma_pi.dart';
import 'package:soul_talk/domain/entities/mask.dart';
import 'package:soul_talk/presentation/ap/cc002/c/msg_bloc.dart';
import 'package:soul_talk/presentation/v000/empty_view.dart';
import 'package:soul_talk/router/route_constants.dart';

class DominoBloc extends GetxController {
  // 响应式状态变量
  final RxList<Mask> maskList = <Mask>[].obs;
  final Rx<Mask?> selectedMask = Rx<Mask?>(null);
  final RxBool hasMore = true.obs;
  final RxInt currentPage = 1.obs;
  final RxBool isLoading = false.obs;
  final Rx<EmptyType?> emptyType = Rx<EmptyType?>(EmptyType.loading);

  // 常量
  static const int pageSize = 10;

  // 控制器
  late final EasyRefreshController refreshController;
  final msgCtr = Get.find<MsgBloc>();

  @override
  void onInit() {
    super.onInit();
    refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );

    // 延迟触发刷新
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300)).then((_) {
        refreshController.callRefresh();
      });
    });
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  /// 下拉刷新
  Future<void> onRefresh() async {
    currentPage.value = 1;
    await _fetchData();
    refreshController.finishRefresh();
    refreshController.resetFooter();
  }

  /// 上拉加载更多
  Future<void> onLoad() async {
    currentPage.value += 1;
    await _fetchData();
    refreshController.finishLoad(
      hasMore.value ? IndicatorResult.none : IndicatorResult.noMore,
    );
  }

  /// 获取数据
  Future<void> _fetchData() async {
    if (isLoading.value) {
      return;
    }

    try {
      isLoading.value = true;
      final records = await MaskApi.getMaskList(
        page: currentPage.value,
        size: pageSize,
      );

      hasMore.value = (records?.length ?? 0) >= pageSize;

      if (currentPage.value == 1) {
        maskList.clear();
      }
      maskList.addAll(records ?? []);

      // 自动选择当前会话的 mask
      if (selectedMask.value == null &&
          maskList.isNotEmpty &&
          msgCtr.session.profileId != null) {
        selectedMask.value = maskList.firstWhereOrNull(
          (element) => element.id == msgCtr.session.profileId,
        );
      }

      emptyType.value = maskList.isEmpty ? EmptyType.noData : null;
    } catch (e) {
      emptyType.value = maskList.isEmpty ? EmptyType.noNetwork : null;
      if (currentPage.value > 1) {
        currentPage.value -= 1;
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// 选择 mask
  void selectMask(Mask mask) {
    selectedMask.value = mask;
  }

  /// 推送编辑页面
  Future<void> pushEditPage({Mask? mask}) async {
    await Get.toNamed(RouteConstants.maskEdit, arguments: mask);
    onRefresh();
  }

  /// 更换 mask
  Future<void> changeMask() async {
    final maskId = selectedMask.value?.id;
    if (maskId == null) {
      return;
    }

    if (maskId == msgCtr.session.profileId) {
      Get.back();
      return;
    }

    final res = await msgCtr.changeMask(maskId);
    if (res) {
      Get.back();
    }
  }

  /// 检查是否需要确认更换 mask
  bool get needConfirmChange {
    final maskId = selectedMask.value?.id;
    return maskId != null && msgCtr.session.profileId != maskId;
  }
}
