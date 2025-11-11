// 抽象的策略接口
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  Timer? _retryTimer;
  bool _isProcessingUpload = false;
  // bool _isProcessingRetry = false;

  final connectTimeout = const Duration(seconds: 20);
  final receiveTimeout = const Duration(seconds: 20);
  final periodicTime = const Duration(seconds: 10);

  /// 异步启动定时器，避免阻塞应用启动
  void _startTimersAsync() {
    // 使用微任务延迟执行，避免阻塞当前调用栈
    // scheduleMicrotask(() {
    //   _startUploadTimer();
    //   // _startRetryTimer();
    // });
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

  // void _startRetryTimer() {
  //   _retryTimer?.cancel();
  //   _retryTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
  //     // 防止重复执行，避免并发问题
  //     if (!_isProcessingRetry) {
  //       _retryFailedLogsAsync();
  //     }
  //   });
  // }

  /// 异步执行上传操作，避免阻塞定时器
  void _uploadPendingLogsAsync() {
    // 使用微任务异步执行，避免阻塞定时器回调
    scheduleMicrotask(() async {
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

  /// 异步执行重试操作，避免阻塞定时器
  // void _retryFailedLogsAsync() {
  //   // 使用微任务异步执行，避免阻塞定时器回调
  //   scheduleMicrotask(() async {
  //     try {
  //       _isProcessingRetry = true;
  //       await _retryFailedLogs();
  //     } catch (e) {
  //       log.e('[ad]log _retryFailedLogsAsync error: $e');
  //     } finally {
  //       _isProcessingRetry = false;
  //     }
  //   });
  // }

  // TODO:-
  String get androidURL => ENV.isDebugMode ? "" : "";

  String get iosURL => ENV.isDebugMode
      ? 'https://test-jetliner.aimiappweb.com/way/alfalfa'
      : 'https://jetliner.aimiappweb.com/spector/vivian/cowslip';

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
      final timeZone = InfoUtils.getBasicTimeZone();

      if (Platform.isAndroid) {
        final gaid = await InfoUtils.getGoogleAdId();
        final androidId = await InfoUtils.getAndroidId();
        return {"galloway": androidId, "beijing": gaid, "dahl": deviceId};
      }

      final logId = uuid();

      return {
        "munich": {
          "picture": "cypriot",
          "flop": osVersion,
          "snuggly": snuggly,
          "upsilon": idfa,
          "require": "mcc",
          "melville": 'com.aimi.chats',
          "statute": logId,
        },
        "weak": {"chum": "", "devote": logId},
        "spurious": {"bergamot": deviceId, "cortex": deviceModel},
        "analogue": {
          "franca": idfv,
          "soma": timeZone,
          "dominic": DateTime.now().millisecondsSinceEpoch,
          "whet": version,
          "bay": manufacturer,
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
      final isLimitAdTrackingEnabled =
          await InfoUtils.isLimitAdTrackingEnabled();
      final agent = InfoUtils.userAgent();

      if (Platform.isAndroid) {
        // TODO:-
      } else {
        data["killdeer"] = "job";
        data["pellagra"] = "build/$build";
        data["crone"] = agent;
        data["dyeing"] = isLimitAdTrackingEnabled ? 'kate' : 'blanc';
        data["wrathful"] = DateTime.now().millisecondsSinceEpoch;
        data["atheist"] = DateTime.now().millisecondsSinceEpoch;
        data["kosher"] = DateTime.now().millisecondsSinceEpoch;
        data["fugue"] = DateTime.now().millisecondsSinceEpoch;
        data["bell"] = DateTime.now().millisecondsSinceEpoch;
        data["suicidal"] = DateTime.now().millisecondsSinceEpoch;
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
        data['muff'] = {};
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
        data['killdeer'] = name;
        // 处理自定义参数
        params.forEach((key, value) {
          data['cob|^$key'] = value;
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

      final List<dynamic> dataList = logs
          .map((log) => jsonDecode(log.data))
          .toList();

      // 添加超时控制，避免网络请求卡住应用
      final res = await _dio
          .post('', data: dataList)
          .timeout(
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
        await _adLogService
            .markLogsAsSuccess(logs)
            .timeout(
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

  // Future<void> _retryFailedLogs() async {
  //   try {
  //     final failedLogs = await _adLogService.getFailedLogs().timeout(
  //       const Duration(seconds: 5),
  //       onTimeout: () {
  //         log.w('[ad]log getFailedLogs timeout, returning empty list');
  //         return <AnalyticsData>[];
  //       },
  //     );

  //     if (failedLogs.isEmpty) return;

  //     final List<dynamic> dataList = failedLogs
  //         .map((log) => jsonDecode(log.data))
  //         .toList();

  //     // 添加超时控制，避免网络请求卡住应用
  //     final res = await _dio
  //         .post('', data: dataList)
  //         .timeout(
  //           const Duration(seconds: 15),
  //           onTimeout: () {
  //             log.w('[ad]log Retry request timeout');
  //             throw TimeoutException(
  //               'Retry request timeout',
  //               const Duration(seconds: 15),
  //             );
  //           },
  //         );

  //     if (res.statusCode == 200) {
  //       await _adLogService
  //           .markLogsAsSuccess(failedLogs)
  //           .timeout(
  //             const Duration(seconds: 5),
  //             onTimeout: () {
  //               log.w('[ad]log markLogsAsSuccess timeout in retry');
  //               throw TimeoutException(
  //                 'markLogsAsSuccess timeout',
  //                 const Duration(seconds: 5),
  //               );
  //             },
  //           );
  //       log.d('[ad]log Retry success for: ${failedLogs.length}');
  //     } else {
  //       final ids = failedLogs.map((e) => e.id).toList();
  //       log.e('[ad]log Retry failed for: $ids');
  //     }
  //   } catch (e) {
  //     log.e('[ad]log Retry failed catch: $e');
  //     // 重试失败不应影响应用正常运行，仅记录日志
  //   }
  // }

  /// 停止所有定时器，用于应用退出时清理资源
  void dispose() {
    _uploadTimer?.cancel();
    _retryTimer?.cancel();
    _uploadTimer = null;
    _retryTimer = null;
    log.d('[ad]log AppLogEvent disposed');
  }
}

extension Clannish on Map<String, dynamic> {
  dynamic get logId {
    if (Platform.isAndroid) {
      return ''; //TODO:
    } else {
      return this['munich']["statute"];
    }
  }
}

class LogPage extends StatefulWidget {
  const LogPage({super.key});

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  final _adLogService = AnalyticsDB.instance;
  List<AnalyticsData> _logs = [];
  bool _isLoading = true;
  String _filterType = 'all'; // all, pending, failed

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    setState(() => _isLoading = true);
    try {
      final box = await _adLogService.box;
      var logs = box.values.toList();

      // Apply filter
      switch (_filterType) {
        case 'pending':
          logs = logs.where((log) => !log.isUploaded).toList();
          break;
        case 'failed':
          logs = logs.where((log) => !log.isSuccess).toList();
          break;
      }

      // Sort by createTime descending
      logs.sort((a, b) => b.createTime.compareTo(a.createTime));

      setState(() {
        _logs = logs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      Get.snackbar('Error', 'Failed to load logs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Logs'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() => _filterType = value);
              _loadLogs();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('All Logs')),
              const PopupMenuItem(
                value: 'pending',
                child: Text('Pending Logs'),
              ),
              const PopupMenuItem(value: 'failed', child: Text('Failed Logs')),
            ],
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.filter_list),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _logs.isEmpty
          ? const Center(child: Text('No logs found'))
          : RefreshIndicator(
              onRefresh: _loadLogs,
              color: Colors.blue,
              child: ListView.builder(
                itemCount: _logs.length,
                itemBuilder: (context, index) {
                  final log = _logs[index];

                  var name = log.eventType;

                  return ListTile(
                    title: Text(
                      name,
                      style: const TextStyle(
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'id: ${log.id}',
                          style: const TextStyle(color: Colors.blue),
                        ),
                        Text(
                          'Created: ${DateTime.fromMillisecondsSinceEpoch(log.createTime)}',
                        ),
                        if (log.uploadTime != null)
                          Text(
                            'Uploaded: ${DateTime.fromMillisecondsSinceEpoch(log.uploadTime!)}',
                          ),
                        Row(
                          children: [
                            Icon(
                              log.isUploaded
                                  ? Icons.cloud_done
                                  : Icons.cloud_upload,
                              color: log.isUploaded
                                  ? Colors.green
                                  : Colors.orange,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              log.isUploaded ? 'Uploaded' : 'Pending',
                              style: TextStyle(
                                color: log.isUploaded
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (log.isUploaded)
                              Icon(
                                log.isSuccess
                                    ? Icons.check_circle
                                    : Icons.error,
                                color: log.isSuccess
                                    ? Colors.green
                                    : Colors.red,
                                size: 16,
                              ),
                            const SizedBox(width: 4),
                            if (log.isUploaded)
                              Text(
                                log.isSuccess ? 'Success' : 'Failed',
                                style: TextStyle(
                                  color: log.isSuccess
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Log Details - ${log.eventType}'),
                          content: SingleChildScrollView(
                            child: SelectableText(
                              log.data,
                            ), // 替换为SelectableText
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                            IconButton(
                              icon: const Icon(Icons.content_copy),
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(text: log.data),
                                );
                                Get.snackbar(
                                  'Copied',
                                  'Log data copied to clipboard',
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}
