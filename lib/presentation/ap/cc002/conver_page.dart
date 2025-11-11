import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/presentation/ap/cc002/conver_bloc.dart';
import 'package:soul_talk/presentation/ap/cc002/conver_list_view.dart';
import 'package:soul_talk/presentation/ap/cc002/fllow_list_view.dart';
import 'package:soul_talk/presentation/ap/cc002/follow_bloc.dart';
import 'package:soul_talk/presentation/v000/base_scaffold.dart';
import 'package:soul_talk/presentation/v000/button.dart';
import 'package:soul_talk/presentation/v000/keep_alive_wrapper.dart';
import 'package:soul_talk/presentation/v000/linked_controller.dart';
import 'package:soul_talk/presentation/v000/linked_item.dart';
import 'package:soul_talk/utils/navigator_obs.dart';

class ConverPage extends StatefulWidget {
  const ConverPage({super.key});

  @override
  State<ConverPage> createState() => _ConverPageState();
}

class _ConverPageState extends State<ConverPage> with RouteAware {
  final chatCtr = Get.put(ConverBloc());
  final likedCtr = Get.put(FollowBloc());

  final titles = ['Chat', 'Liked'];
  late LinkedController _linkedController;

  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();

    _linkedController = LinkedController(
      items: titles,
      onIndexChanged: (value) {
        if (value == 0) {
          chatCtr.onRefresh();
        } else {
          likedCtr.onRefresh();
        }
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 订阅路由观察者
    NavigatorObs.instance.observer.subscribe(this, ModalRoute.of(context)!);

    // 页面首次显示时刷新数据
    if (_isFirstLoad) {
      _isFirstLoad = false;
      refreshCurrentTab();
    }
  }

  @override
  void dispose() {
    // 取消订阅
    NavigatorObs.instance.observer.unsubscribe(this);
    super.dispose();
  }

  // 当页面重新显示时调用（从其他页面返回）
  @override
  void didPopNext() {
    refreshCurrentTab();
  }

  // 刷新当前选中的标签页
  void refreshCurrentTab() {
    if (_linkedController.index == 0) {
      chatCtr.onRefresh();
    } else {
      likedCtr.onRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: SafeArea(
        child: Column(
          children: [
            buildCategory(),
            Expanded(
              child: PageView(
                controller: _linkedController.pageController,
                pageSnapping: true,
                onPageChanged: (index) {
                  _linkedController.handlePageChanged(index);
                },
                physics: const BouncingScrollPhysics(),
                children: [
                  KeepAliveWrapper(
                    child: ConversationListView(controller: chatCtr),
                  ),
                  KeepAliveWrapper(child: FollowListView(controller: likedCtr)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCategory() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        spacing: 12,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [_buildItem(titles[0], 0), _buildItem(titles[1], 1)],
      ),
    );
  }

  Widget _buildItem(String title, int index) {
    return GestureDetector(
      child: AnimatedBuilder(
        animation: _linkedController,
        builder: (_, v) {
          return GestureDetector(
            child: AnimatedBuilder(
              animation: _linkedController,
              builder: (_, v) {
                final isActive = _linkedController.index == index;
                final icon = index == 1
                    ? Image.asset('assets/images/like_s.png', width: 16)
                    : null;

                return LinkedItem(
                  key: _linkedController.getTabKey(index),
                  title: title,
                  isActive: isActive,
                  indicatorHeight: 6,
                  textStyle: TextStyle(
                    color: const Color(0x80000000),
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                  activeTextStyle: TextStyle(
                    color: const Color(0xFFDF78B1),
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                  icon: icon,
                  onTap: () {
                    _linkedController.select(index);
                  },
                  animation: _linkedController,
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget buildTabItem({
    Key? key,
    required String title,
    required bool isActive,
    void Function()? onTap,
  }) {
    return Button(
      key: key,
      borderRadius: BorderRadius.circular(12),
      color: isActive ? Colors.black : Colors.white,
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      constraints: const BoxConstraints(minWidth: 100),
      child: Center(
        child: Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF727374),
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
