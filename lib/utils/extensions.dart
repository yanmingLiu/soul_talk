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
