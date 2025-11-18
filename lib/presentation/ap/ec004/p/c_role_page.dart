import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/domain/entities/figure.dart';
import 'package:soul_talk/presentation/ap/ec004/v/v_c.dart';
import 'package:soul_talk/presentation/v000/nav_back_btn.dart';

class CRolePage extends StatefulWidget {
  const CRolePage({super.key});

  @override
  State<CRolePage> createState() => _CRolePageState();
}

class _CRolePageState extends State<CRolePage> {
  Figure? role;

  @override
  void initState() {
    super.initState();

    if (Get.arguments != null) {
      role = Get.arguments;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        leading: const NavBackBtn(color: Colors.black),
        title: const Text('Undress'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: VC(
          key: const ValueKey('page'),
          role: role,
          type: VCEnum.role,
        ),
      ),
    );
  }
}
