import 'package:soul_talk/core/data/ms_pi.dart';
import 'package:soul_talk/domain/entities/coversation.dart';
import 'package:soul_talk/presentation/v000/base_list_controller.dart';
import 'package:soul_talk/presentation/v000/empty_view.dart';
import 'package:soul_talk/router/nav_to.dart';

enum ChatTab { chatted, liked }

class ConverBloc extends BaseListController<Conversation> {
  @override
  Future<void> fetchData() async {
    try {
      final newRecords = await MsgApi.sessionList(page, size) ?? [];

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
  Future<void> onItemTap(Conversation session) async {
    NTO.pushChat(session.characterId);
  }
}
