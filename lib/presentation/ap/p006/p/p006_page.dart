import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:soul_talk/domain/value_objects/enums.dart';
import 'package:soul_talk/presentation/ap/p006/c/p006_bloc.dart';
import 'package:soul_talk/presentation/ap/p006/v/p006_btn.dart';
import 'package:soul_talk/presentation/ap/p006/v/p006_title.dart';
import 'package:soul_talk/presentation/v000/nav_back_btn.dart';
import 'package:soul_talk/presentation/v000/v_image.dart';

class P006Page extends StatefulWidget {
  const P006Page({super.key});

  @override
  State<P006Page> createState() => _P006PageState();
}

class _P006PageState extends State<P006Page> with RouteAware {
  final ctr = Get.put(P006Bloc());

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          titleSpacing: 12,
          leadingWidth: 0.0,
          leading: null,
          automaticallyImplyLeading: false,
          title: Stack(
            alignment: Alignment.center,
            children: [
              P006Title(role: ctr.role, onTapClose: ctr.onTapHangup),
              Row(
                children: [
                  const NavBackBtn(icon: 'assets/images/close@3x.png'),
                  const Spacer(),
                  Obx(() => _buildTimer()),
                ],
              )
            ],
          ),
        ),
        body: SafeArea(bottom: false, child: _buildContainer()),
      ),
    );
  }

  Stack _buildContainer() {
    return Stack(
      children: [
        Positioned.fill(
          child: VImage(
            url: ctr.guideVideo?.gifUrl ?? ctr.role.avatar,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0x00000000), Color(0x80000000)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.7, 1.0],
              ),
            ),
          ),
        ),
        Column(
          children: [
            Expanded(child: Container()),
            Obx(() => _buildLoading()),
            Obx(() => _buildAnswering()),
            const SizedBox(height: 28),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _buildButtons(),
              ),
            ),
            const SizedBox(height: 46),
          ],
        ),
      ],
    );
  }

  Widget _buildLoading() {
    if (ctr.callState.value == CallState.calling ||
        ctr.callState.value == CallState.answering ||
        ctr.callState.value == CallState.listening) {
      return LoadingAnimationWidget.staggeredDotsWave(
        color: Colors.white,
        size: 40,
      );
    }
    return Container();
  }

  Widget _buildTimer() {
    if (ctr.showFormattedDuration.value) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: const Color(0x1FFFFFFF),
        ),
        child: Row(
          spacing: 8,
          children: [
            Image.asset(
              'assets/images/calling@3x.png',
              width: 12,
            ),
            Text(
              ctr.formattedDuration(ctr.callDuration.value),
              style: const TextStyle(
                color: Color(0xFF55CFDA),
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }

  Widget _buildAnswering() {
    final text = ctr.callStateDescription(ctr.callState.value);
    if (text.isEmpty) {
      return Container();
    }

    return SizedBox(
      width: Get.width - 60,
      child: Center(
        child: DefaultTextStyle(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          child: AnimatedTextKit(
            key: ValueKey(ctr.callState.value),
            totalRepeatCount: 1,
            animatedTexts: [
              TypewriterAnimatedText(
                text,
                speed: const Duration(milliseconds: 50),
                cursor: '',
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildButtons() {
    List<Widget> buttons = [
      P006Btn(icon: 'assets/images/hangup@3x.png', onTap: ctr.onTapHangup),
    ];

    if (ctr.callState.value == CallState.incoming) {
      buttons.add(
        P006Btn(
          icon: 'assets/images/answer@3x.png',
          onTap: ctr.onTapAccept,
        ),
      );
    }

    if (ctr.callState.value == CallState.listening) {
      buttons.add(
        P006Btn(
          icon: 'assets/images/micon.png',
          animationColor: const Color(0xFF88D04E),
          onTap: () => ctr.onTapMic(false),
        ),
      );
    }

    if (ctr.callState.value == CallState.answering ||
        ctr.callState.value == CallState.micOff ||
        ctr.callState.value == CallState.answered) {
      buttons.add(
        P006Btn(
          icon: 'assets/images/micoff.png',
          onTap: () => ctr.onTapMic(true),
        ),
      );
    }

    return buttons;
  }
}
