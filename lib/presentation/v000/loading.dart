import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class Loading {
  Loading._();

  static Future show() {
    return SmartDialog.showLoading();
  }

  static Future dismiss() {
    return SmartDialog.dismiss(status: SmartStatus.loading);
  }

  static CupertinoActivityIndicator activityIndicator() {
    return const CupertinoActivityIndicator(
      radius: 16.0, // 指示器大小（默认10.0）
      color: Color(0xFFDF78B1), // 颜色（默认蓝色）
    );
  }
}
