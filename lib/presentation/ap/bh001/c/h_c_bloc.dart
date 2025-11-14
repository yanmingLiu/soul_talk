import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/app/di_depency.dart';
import 'package:soul_talk/core/data/h_pi.dart';
import 'package:soul_talk/domain/entities/figure.dart';
import 'package:soul_talk/presentation/ap/bh001/c/h_a_c_bloc.dart';
import 'package:soul_talk/presentation/ap/bh001/c/h_bloc.dart';
import 'package:soul_talk/presentation/v000/empty_view.dart';
import 'package:soul_talk/presentation/v000/loading.dart';
import 'package:soul_talk/presentation/v000/v_dialog.dart';

class HomeChildBloc {
  HomeChildBloc(this.cate) {
    _initState();
  }

  final HCate cate;

  final EasyRefreshController refreshCtr = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  // 添加ScrollController来控制滚动位置
  final ScrollController scrollController = ScrollController();

  String? rendStyl;
  bool? videoChat;
  bool? genVideo;
  bool? genImg;
  bool? changeClothing;
  int page = 1;
  int size = 10;
  var list = <Figure>[].obs;

  Rx<EmptyType?> type = Rx<EmptyType?>(null);

  bool isNoMoreData = false;
  bool _isRefreshing = false;
  bool _isLoading = false;

  final ctr = Get.find<HomeBloc>();
  List<int> tagIds = [];

  void _initState() {
    ever(ctr.filterEvent, (event) {
      final tags = event.$1;
      if (ctr.categroy.value == ctr.categroy.value) {
        final ids = tags.map((e) => e.id!).toList();
        tagIds = ids;
        Loading.show();
        onRefresh();
      }
    });

    ever(ctr.followEvent, (even) {
      try {
        final e = even.$1;
        final id = even.$2;

        final index = list.indexWhere((element) => element.id == id);
        if (index != -1) {
          list[index].collect = e == FollowEvent.follow;
          list.refresh();
        }
      } catch (e) {
        debugPrint('[DiscoverChildController] : $e');
      }
    });
  }

  Future<void> onRefresh() async {
    if (_isRefreshing) return;
    _isRefreshing = true;

    try {
      page = 1;
      isNoMoreData = false;
      await _fetchData();

      // 刷新后滚动到顶部
      if (scrollController.hasClients) {
        await scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }

      await Future.delayed(const Duration(milliseconds: 50));
      refreshCtr.finishRefresh();
      refreshCtr.finishLoad(
        isNoMoreData ? IndicatorResult.noMore : IndicatorResult.none,
      );
    } finally {
      _isRefreshing = false;
    }
  }

  Future<void> onLoad() async {
    if (_isLoading) return;

    if (isNoMoreData) {
      refreshCtr.finishLoad(IndicatorResult.noMore);
      return;
    }

    _isLoading = true;

    try {
      page++;
      await _fetchData();

      await Future.delayed(const Duration(milliseconds: 50));
      refreshCtr.finishLoad(
        isNoMoreData ? IndicatorResult.noMore : IndicatorResult.none,
      );
    } catch (e) {
      page--;
      refreshCtr.finishLoad(IndicatorResult.fail);
    } finally {
      _isLoading = false;
    }
  }

  void onCollect(int index, Figure role) async {
    final chatId = role.id;
    if (chatId == null) {
      return;
    }
    if (role.collect == true) {
      final res = await HomeApi.cancelCollectRole(chatId);
      if (res) {
        role.collect = false;
        list.refresh();
      }
    } else {
      final res = await HomeApi.collectRole(chatId);
      if (res) {
        role.collect = true;
        list.refresh();

        if (VDialog.rateCollectShowd == false) {
          VDialog.showRateUs(
            "Hey, thanks for your likes! If you think we did a good job, please give us a good review to help us do better~ 😊",
          );
          VDialog.rateCollectShowd = true;
        }
      }
    }
  }

  Future<List<Figure>?> _fetchData() async {
    if (cate == HCate.realistic) {
      rendStyl = HCate.realistic.name.toUpperCase();
    } else if (cate == HCate.anime) {
      rendStyl = HCate.anime.name.toUpperCase();
    } else if (cate == HCate.video) {
      videoChat = true;
    } else if (cate == HCate.dressUp) {
      changeClothing = true;
    }

    final tags = ctr.selectTags;
    final ids = tags.map((e) => e.id!).toList();
    tagIds = ids;

    try {
      final res = await HomeApi.homeList(
        page: page,
        size: size,
        rendStyl: rendStyl,
        videoChat: videoChat,
        genImg: genImg,
        genVideo: genVideo,
        tags: tagIds,
        dress: changeClothing,
      );

      final records = res ?? [];

      isNoMoreData = (records.length) < size;

      if (page == 1) {
        list.clear();

        if (DI.login.vipStatus.value == false) {
          Get.find<AutoCallBloc>().onCall(records);
        }
      }

      type.value = list.isEmpty ? EmptyType.noData : null;
      list.addAll(records);
      return res;
    } catch (e) {
      type.value = list.isEmpty ? EmptyType.noData : null;

      return null;
    } finally {
      Loading.dismiss();
    }
  }

  // 添加dispose方法来释放ScrollController
  void dispose() {
    scrollController.dispose();
  }
}
