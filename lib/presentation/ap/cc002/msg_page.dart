import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/app/di_depency.dart';
import 'package:soul_talk/core/analytics/analytics_service.dart';
import 'package:soul_talk/domain/value_objects/enums.dart';
import 'package:soul_talk/presentation/ap/cc002/chater_lock_widget.dart';
import 'package:soul_talk/presentation/ap/cc002/float_item.dart';
import 'package:soul_talk/presentation/ap/cc002/image_album.dart';
import 'package:soul_talk/presentation/ap/cc002/input_bar.dart';
import 'package:soul_talk/presentation/ap/cc002/level_widget.dart';
import 'package:soul_talk/presentation/ap/cc002/msg_bloc.dart';
import 'package:soul_talk/presentation/ap/cc002/msg_list_view.dart';
import 'package:soul_talk/presentation/v000/toast.dart';
import 'package:soul_talk/presentation/v000/v_button.dart';
import 'package:soul_talk/presentation/v000/v_dialog.dart';
import 'package:soul_talk/presentation/v000/v_image.dart';
import 'package:soul_talk/router/app_routers.dart';
import 'package:soul_talk/utils/navigator_obs.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> with RouteAware {
  final ctr = Get.put(MsgBloc());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 订阅当前页面的路由事件
    NavigatorObs.instance.observer.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  dispose() {
    NavigatorObs.instance.observer.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPushNext() {
    DI.audio.stopAll();
  }

  @override
  void didPop() {
    DI.audio.stopAll();
  }

  @override
  Widget build(BuildContext context) {
    final role = ctr.role;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: VImage(url: ctr.session.background ?? role.avatar),
          ),
          if (DI.storage.chatBgImagePath.isNotEmpty)
            Positioned.fill(
              child: Image.file(
                File(DI.storage.chatBgImagePath),
                fit: BoxFit.cover,
              ),
            ),
          Scaffold(
            appBar: _buildAppBar(),
            extendBodyBehindAppBar: true,
            extendBody: true,
            backgroundColor: Colors.transparent,
            body: const Column(
              children: [
                Expanded(child: MessageListWidget()),
                InputBar(),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: kToolbarHeight,
            child: SafeArea(
              child: Column(
                spacing: 8,
                children: [
                  const ImageAlbum(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        if (DI.storage.isBest)
                          FloatItem(role: role, sessionId: ctr.sessionId ?? 0),
                        const Spacer(),
                        const LevelWidget(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(() {
            final vip = DI.login.vipStatus.value;
            if (role.vip == true && !vip) {
              return const Positioned.fill(child: ChaterLockView());
            }
            return const SizedBox();
          }),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      titleSpacing: 0.0,
      leadingWidth: 48,
      leading: VButton(
        width: 44,
        height: 44,
        color: Colors.transparent,
        onTap: () => Get.back(),
        child: Center(
          child: Image.asset('assets/images/msgbackbtn.png', width: 24),
        ),
      ),
      actions: [
        const SizedBox(width: 20),
        GestureDetector(
          onTap: () {
            VDialog.showChatLevel();
          },
          child: Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFF00AB8E),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Obx(() {
                var data = ctr.chatLevel.value;
                var level = data?.level ?? 1;
                final map = ctr.chatLevelConfigs.firstWhereOrNull(
                  (element) => element['level'] == level,
                );
                var levelStr = map?['icon'] as String?;
                return Text(
                  levelStr ?? '👋',
                  style: const TextStyle(fontSize: 17),
                );
              }),
            ),
          ),
        ),
        if (DI.storage.isBest)
          IconButton(
            onPressed: () {
              logEvent('c_call');
              if (!DI.login.vipStatus.value) {
                AppRoutes.pushVip(VipSF.call);
                return;
              }

              if (!DI.login.checkBalance(ConsSF.call)) {
                AppRoutes.pushGem(ConsSF.call);
                return;
              }

              final sessionId = ctr.sessionId;
              if (sessionId == null) {
                Toast.toast('Please select a user to call.');
                return;
              }

              AppRoutes.pushPhone(
                sessionId: sessionId,
                role: ctr.role,
                showVideo: false,
              );
            },
            icon: Image.asset('assets/images/phone.png', width: 28, height: 28),
          ),
        const SizedBox(width: 8),
        VButton(
          height: 24,
          color: const Color(0x801C1C1C),
          borderRadius: BorderRadius.circular(4),
          constraints: const BoxConstraints(minWidth: 44),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          onTap: () {
            AppRoutes.pushGem(ConsSF.chat);
          },
          child: Center(
            child: Row(
              spacing: 4,
              children: [
                Image.asset('assets/images/coins.png', width: 16, height: 16),
                Obx(
                  () => Text(
                    DI.login.gemBalance.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}
