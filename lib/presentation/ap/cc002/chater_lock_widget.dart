import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/domain/value_objects/enums.dart';
import 'package:soul_talk/presentation/v000/button.dart';
import 'package:soul_talk/router/app_routers.dart';

class ChaterLockView extends StatelessWidget {
  const ChaterLockView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 32,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF333333),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Unlock Hot Roles!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Become a premium to unlock hot roles and get unlimited chats.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Button(
                      color: const Color(0xFF85FFCD),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Unlock Now',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            size: 16,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      onTap: () {
                        AppRoutes.pushVip(VipSF.viprole);
                      },
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
    );
  }
}
