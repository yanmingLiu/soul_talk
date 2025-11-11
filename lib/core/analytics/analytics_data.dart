import 'dart:convert';

import 'package:hive/hive.dart';

part 'analytics_data.g.dart';

@HiveType(typeId: 0)
class AnalyticsData extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String eventType;

  @HiveField(2)
  final String data;

  @HiveField(3)
  final bool isSuccess;

  @HiveField(4)
  final int createTime;

  @HiveField(5)
  final int? uploadTime;

  @HiveField(6)
  final bool isUploaded;

  @HiveField(7)
  final int sequenceId;

  AnalyticsData({
    required this.id,
    required this.eventType,
    required this.data,
    this.isSuccess = false,
    required this.createTime,
    this.uploadTime,
    this.isUploaded = false,
    required this.sequenceId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'event_type': eventType,
      'data': data,
      'is_success': isSuccess ? 1 : 0,
      'cibejf': createTime,
      'upload_time': uploadTime,
      'is_uploaded': isUploaded ? 1 : 0,
      'sequence_id': sequenceId,
    };
  }

  factory AnalyticsData.fromMap(Map<String, dynamic> map) {
    return AnalyticsData(
      id: map['id'],
      eventType: map['event_type'],
      data: map['data'],
      isSuccess: map['is_success'] == 1,
      createTime: map['create_time'],
      uploadTime: map['upload_time'],
      isUploaded: map['is_uploaded'] == 1,
      sequenceId: map['sequence_id'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AnalyticsData.fromJson(String source) =>
      AnalyticsData.fromMap(json.decode(source));
}
