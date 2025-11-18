import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/app/di_depency.dart';
import 'package:soul_talk/presentation/v000/v_button.dart';

class VCBottom extends StatelessWidget {
  const VCBottom({super.key, this.onTap, required this.isVideo});

  final void Function()? onTap;
  final bool isVideo;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF9F9F9),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: VButton(
        onTap: onTap,
        color: const Color(0xFF55CFDA),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 4,
            children: [
              Obx(() {
                var createImg = DI.login.imgCreationCount.value;
                var createVideo = DI.login.videoCreationCount.value;
                return Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: "Balance:",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const WidgetSpan(child: SizedBox(width: 4)),
                      TextSpan(
                        text: isVideo ? '$createVideo' : '$createImg',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const WidgetSpan(child: SizedBox(width: 4)),
                      TextSpan(
                        text: isVideo ? 'videos' : 'photos',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const Text(
                "Generate",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
