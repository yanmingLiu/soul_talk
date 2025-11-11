import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:soul_talk/core/config/evn.dart';

import '../../utils/log_util.dart';
import '../storage/l_db.dart';

/// 第三方服务管理类
/// 统一管理 Firebase、Adjust 等第三方 SDK 的初始化
class TradeService {
  TradeService._();

  // Remote Config 配置值
  static int maxFreeChatCount = 50;
  static int showClothingCount = 5;

  /// 初始化所有第三方服务
  static Future<void> init() async {
    // 使用 Future.wait 但不让任何一个服务的失败影响整体启动
    try {
      await Future.wait([_initFirebase(), _initAdjust()]);
    } catch (e) {
      log.e('[ThirdParty]:初始化失败，但不影响启动: $e');
    }
  }

  /// Adjust 初始化
  static Future<void> _initAdjust() async {
    try {
      final storage = LDB.instance;
      String deviceId = await storage.getDeviceId(isOrigin: true);
      String appToken = ENV.adjustId;
      AdjustEnvironment env = AdjustEnvironment.production;

      AdjustConfig config = AdjustConfig(appToken, env)
        ..logLevel = AdjustLogLevel.error
        ..externalDeviceId = deviceId;

      Adjust.initSdk(config);
      log.d('[Adjust]: initializing ✅');
    } catch (e) {
      log.e('[Adjust] catch: $e');
    }
  }

  /// Firebase 初始化
  static Future<void> _initFirebase() async {
    try {
      FirebaseApp app = await Firebase.initializeApp();
      log.d('[Firebase]: Initialized ✅ app: ${app.name}');

      // 分步初始化Firebase服务，确保核心服务先启动
      _initFirebaseAnalytics();
      _initRemoteConfig();
    } catch (e) {
      log.e('[Firebase]: 初始化失败 : $e');
      // 即使Firebase初始化失败，也不应该影响应用启动
      rethrow; // 重新抛出异常，让上层的 catchError 处理
    }
  }

  /// 初始化Firebase Analytics（核心服务）
  static Future<void> _initFirebaseAnalytics() async {
    try {
      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
      log.d('[Firebase]: Analytics initialized ✅');
    } catch (e) {
      log.e('[Firebase]: Analytics 初始化失败: $e');
    }
  }

  /// 初始化 Firebase Remote Config 服务
  static Future<void> _initRemoteConfig() async {
    try {
      // 设置 Remote Config 超时时间为 5 秒
      final remoteConfig = FirebaseRemoteConfig.instance;
      // 配置最小 fetch 时间，减少超时时间
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 3),
          minimumFetchInterval: const Duration(seconds: 30),
        ),
      );

      // 拉取 + 激活远程配置
      await remoteConfig.fetchAndActivate();

      // 获取配置值
      maxFreeChatCount = _getConfigValue(
        'free_chat_count',
        remoteConfig.getInt,
        50,
      );
      showClothingCount = _getConfigValue(
        'show_clothing_count',
        remoteConfig.getInt,
        5,
      );
    } catch (e) {
      log.e('[Firebase]: Remote Config 错误: $e');
      // 使用默认值，不影响应用启动
      maxFreeChatCount = 50;
      showClothingCount = 5;
      log.d('[Firebase]: 使用 Remote Config 默认值');
    }
  }

  /// 获取配置值
  static T _getConfigValue<T>(
    String key,
    T Function(String) fetcher,
    T defaultValue,
  ) {
    final value = fetcher(key);
    if ((value is String && value.isNotEmpty) || (value is int && value != 0)) {
      return value;
    }
    return defaultValue;
  }
}
