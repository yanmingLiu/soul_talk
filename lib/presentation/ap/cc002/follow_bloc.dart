import 'package:soul_talk/data/ms_pi.dart';
import 'package:soul_talk/domain/entities/figure.dart';
import 'package:soul_talk/presentation/v000/base_list_controller.dart';
import 'package:soul_talk/presentation/v000/empty_view.dart';
import 'package:soul_talk/router/app_routers.dart';

class FollowBloc extends BaseListController<Figure> {
  @override
  Future<void> fetchData() async {
    try {
      final res = await MsgApi.likedList(page, size);
      final newRecords = res ?? [];
      isNoMoreData = newRecords.length < size;
      if (page == 1) dataList.clear();
      dataList.addAll(newRecords);
      emptyType.value = dataList.isEmpty ? EmptyType.noData : null;
    } catch (e) {
      emptyType.value = dataList.isEmpty ? EmptyType.noData : null;
      if (page > 1) page--;
      rethrow;
    }
  }

  @override
  Future<void> onItemTap(Figure session) async {
    AppRoutes.pushChat(session.id);
  }
}
