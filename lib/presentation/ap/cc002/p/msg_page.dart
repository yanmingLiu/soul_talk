import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/app/di_depency.dart';
import 'package:soul_talk/core/analytics/analytics_service.dart';
import 'package:soul_talk/domain/value_objects/enums.dart';
import 'package:soul_talk/presentation/ap/cc002/c/msg_bloc.dart';
import 'package:soul_talk/presentation/ap/cc002/v/chater_lock_widget.dart';
import 'package:soul_talk/presentation/ap/cc002/v/float_item.dart';
import 'package:soul_talk/presentation/ap/cc002/v/image_album.dart';
import 'package:soul_talk/presentation/ap/cc002/v/input_bar.dart';
import 'package:soul_talk/presentation/ap/cc002/v/msg_list_view.dart';
import 'package:soul_talk/presentation/ap/cc002/v/v_level.dart';
import 'package:soul_talk/presentation/v000/nav_back_btn.dart';
import 'package:soul_talk/presentation/v000/toast.dart';
import 'package:soul_talk/presentation/v000/v_button.dart';
import 'package:soul_talk/presentation/v000/v_dialog.dart';
import 'package:soul_talk/presentation/v000/v_image.dart';
import 'package:soul_talk/router/nav_to.dart';
import 'package:soul_talk/utils/navigator_obs.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> with RouteAware {
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
          Container(color: const Color(0x33000000)),
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
              bottom: false,
              child: Column(
                children: [
                  const ImageAlbum(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        if (DI.storage.isBest)
                          FloatItem(role: role, sessionId: ctr.sessionId ?? 0),
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
      leadingWidth: 0,
      leading: const SizedBox(),
      centerTitle: false,
      titleSpacing: 12,
      title: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            children: [
              const NavBackBtn(),
              VButton(
                onTap: () {
                  NTO.pushProfile(ctr.role);
                },
                width: 80,
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        ctr.role.name ?? '',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  VDialog.showChatLevel();
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(
                      colors: [Color(0x88501E3A), Color(0x88000000)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
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

              if (DI.storage.isBest) ...[
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    logEvent('c_call');
                    if (!DI.login.vipStatus.value) {
                      NTO.pushVip(VipSF.call);
                      return;
                    }

                    if (!DI.login.checkBalance(ConsSF.call)) {
                      NTO.pushGem(ConsSF.call);
                      return;
                    }

                    final sessionId = ctr.sessionId;
                    if (sessionId == null) {
                      Toast.toast('Please select a user to call.');
                      return;
                    }

                    NTO.pushPhone(
                      sessionId: sessionId,
                      role: ctr.role,
                      showVideo: false,
                    );
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(
                        colors: [Color(0x88501E3A), Color(0x88000000)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/tele@3x.png',
                        width: 32,
                        height: 32,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const VLevel(),
        ],
      ),
    );
  }
}
