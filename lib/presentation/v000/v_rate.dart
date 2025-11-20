import 'package:flutter/material.dart';
import 'package:soul_talk/core/constants/vs.dart';
import 'package:soul_talk/presentation/v000/v_button.dart';
import 'package:soul_talk/router/nav_to.dart';

import 'v_dialog.dart';

class VRateApp extends StatelessWidget {
  const VRateApp({super.key, required this.msg});

  final String msg;

  void close() {
    VDialog.dismiss(tag: VS.rateUsTag);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
              ).copyWith(top: 46),
              child: Image.asset('assets/images/rateusbg.png'),
            ),
            Image.asset(
              'assets/images/rateusicon.png',
              width: 160,
              height: 180,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
              ).copyWith(top: 46),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 64,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Text(
                      'Help Us Grow',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 16),
                            VButton(
                              onTap: () {
                                NTO.openAppStoreReview();
                              },
                              color: const Color(0xFFDF78B1),
                              height: 48,
                              child: const Center(
                                child: Text(
                                  'Help SoulTalk',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            VButton(
                              type: ButtonType.border,
                              height: 48,
                              onTap: close,
                              borderColor: const Color(0xFF8C8C8C),
                              borderWidth: 2,
                              child: const Center(
                                child: Text(
                                  'Nope',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF595959),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
