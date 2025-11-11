import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lazy_indexed_stack/flutter_lazy_indexed_stack.dart';
import 'package:soul_talk/presentation/ap/bh001/h_p_page.dart';
import 'package:soul_talk/presentation/ap/cc002/conver_page.dart';
import 'package:soul_talk/presentation/ap/dm003/profile_page.dart';

import '../../../app/di_depency.dart';
import '../../../core/analytics/analytics_service.dart';
import '../../v000/keep_alive_wrapper.dart';

enum MainTabBarIndex { home, chat, me }

MainTabBarIndex mainTabIndex = MainTabBarIndex.home;

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> with WidgetsBindingObserver {
  late List<Widget> pages = <Widget>[];

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        DI.audio.stopAll();
        break;
      case AppLifecycleState.resumed:
        Analytics().logSessionEvent();
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    // 注册监听器
    WidgetsBinding.instance.addObserver(this);

    pages = [
      const KeepAliveWrapper(child: HomePage()),
      const KeepAliveWrapper(child: ConverPage()),
      // if (DI.storage.isBest) const KeepAliveWrapper(child: CreatePage()),
      const KeepAliveWrapper(child: ProfilePage()),
    ];
    super.initState();
  }

  @override
  void dispose() {
    // 移除监听器
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onTapItem(MainTabBarIndex index) {
    setState(() {
      mainTabIndex = index;
    });
    DI.login.fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        extendBody: true,
        bottomNavigationBar: MainTabBar(onTapItem: (p0) => _onTapItem(p0)),
        body: LazyIndexedStack(index: mainTabIndex.index, children: pages),
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
        MediaQuery.of(context).size.width -
        12 * 2 -
        (space * MainTabBarIndex.values.length);
    final itemWidth = allWidth / 3;

    return Container(
      height: height,
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ).copyWith(bottom: bottom),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFFFFF2F9), const Color(0xFFFFFFFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
        width: itemWidth,
        height: 44,
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
                style: TextStyle(
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
