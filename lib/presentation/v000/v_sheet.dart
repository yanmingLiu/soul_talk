import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/presentation/v000/v_button.dart';

class VSheet extends StatelessWidget {
  const VSheet({super.key, this.child});

  final Widget? child;

  static Future<T?> show<T>(
    Widget child, {
    bool isScrollControlled = true,
    bool enableDrag = true,
    bool isDismissible = true,
    Color? barrierColor,
  }) {
    return Get.bottomSheet<T>(
      VSheet(child: child),
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      barrierColor: barrierColor ?? const Color(0x66000000),
      backgroundColor: Colors.transparent,
    );
  }

  static void dismiss<T>({T? result}) {
    Get.back<T>(result: result);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            VButton(
              onTap: () => Get.back(),
              padding: const EdgeInsets.all(12),
              borderRadius: BorderRadius.circular(8),
              child: Center(
                child: Image.asset('assets/images/close@3x.png', width: 24),
              ),
            ),
          ],
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: const BoxDecoration(
            color: Color(0xFFF9F9F9),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              child ?? const SizedBox.shrink(),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ],
    );
  }
}
