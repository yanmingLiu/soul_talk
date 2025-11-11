import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'empty_view.dart';
import 'linked_list_controller.dart';

abstract class LinkedListView<T, C extends LikedListController<T>>
    extends StatefulWidget {
  const LinkedListView({
    super.key,
    this.emptyBuilder,
    this.enablePullRefresh = true,
    this.enableLoadMore = true,
    this.padding,
    this.cacheExtent,
    required this.controller,
  });

  final Widget Function(BuildContext context)? emptyBuilder;
  final bool enablePullRefresh;
  final bool enableLoadMore;
  final EdgeInsets? padding;
  final double? cacheExtent;

  final LikedListController<T> controller;

  /// 抽象方法：强制子类实现列表构建
  Widget buildList(BuildContext context, ScrollPhysics physics);

  @override
  State<LinkedListView<T, C>> createState() => _LinkedListViewState<T, C>();
}

class _LinkedListViewState<T, C extends LikedListController<T>>
    extends State<LinkedListView<T, C>> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.refreshController.callRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh.builder(
      controller: widget.controller.refreshController,
      onRefresh: widget.enablePullRefresh ? widget.controller.onRefresh : null,
      onLoad: widget.enableLoadMore ? widget.controller.onLoad : null,
      childBuilder: (context, physics) {
        return Obx(() {
          if (widget.controller.emptyType.value != null ||
              widget.controller.dataList.isEmpty) {
            return widget.emptyBuilder?.call(context) ??
                EmptyView(
                  type: widget.controller.emptyType.value!,
                  physics: physics,
                );
          }
          return widget.buildList(context, physics);
        });
      },
    );
  }
}
