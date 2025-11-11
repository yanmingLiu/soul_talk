import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/app/di_depency.dart';
import 'package:soul_talk/domain/entities/figure.dart';
import 'package:soul_talk/presentation/ap/bh001/h_bloc.dart';
import 'package:soul_talk/presentation/ap/bh001/h_c_bloc.dart';
import 'package:soul_talk/presentation/ap/bh001/h_v_item.dart';
import 'package:soul_talk/presentation/v000/empty_view.dart';

class HomeListView extends StatefulWidget {
  const HomeListView({super.key, required this.cate, this.onTap});

  final HCate cate;
  final Function(Figure)? onTap;

  @override
  State<HomeListView> createState() => _HomeListViewState();
}

class _HomeListViewState extends State<HomeListView> {
  late final HomeChildBloc _controller;

  @override
  void initState() {
    super.initState();
    _controller = HomeChildBloc(widget.cate);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!DI.network.isConnected) {
        return;
      }
      _controller.refreshCtr.callRefresh();
    });
  }

  @override
  void dispose() {
    _controller.refreshCtr.dispose();
    _controller.dispose(); // 释放ScrollController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh.builder(
      controller: _controller.refreshCtr,
      onRefresh: _controller.onRefresh,
      onLoad: _controller.onLoad,
      childBuilder: (context, physics) {
        return Obx(() {
          final type = _controller.type.value;
          final list = _controller.list;
          if (type != null && list.isEmpty) {
            return EmptyView(type: _controller.type.value!, physics: physics);
          }
          return _buildAList(physics, list);
        });
      },
    );
  }

  Widget _buildAList(ScrollPhysics physics, List<Figure> list) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 172.0 / 280.0,
      ),
      itemCount: list.length,
      physics: physics,
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      itemBuilder: (context, index) {
        final role = list[index];
        return HomeItem(
          role: role,
          onCollect: (Figure role) {
            _controller.onCollect(index, role);
          },
          cate: widget.cate,
        );
      },
    );
  }
}
