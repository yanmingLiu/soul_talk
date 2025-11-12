import 'package:flutter/material.dart';
import 'package:soul_talk/domain/entities/figure.dart';
import 'package:soul_talk/presentation/ap/cc002/c/follow_bloc.dart';
import 'package:soul_talk/presentation/ap/cc002/v/v_i_conv.dart';
import 'package:soul_talk/presentation/v000/base_list_view.dart';

class FollowListView extends BaseListView<Figure, FollowBloc> {
  // 简化构造函数，只传递必要的controller
  const FollowListView({super.key, required super.controller});

  Widget buildItem(BuildContext context, Figure item) {
    return VIConvItem(
      avatar: item.avatar ?? '',
      name: item.name ?? '',
      updateTime: item.updateTime,
      lastMsg: item.lastMessage ?? '-',
      onTap: () => controller.onItemTap(item),
    );
  }

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
}
