import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/utils.dart';
import 'package:soul_talk/presentation/v000/base_scaffold.dart';
import 'package:soul_talk/presentation/v000/button.dart';

class VipPage extends StatelessWidget {
  const VipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('会员中心'),
            Image.asset('assets/images/star.png', width: 24),
            const Text('会员中心1'),
          ],
        ),
        leading: Button(
          child: Center(
            child: Image.asset('assets/images/back.png', width: 24),
          ),
          onTap: () => Get.back(),
        ),
      ),
      body: Container(),
    );
  }
}
