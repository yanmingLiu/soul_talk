// 抽象的策略接口
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/core/config/evn.dart';
import 'package:uuid/v4.dart';

import '../../app/di_depency.dart';
import '../../utils/info_utils.dart';
import '../../utils/log_util.dart';
import 'analytics_data.dart';
import 'analytics_db.dart';

void logEvent(String name, {Map<String, Object>? parameters}) {
  try {
    log.d('[logEvent]: $name, $parameters');
    FirebaseAnalytics.instance.logEvent(name: name, parameters: parameters);
    Analytics().logCustomEvent(name: name, params: parameters ?? {});
  } catch (e) {
    log.e('FirebaseAnalytics: $e');
  }
}

class Analytics {
  static final Analytics _instance = Analytics._internal();

  factory Analytics() => _instance;

  Analytics._internal() {
    _startTimersAsync();
  }

  final _adLogService = AnalyticsDB.instance;
  Timer? _uploadTimer;
  bool _isProcessingUpload = false;

  final connectTimeout = const Duration(seconds: 20);
  final receiveTimeout = const Duration(seconds: 20);
  final periodicTime = const Duration(seconds: 10);

  /// 异步启动定时器，避免阻塞应用启动
  void _startTimersAsync() {
    // 延迟到下一个事件循环周期再启动定时器，避免占用微任务队列
    Future(() {
      _startUploadTimer();
    });
  }

  void _startUploadTimer() {
    _uploadTimer?.cancel();
    _uploadTimer = Timer.periodic(periodicTime, (timer) {
      // 防止重复执行，避免并发问题
      if (!_isProcessingUpload) {
        _uploadPendingLogsAsync();
      }
    });
  }

  /// 异步执行上传操作，避免阻塞定时器
  void _uploadPendingLogsAsync() {
    // 放到事件队列执行，避免把耗时工作塞到微任务队列中
    Future(() async {
      try {
        _isProcessingUpload = true;
        await _uploadPendingLogs();
      } catch (e) {
        log.e('[ad]log _uploadPendingLogsAsync error: $e');
      } finally {
        _isProcessingUpload = false;
      }
    });
  }

  // TODO:-
  String get androidURL => ENV.isDebugMode ? "" : "";

  String get iosURL => ENV.isDebugMode
      ? 'https://test-tome.soultalkweb.com/seville/approve/stricken'
      : 'https://tome.soultalkweb.com/abreact/spay/trend';

  late final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Platform.isAndroid ? androidURL : iosURL,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  String uuid() {
    String uuid = const UuidV4().generate();
    return uuid;
  }

  // 获取通用参数
  Future<Map<String, dynamic>?> _getCommonParams() async {
    try {
      final deviceId = await DI.storage.getDeviceId(isOrigin: true);
      final deviceModel = await InfoUtils.getDeviceModel();
      final manufacturer = await InfoUtils.getDeviceManufacturer();
      final idfv = await InfoUtils.getIdfv();
      final version = await InfoUtils.version();
      final osVersion = await InfoUtils.getOsVersion();
      final idfa = await InfoUtils.getIdfa();
      final snuggly = (Get.deviceLocale ?? const Locale('en_US')).toString();
      final logId = uuid();

      if (Platform.isAndroid) {
        // final gaid = await InfoUtils.getGoogleAdId();
        // final androidId = await InfoUtils.getAndroidId();
        return {};
      }

      return {
        "filet": {
          "decadent": ENV.bundleId,
          "quackery": version,
          "goal": logId,
          "acetate": deviceModel,
        },
        "lion": {
          "gauze": "vilify",
          "nickname": deviceId,
          "dell": DateTime.now().millisecondsSinceEpoch,
          "arab": manufacturer,
          "yourself": "Apple",
          "honey": osVersion,
          "frigga": "mcc",
          "purchase": snuggly,
          "porphyry": idfa,
          "vandal": idfv,
          "fermi": deviceId,
        },
      };
    } catch (e) {
      log.e('_getCommonParams error: $e');
      return null;
    }
  }

  Future<void> logInstallEvent() async {
    try {
      var data = await _getCommonParams() ?? {};

      final build = await InfoUtils.buildNumber();
      final isLimitAdTrackingEnabled = await InfoUtils.isLimitAdTrackingEnabled();
      final agent = InfoUtils.userAgent();

      if (Platform.isAndroid) {
        // TODO:-
      } else {
        data["jason"] = {
          "bistable": "build/$build",
          "dey": agent,
          "lady": isLimitAdTrackingEnabled ? 'skyline' : 'java',
          "thorax": DateTime.now().millisecondsSinceEpoch,
          "capuchin": DateTime.now().millisecondsSinceEpoch,
          "pottery": DateTime.now().millisecondsSinceEpoch,
          "quantico": DateTime.now().millisecondsSinceEpoch,
          "forgiven": DateTime.now().millisecondsSinceEpoch,
          "sadist": DateTime.now().millisecondsSinceEpoch,
        };
      }

      final uniqueTimestamp = _adLogService.generateUniqueTimestamp();

      final logModel = AnalyticsData(
        eventType: 'install',
        data: jsonEncode(data),
        createTime: uniqueTimestamp,
        id: data.logId,
        sequenceId: _adLogService.currentSequenceId,
      );
      await _adLogService.insertLog(logModel);
      log.d('[ad]log InstallEvent saved to database');
    } catch (e) {
      log.e('[ad]log logEvent error: $e');
    }
  }

  Future<void> logSessionEvent() async {
    try {
      var data = await _getCommonParams();

      if (data == null) {
        return;
      }

      if (Platform.isAndroid) {
        // TODO:-
      } else {
        data['truffle'] = {};
      }

      final uniqueTimestamp = _adLogService.generateUniqueTimestamp();
      final logModel = AnalyticsData(
        id: data.logId,
        eventType: 'session',
        data: jsonEncode(data),
        createTime: uniqueTimestamp,
        sequenceId: _adLogService.currentSequenceId,
      );
      await _adLogService.insertLog(logModel);
      log.d('[ad]log logSessionEvent saved to database');
    } catch (e) {
      log.e('logEvent error: $e');
    }
  }

  Future<void> logCustomEvent({
    required String name,
    required Map<String, dynamic> params,
  }) async {
    try {
      var data = await _getCommonParams();
      if (data == null) {
        return;
      }
      if (Platform.isAndroid) {
        // TODO:-
        // data['swarthy'] = name;
        // // 处理自定义参数
        // params.forEach((key, value) {
        //   data['$key@tung'] = value;
        // });
      } else if (Platform.isIOS) {
        data['pewter'] = name;
        // 处理自定义参数
        params.forEach((key, value) {
          data['plaid^$key'] = value;
        });
      }

      final uniqueTimestamp = _adLogService.generateUniqueTimestamp();
      final logModel = AnalyticsData(
        eventType: name,
        data: jsonEncode(data),
        createTime: uniqueTimestamp,
        id: data.logId,
        sequenceId: _adLogService.currentSequenceId,
      );
      await _adLogService.insertLog(logModel);
      log.d('[ad]log logCustomEvent saved to database');
    } catch (e) {
      log.e('[ad]log logCustomEvent error: $e');
    }
  }

  Future<void> _uploadPendingLogs() async {
    try {
      final logs = await _adLogService.getUnuploadedLogs().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          log.w('[ad]log getUnuploadedLogs timeout, returning empty list');
          return <AnalyticsData>[];
        },
      );

      if (logs.isEmpty) return;

      final List<dynamic> dataList = logs.map((log) => jsonDecode(log.data)).toList();

      // 添加超时控制，避免网络请求卡住应用
      final res = await _dio.post('', data: dataList).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          log.w('[ad]log Upload request timeout');
          throw TimeoutException(
            'Upload request timeout',
            const Duration(seconds: 15),
          );
        },
      );

      if (res.statusCode == 200) {
        await _adLogService.markLogsAsSuccess(logs).timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            log.w('[ad]log markLogsAsSuccess timeout');
            throw TimeoutException(
              'markLogsAsSuccess timeout',
              const Duration(seconds: 5),
            );
          },
        );
        log.d('[ad]log Batch upload success: ${logs.length} logs');
      } else {
        log.e('[ad]log Batch upload error: ${res.statusMessage}');
      }
    } catch (e) {
      log.e('[ad]log Batch upload catch: $e');
      // 网络错误不应影响应用正常运行，仅记录日志
    }
  }

  /// 停止所有定时器，用于应用退出时清理资源
  void dispose() {
    _uploadTimer?.cancel();
    _uploadTimer = null;
    log.d('[ad]log AppLogEvent disposed');
  }
}

extension Clannish on Map<String, dynamic> {
  dynamic get logId {
    if (Platform.isAndroid) {
      return ''; //TODO:
    } else {
      return this['filet']["goal"];
    }
  }
}
