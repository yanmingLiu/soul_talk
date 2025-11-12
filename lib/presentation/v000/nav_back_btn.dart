import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/presentation/v000/v_button.dart';

class NavBackBtn extends StatelessWidget {
  const NavBackBtn({super.key, this.color = Colors.white});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return VButton(
      child: Center(
        child: Image.asset('assets/images/back.png', width: 24, color: color),
      ),
      onTap: () => Get.back(),
    );
  }
}
