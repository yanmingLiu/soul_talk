import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/domain/value_objects/enums.dart';
import 'package:soul_talk/presentation/v000/v_button.dart';
import 'package:soul_talk/router/nav_to.dart';

class ChaterLockView extends StatelessWidget {
  const ChaterLockView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0x80000000),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          color: Colors.transparent,
          child: Stack(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Image.asset(
                          'assets/images/role_lock_bg.png',
                          fit: BoxFit.fill,
                          height: 180,
                          width: double.infinity,
                        ),
                      ),
                      Image.asset(
                        'assets/images/vip@3x.png',
                        fit: BoxFit.cover,
                        width: 90,
                      ),
                      const Positioned(
                        top: 36,
                        left: 20,
                        right: 60,
                        child: Text(
                          'Unlock Hot Roles!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.only(top: 80),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Become a premium to unlock hot roles and get unlimited chats.',
                              style: TextStyle(
                                color: Color(0xFF595959),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 20),
                            VButton(
                              color: const Color(0xFFDF78B1),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Unlock Now',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                NTO.pushVip(VipSF.viprole);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                top: 0,
                child: SafeArea(
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      color: Colors.transparent,
                      width: 60,
                      height: 44,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
