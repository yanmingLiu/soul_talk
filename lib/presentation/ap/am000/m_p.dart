import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lazy_indexed_stack/flutter_lazy_indexed_stack.dart';
import 'package:soul_talk/presentation/ap/bh001/p/h_p_page.dart';
import 'package:soul_talk/presentation/ap/cc002/p/conver_page.dart';
import 'package:soul_talk/presentation/ap/dm003/profile_page.dart';
import 'package:soul_talk/presentation/ap/ec004/p/c_tab_page.dart';

import '../../../app/di_depency.dart';
import '../../../core/analytics/analytics_service.dart';
import '../../../utils/log_util.dart';
import '../../v000/k_a_w.dart';

enum MainTabBarIndex { home, ai, chat, me }

MainTabBarIndex mainTabIndex = MainTabBarIndex.home;

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> with WidgetsBindingObserver {
  late List<Widget> pages = <Widget>[];
  List<MainTabBarIndex> indexs = [];

  @override
  void initState() {
    // 注册监听器
    WidgetsBinding.instance.addObserver(this);

    pages = [
      const KeepAliveWrapper(child: HomePage()),
      if (DI.storage.isBest) const KeepAliveWrapper(child: CTabPage()),
      const KeepAliveWrapper(child: ConverPage()),
      const KeepAliveWrapper(child: ProfilePage()),
    ];

    indexs = [
      MainTabBarIndex.home,
      if (DI.storage.isBest) MainTabBarIndex.ai,
      MainTabBarIndex.chat,
      MainTabBarIndex.me
    ];

    super.initState();
  }

  @override
  void dispose() {
    // 移除监听器
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log.d('AppLifecycleState: $state');
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        Analytics().logSessionEvent();

        break;
      case AppLifecycleState.paused:
        DI.audio.stopAll();
        break;
      case AppLifecycleState.detached:
        break;
      default:
        break;
    }
  }

  void _onTapItem(MainTabBarIndex index) {
    mainTabIndex = index;
    setState(() {});

    DI.login.fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    final stackIndex = indexs.indexOf(mainTabIndex);

    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        extendBody: true,
        bottomNavigationBar: MainTabBar(onTapItem: (p0) => _onTapItem(p0)),
        body: LazyIndexedStack(index: stackIndex, children: pages),
      ),
    );
  }
}

class MainTabBar extends StatelessWidget {
  const MainTabBar({super.key, this.onTapItem});

  final void Function(MainTabBarIndex)? onTapItem;

  @override
  Widget build(BuildContext context) {
    const space = 12.0;
    final bottom = MediaQuery.of(context).padding.bottom;
    final height = kBottomNavigationBarHeight + bottom;
    final allWidth =
        MediaQuery.of(context).size.width - 12 * 2 - (space * MainTabBarIndex.values.length);

    final count = DI.storage.isBest ? 4 : 3;
    final itemWidth = allWidth / count;

    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ).copyWith(bottom: bottom),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFF2F9), Color(0xFFFFFFFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        spacing: space,
        children: [
          TabBarItem(
            itemWidth: itemWidth,
            index: MainTabBarIndex.home,
            title: 'Discover',
            icon: 'assets/images/tab_home_d.png',
            activeIcon: 'assets/images/tab_home_s.png',
            isActive: mainTabIndex == MainTabBarIndex.home,
            onTap: onTapItem,
          ),
          if (DI.storage.isBest)
            TabBarItem(
              itemWidth: itemWidth,
              index: MainTabBarIndex.ai,
              title: 'AI Photo',
              icon: 'assets/images/tab_c_d.png',
              activeIcon: 'assets/images/tab_c_s.png',
              isActive: mainTabIndex == MainTabBarIndex.ai,
              onTap: onTapItem,
            ),
          TabBarItem(
            itemWidth: itemWidth,
            index: MainTabBarIndex.chat,
            title: 'Chat',
            icon: 'assets/images/tab_chat_d.png',
            activeIcon: 'assets/images/tab_chat_s.png',
            isActive: mainTabIndex == MainTabBarIndex.chat,
            onTap: onTapItem,
          ),
          TabBarItem(
            itemWidth: itemWidth,
            index: MainTabBarIndex.me,
            title: 'Me',
            icon: 'assets/images/tab_me_d.png',
            activeIcon: 'assets/images/tab_me_s.png',
            isActive: mainTabIndex == MainTabBarIndex.me,
            onTap: onTapItem,
          ),
        ],
      ),
    );
  }
}

class TabBarItem extends StatelessWidget {
  const TabBarItem({
    super.key,
    required this.itemWidth,
    required this.index,
    required this.title,
    required this.isActive,
    this.onTap,
    required this.icon,
    required this.activeIcon,
  });

  final double itemWidth;
  final MainTabBarIndex index;
  final String title;
  final String icon;
  final String activeIcon;
  final bool isActive;
  final void Function(MainTabBarIndex)? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(index),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          spacing: 2,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(isActive ? activeIcon : icon, width: 22),
            if (isActive)
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
