import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class Toast {
  static Future<void> toast(String msg) async {
    await SmartDialog.showToast(
      '',
      displayType: SmartToastType.onlyRefresh,
      debounce: true,
      alignment: Alignment.center,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            msg,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        );
      },
    );
  }
}
