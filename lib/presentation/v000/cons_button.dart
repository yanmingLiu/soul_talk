import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/app/di_depency.dart';
import 'package:soul_talk/domain/value_objects/enums.dart';
import 'package:soul_talk/router/nav_to.dart';

class ConsButton extends StatelessWidget {
  const ConsButton({super.key, required this.from});

  final ConsSF from;

  void _onTap() {
    NTO.pushGem(from);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Color(0x80DF78B1), width: 1),
        ),
        child: Row(
          spacing: 2,
          children: [
            Image.asset('assets/images/diamond.png', width: 20),
            Obx(() {
              return Text(
                DI.login.gemBalance.value.toString(),
                style: TextStyle(
                  color: Color(0xFF434343),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
