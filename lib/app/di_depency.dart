import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/core/config/evn.dart';
import 'package:soul_talk/core/network/dio_client.dart';
import 'package:soul_talk/core/network/net_ob.dart';
import 'package:soul_talk/core/storage/l_db.dart';
import 'package:soul_talk/utils/crypto_util.dart';

import '../core/services/audio_player_service.dart';
import '../core/services/login_service.dart';
import '../core/services/trade_service.dart';
import '../utils/info_utils.dart';

/// 依赖注入配置类
class DIDendency {
  DIDendency._();

  static bool _isInitialized = false;

  /// 初始化依赖注入
  ///
  /// 按照分层架构的原则初始化：
  /// 0. 环境配置（Environment Configuration）
  /// 1. 基础设施层（Infrastructure Layer）
  /// 2. 领域层（Domain Layer）
  /// 3. 应用层（Application Layer）
  /// 4. 第三方服务（Third Party Services）
  ///
  /// [env] 环境配置，默认为开发环境
  static Future<void> init({Environment env = Environment.dev}) async {
    if (_isInitialized) return;

    // ============ 环境配置 ============
    await _initEnvironment(env);

    // ============ 基础设施层 ============
    await _initInfrastructure();

    // ============ 应用层服务 ============
    await _initApplicationServices();

    // ============ 第三方服务 ============
    await _initThirdPartyServices();

    // ============ 延迟加载服务 ============
    _initLazyServices();

    _isInitialized = true;
  }

  /// 初始化环境配置和网络客户端
  static Future<void> _initEnvironment(Environment env) async {
    // 1. 加载环境配置
    await ENV.initialize(env);

    // 2. 初始化网络客户端
    DioClient.instance.init(baseUrl: ENV.baseUrl);
  }

  /// 初始化基础设施层
  /// 包含：存储、网络、本地化等底层服务
  static Future<void> _initInfrastructure() async {
    // 1. 存储服务
    final storage = LDB.instance;
    await storage.initialize();

    // 3. 网络监控服务
    final networkService = NetOB.instance;
    await networkService.initialize();
  }

  /// 初始化应用层服务
  static Future<void> _initApplicationServices() async {
    // 登录服务（依赖于 LocalStorage）
    await Get.putAsync<LoginService>(() async {
      final loginService = LoginService();
      return loginService;
    }, permanent: true);

    // 设置业务相关的全局请求头
    await _setupBusinessHeaders();
  }

  /// 设置业务相关的全局请求头
  /// 依赖于基础设施层的服务（storage, locale等）
  static Future<void> _setupBusinessHeaders() async {
    final storage = LDB.instance;

    // 获取设备ID
    final deviceId = await storage.getDeviceId();
    final encryptedDeviceId = CryptoUtil.encrypt(deviceId);

    // 获取应用版本
    final version = await InfoUtils.version();

    // 获取平台信息
    final platform = ENV.platform;

    // 批量设置全局请求头
    DioClient.instance.setHeaders({
      'platform': platform,
      // 'device-id': deviceId,
      'FOu2y3vkwV7kjcjl': encryptedDeviceId,
      'version': version,
      'lang': 'en',
    });
  }

  /// 初始化第三方服务
  /// 包含：Firebase、Adjust 等第三方 SDK
  static Future<void> _initThirdPartyServices() async {
    try {
      TradeService.init();
    } catch (e) {
      // 第三方服务初始化失败不应该阻塞应用启动
      debugPrint('[DI]: 第三方服务初始化失败，但不影响应用启动: $e');
    }
  }

  /// 初始化延迟加载服务
  /// 这些服务在首次使用时才会创建
  static void _initLazyServices() {
    Get.lazyPut<AudioPlayerService>(() => AudioPlayerService());
  }

  /// 重置所有依赖（主要用于测试）
  static Future<void> reset() async {
    await Get.deleteAll(force: true);
    _isInitialized = false;
  }
}

/// 依赖注入便捷访问类
/// 提供类型安全的服务访问
class DI {
  DI._();
  // 基础设施层
  static LDB get storage => LDB.instance;
  static NetOB get network => NetOB.instance;

  // 应用层
  static LoginService get login => Get.find<LoginService>();

  // 延迟加载
  static AudioPlayerService get audio => Get.find<AudioPlayerService>();

  // 单例服务
  static DioClient get dio => DioClient.instance;
}
