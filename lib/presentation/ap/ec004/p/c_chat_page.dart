import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/domain/entities/figure.dart';
import 'package:soul_talk/presentation/ap/ec004/v/v_c.dart';
import 'package:soul_talk/presentation/v000/v_button.dart';

class CChatPage extends StatefulWidget {
  const CChatPage({super.key});

  @override
  State<CChatPage> createState() => _CChatPageState();
}

class _CChatPageState extends State<CChatPage> {
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
      appBar: AppBar(
        titleSpacing: 0.0,
        leadingWidth: 70,
        leading: Center(
          child: VButton(
            width: 44,
            height: 44,
            color: Colors.white,
            onTap: () => Get.back(),
            child: Center(
              child: Image.asset(
                'assets/images/navbackbtn.png',
                width: 24,
                color: Colors.black,
              ),
            ),
          ),
        ),
        title: const Text(
          'Undress',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
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
