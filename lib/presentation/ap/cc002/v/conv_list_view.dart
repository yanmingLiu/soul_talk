import 'package:flutter/material.dart';
import 'package:soul_talk/domain/entities/coversation.dart';
import 'package:soul_talk/presentation/ap/cc002/c/conver_bloc.dart';
import 'package:soul_talk/presentation/ap/cc002/v/v_i_conv.dart';
import 'package:soul_talk/presentation/v000/base_list_view.dart';

class ConvListView extends BaseListView<Conversation, ConverBloc> {
  const ConvListView({super.key, required super.controller});

  @override
  Widget buildList(BuildContext context, ScrollPhysics physics) {
    return ListView.separated(
      physics: physics,
      padding: padding ?? const EdgeInsets.all(12),
      cacheExtent: cacheExtent,
      itemBuilder: (_, index) => buildItem(context, controller.dataList[index]),
      separatorBuilder: (_, index) => const SizedBox(height: 12),
      itemCount: controller.dataList.length,
    );
  }

  Widget buildItem(BuildContext context, Conversation item) {
    return VIConvItem(
      avatar: item.avatar ?? '',
      name: item.title ?? '',
      updateTime: item.updateTime,
      lastMsg: item.lastMessage ?? '-',
      onTap: () => controller.onItemTap(item),
    );
  }
}
