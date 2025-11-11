import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

/// 全局网络监听服务
class NetOB {
  static final NetOB _instance = NetOB._internal();
  NetOB._internal();
  static NetOB get instance => _instance;

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  // 当前连接状态（响应式）
  final _connectionStatus = <ConnectivityResult>[].obs;

  /// 是否已连接网络
  bool get isConnected =>
      _connectionStatus.isNotEmpty &&
      !_connectionStatus.contains(ConnectivityResult.none);

  /// 是否为 WiFi
  bool get isWifi => _connectionStatus.contains(ConnectivityResult.wifi);

  /// 是否为移动网络
  bool get isMobile => _connectionStatus.contains(ConnectivityResult.mobile);

  /// 公开的初始化方法，供外部调用
  Future<void> initialize() async {
    await _checkConnectivity();
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      _connectionStatus.value = result;
    });
  }

  /// 检查网络连接
  Future<void> _checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _connectionStatus.clear();
    _connectionStatus.addAll(result);
  }

  /// 手动刷新网络状态
  Future<void> refreshStatus() async {
    await _checkConnectivity();
  }

  /// 在有网络时执行操作
  Future<T?> executeWithNetworkCheck<T>({
    required Future<T> Function() onConnected,
    Function()? onDisconnected,
  }) async {
    if (isConnected) {
      return await onConnected();
    } else {
      onDisconnected?.call();
      return null;
    }
  }

  /// 等待网络连接
  Future<bool> waitForConnection({
    Duration timeout = const Duration(seconds: 30),
  }) async {
    if (isConnected) return true;

    final completer = Completer<bool>();
    late StreamSubscription subscription;

    subscription = _connectivity.onConnectivityChanged.listen((result) {
      if (result.isNotEmpty && !result.contains(ConnectivityResult.none)) {
        if (!completer.isCompleted) {
          completer.complete(true);
          subscription.cancel();
        }
      }
    });

    Timer(timeout, () {
      if (!completer.isCompleted) {
        completer.complete(false);
        subscription.cancel();
      }
    });

    return completer.future;
  }
}
