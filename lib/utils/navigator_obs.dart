import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/router_report.dart';

///自定义这个关键类！！！！！！
class GetXRouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    RouterReportManager.reportCurrentRoute(route);
    NavigatorObs.instance.push(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) async {
    RouterReportManager.reportRouteDispose(route);
    NavigatorObs.instance.pop(route, previousRoute);
  }
}

class NavigatorObs {
  NavigatorObs._();

  static NavigatorObs? _instance;

  static NavigatorObs get instance => _instance ??= NavigatorObs._();

  /// 自定义的 RouteObserver，方便页面订阅
  final RouteObserver<ModalRoute<void>> observer =
      RouteObserver<ModalRoute<void>>();

  /// 路由栈队列
  final Queue<Route<dynamic>> routeQueue = DoubleLinkedQueue<Route<dynamic>>();

  /// 当前路由
  Route<dynamic>? curRoute;

  /// 添加路由到队列
  void push(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log(
      'Route pushed: route:${route.settings.name}, previousRoute:${previousRoute?.settings.name}',
    );
    routeQueue.add(route);
    curRoute = route; // Update current route
  }

  /// 从队列中移除路由
  void pop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log(
      'Route popped: route:${route.settings.name}, previousRoute:${previousRoute?.settings.name}',
    );
    routeQueue.remove(route);
    curRoute = previousRoute; // Update current route to previous route
  }

  /// 检查队列中是否包含某个页面
  bool containPage(String name) {
    for (var route in routeQueue) {
      if (route.settings.name == name) {
        return true;
      }
    }
    return false;
  }

  void log(String message) {
    // 可以替换为自己的日志工具
    debugPrint('[NavObs]: $message');
  }
}
