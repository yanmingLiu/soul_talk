import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:soul_talk/core/data/h_pi.dart';
import 'package:soul_talk/core/data/ms_pi.dart';
import 'package:soul_talk/core/network/net_ob.dart';
import 'package:soul_talk/domain/entities/post.dart';
import 'package:soul_talk/presentation/v000/empty_view.dart';
import 'package:soul_talk/router/nav_to.dart';

class HPostBlock extends GetxController {
  final EasyRefreshController rfctr = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  int page = 1;
  int size = 1000;
  List<Post> list = [];
  EmptyType? type = EmptyType.loading;
  bool isNoMoreData = false;

  @override
  void onClose() {
    rfctr.dispose();
    super.onClose();
  }

  Future<void> onRefresh() async {
    page = 1;
    await _fetchData();
    rfctr.finishRefresh();
    rfctr.resetFooter();
  }

  Future<void> onLoad() async {
    await _fetchData();
    rfctr.finishLoad(isNoMoreData ? IndicatorResult.noMore : IndicatorResult.none);
  }

  Future<List<Post>?> _fetchData() async {
    try {
      final records = await HomeApi.momensListPage(page: page, size: size) ?? [];
      type = records.isEmpty
          ? (NetOB.instance.isConnected == false ? EmptyType.noNetwork : EmptyType.noData)
          : type;
      isNoMoreData = records.length < size;

      if (page == 1) {
        list.clear();
      }

      type = null;
      list.addAll(records);
      page++;
      update();
      return records;
    } catch (e) {
      type = list.isEmpty
          ? (NetOB.instance.isConnected == false ? EmptyType.noNetwork : EmptyType.noData)
          : type;
      update();
      return null;
    }
  }

  void onItemClick(Post data) async {
    final chaterId = data.characterId;

    if (chaterId == null) {
      SmartDialog.showToast('No chaterId');
      return;
    }

    SmartDialog.showLoading();

    try {
      // 并行执行异步任务

      final (role, session) = await (
        HomeApi.loadRoleById(chaterId),
        MsgApi.addSession(chaterId),
      ).wait;

      SmartDialog.dismiss();

      if (role == null) {
        SmartDialog.showToast('No role');
        return;
      }
      if (session == null) {
        SmartDialog.showToast('No session');
        return;
      }

      NTO.pushChat(role.id);
    } catch (e) {
      // 捕获异常并提示用户
      SmartDialog.dismiss();
      SmartDialog.showToast('Failed to load data: $e');
    }
  }

  void onPlay(Post data) {
    var isVideo = data.cover != null && data.duration != null;
    var imgUrl = isVideo ? data.cover : data.media;

    if (isVideo) {
      if (data.media != null) {
        NTO.pushVideoPreview(data.media!);
      } else {
        SmartDialog.showToast('No video');
      }
    } else {
      NTO.pushImagePreview(imgUrl ?? '');
    }
  }
}
