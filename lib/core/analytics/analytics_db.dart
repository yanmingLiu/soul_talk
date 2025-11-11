import 'dart:async';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'analytics_data.dart';

/// 日志数据库服务
class AnalyticsDB {
  static final AnalyticsDB _instance = AnalyticsDB._internal();
  AnalyticsDB._internal();
  static AnalyticsDB get instance => _instance;

  static Box<AnalyticsData>? _box;
  static const String _boxName = 'SECR4F92A7Z58';
  static int _sequenceCounter = 0;
  static int _lastTimestamp = 0;

  Future<Box<AnalyticsData>> get box async {
    if (_box != null) return _box!;
    _box = await _initBox();
    return _box!;
  }

  Future<Box<AnalyticsData>> _initBox() async {
    final appDocumentDir = await path_provider
        .getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(AnalyticsDataAdapter());
    }
    return await Hive.openBox<AnalyticsData>(_boxName);
  }

  /// 生成唯一的时间戳，确保严格递增
  int generateUniqueTimestamp() {
    final currentTimestamp = DateTime.now().millisecondsSinceEpoch;

    if (currentTimestamp > _lastTimestamp) {
      // 如果时间戳大于上次，重置序列号
      _lastTimestamp = currentTimestamp;
      _sequenceCounter = 0;
      return currentTimestamp;
    } else {
      // 如果时间戳相同或更小，则使用上次时间戳+递增序列号
      _sequenceCounter++;
      final uniqueTimestamp = _lastTimestamp + _sequenceCounter;
      return uniqueTimestamp;
    }
  }

  /// 获取当前序列号
  int get currentSequenceId => _sequenceCounter;

  Future<void> insertLog(AnalyticsData log) async {
    final box = await this.box;
    return await box.put(log.id, log);
  }

  Future<List<AnalyticsData>> getUnuploadedLogs({int limit = 10}) async {
    final box = await this.box;
    final unuploadedLogs = box.values.where((log) => !log.isUploaded).toList();
    // 按照createTime排序，确保上传顺序
    unuploadedLogs.sort((a, b) => a.createTime.compareTo(b.createTime));
    return unuploadedLogs.take(limit).toList();
  }

  Future<List<AnalyticsData>> getFailedLogs({int limit = 10}) async {
    final box = await this.box;
    final failedLogs = box.values.where((log) => !log.isSuccess).toList();
    // 按照createTime排序，确保重试顺序
    failedLogs.sort((a, b) => a.createTime.compareTo(b.createTime));
    return failedLogs.take(limit).toList();
  }

  Future<void> markLogsAsSuccess(List<AnalyticsData> logs) async {
    final box = await this.box;
    final now = DateTime.now().millisecondsSinceEpoch;
    try {
      for (final log in logs) {
        final updatedLog = AnalyticsData(
          id: log.id,
          eventType: log.eventType,
          data: log.data,
          isSuccess: true,
          createTime: log.createTime,
          uploadTime: now,
          isUploaded: true,
          sequenceId: log.sequenceId,
        );
        await box.put(log.id, updatedLog);
      }
    } catch (e) {
      throw Exception('Failed to update logs: $e');
    }
  }
}
