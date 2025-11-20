import 'dart:convert';
import 'dart:math';

var _random = Random();

extension ListKx<T> on List<T>? {
  T? get randomOrNull {
    if (this == null || this!.isEmpty) {
      return null;
    } else {
      return this![_random.nextInt(this!.length)];
    }
  }

  bool get isNullOrEmpty => this == null || this!.isEmpty;

  String? get toJsonString {
    if (this == null || this!.isEmpty) {
      return null;
    } else {
      try {
        return jsonEncode(this);
      } catch (e) {
        e.toString();
      }
      return null;
    }
  }
}

String numFixed(dynamic nums, {int position = 2}) {
  double num = nums is double ? nums : double.parse(nums.toString());
  String numString = num.toStringAsFixed(position);

  return numString.endsWith('.0') ? numString.substring(0, numString.lastIndexOf('.')) : numString;
}

String formatVideoDuration(int seconds) {
  // 计算小时、分钟、秒
  final hours = seconds ~/ 3600;
  final minutes = (seconds % 3600) ~/ 60;
  final secs = seconds % 60;

  // 格式化成视频时长格式
  if (hours > 0) {
    // 如果时长包含小时，则显示 HH:mm:ss
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  } else {
    // 如果时长不足一小时，则显示 mm:ss
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
