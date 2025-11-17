import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:soul_talk/app/di_depency.dart';
import 'package:soul_talk/core/analytics/analytics_service.dart';
import 'package:soul_talk/domain/entities/figure.dart';
import 'package:soul_talk/domain/value_objects/enums.dart';
import 'package:soul_talk/presentation/ap/p006/v/p006_btn.dart';
import 'package:soul_talk/presentation/ap/p006/v/p006_title.dart';
import 'package:soul_talk/presentation/v000/loading.dart';
import 'package:soul_talk/presentation/v000/nav_back_btn.dart';
import 'package:soul_talk/presentation/v000/toast.dart';
import 'package:soul_talk/presentation/v000/v_button.dart';
import 'package:soul_talk/presentation/v000/v_image.dart';
import 'package:soul_talk/router/nav_to.dart';
import 'package:soul_talk/utils/file_downloader.dart';
import 'package:soul_talk/utils/navigator_obs.dart';
import 'package:video_player/video_player.dart';

class P006GuidePage extends StatefulWidget {
  const P006GuidePage({super.key});

  @override
  State<P006GuidePage> createState() => _P006GuidePageState();
}

enum PlayState { init, playing, finish }

class _P006GuidePageState extends State<P006GuidePage>
    with RouteAware, WidgetsBindingObserver {
  late Figure role;

  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;

  var playState = PlayState.init.obs;
  bool _hasCalledPhoneAccept = false; // 添加标志位防止重复调用

  @override
  void initState() {
    super.initState();
    var args = Get.arguments;
    role = args['role'];

    WidgetsBinding.instance.addObserver(this);

    _initVideoPlay();
  }

  void _initVideoPlay() {
    _initializeVideoPlayerFuture = _downloadAndInitVideo();
    _hasCalledPhoneAccept = false; // 重置标志位
  }

  Future<void> _downloadAndInitVideo() async {
    try {
      final guide = role.characterVideoChat?.firstWhereOrNull(
        (e) => e.tag == 'guide',
      );
      var url = guide?.url;
      if (url == null) {
        throw Exception('Video URL not found');
      }

      final path = await FileDownloader.instance.downloadFile(
        url,
        fileType: FileType.video,
      );
      if (path == null) {
        throw Exception('Video download failed');
      }

      _controller = VideoPlayerController.file(File(path));

      await _controller!.initialize().then((_) {
        _controller?.addListener(_videoListener);
        _delayedPlay();
      });
    } catch (e) {
      if (mounted) {
        Toast.toast("Hmm… we lost connection for a bit. Please try again!");

        Get.back();
      }
    }
  }

  Future _delayedPlay() async {
    // 延迟5秒后开始播放
    await Future.delayed(const Duration(seconds: 5));

    if (mounted) {
      _controller?.play();
      playState.value = PlayState.playing;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    /// 路由订阅
    NavigatorObs.instance.observer.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    /// 取消路由订阅
    NavigatorObs.instance.observer.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);

    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didPushNext() {
    // 页面被其他页面覆盖时调用
    debugPrint('didPushNext');
    _controller?.pause();
  }

  @override
  void didPopNext() {
    // 页面从其他页面回到前台时调用
    debugPrint('didPopNext');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _controller?.pause();
      setState(() {});
    }
  }

  void _videoListener() {
    if (_controller == null) return;

    final position = _controller!.value.position;
    final duration = _controller!.value.duration;
    final timeRemaining = duration - position;

    if (timeRemaining <= const Duration(milliseconds: 500)) {
      _controller?.pause();
      playState.value = PlayState.finish;

      if (DI.login.vipStatus.value && !_hasCalledPhoneAccept) {
        _hasCalledPhoneAccept = true; // 设置标志位防止重复调用
        _phoneAccept();
      }
    }
  }

  //监听权限
  Future<bool?> requestPermission() async {
    var status = await Permission.phone.request();

    switch (status) {
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
        return false;
      case PermissionStatus.granted:
        return true;
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          titleSpacing: 0,
          leadingWidth: 0.0,
          leading: null,
          automaticallyImplyLeading: false,
          title: Stack(
            alignment: Alignment.center,
            children: [
              Obx(() {
                if (playState.value == PlayState.playing) {
                  return const SizedBox.shrink();
                }
                return P006Title(
                  role: role,
                  onTapClose: () {
                    Get.back();
                  },
                );
              }),
              Row(
                children: [
                  Obx(() {
                    if (playState.value == PlayState.playing) {
                      return const SizedBox(width: 24);
                    }
                    return const NavBackBtn(
                      icon: 'assets/images/close@3x.png',
                    );
                  }),
                  const Spacer(),
                ],
              )
            ],
          ),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      bottom: false,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Stack(
          children: [
            Positioned.fill(child: VImage(url: role.avatar)),
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    _controller != null) {
                  return Positioned.fill(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller?.value.size.width,
                        height: _controller?.value.size.height,
                        child: VideoPlayer(_controller!),
                      ),
                    ),
                  );
                } else {
                  // 在加载时显示进度指示器
                  return Center(child: Loading.activityIndicator());
                }
              },
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
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Obx(() {
                final vip = DI.login.vipStatus.value;

                switch (playState.value) {
                  case PlayState.init:
                  case PlayState.playing:
                    return _playingView();

                  case PlayState.finish:
                    return vip ? _playingView() : _playedView();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _phoneAccept() async {
    final vip = DI.login.vipStatus.value;
    if (vip) {
      if (DI.login.gemBalance.value < ConsSF.call.gems) {
        NTO.pushGem(ConsSF.call);
        return;
      }
      NTO.offPhone(role: role, showVideo: true);
    } else {
      _pushVip();
    }
  }

  void _pushVip() {
    logEvent('c_unlock_videocall');
    NTO.pushVip(VipSF.call);
  }

  Widget _playingView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 8,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          child: const Text(
            "Invites you to video call…",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            P006Btn(
              icon: 'assets/images/hangup@3x.png',
              onTap: () => Get.back(),
            ),
            if (playState.value == PlayState.finish)
              P006Btn(
                icon: 'assets/images/answer@3x.png',
                onTap: _phoneAccept,
              ),
          ],
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _playedView() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: const Column(
              children: [
                Text(
                  "Activate Benefits",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "Get an AI interactive video chat experience",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          VButton(
            color: const Color(0xFFDF78B1),
            onTap: _pushVip,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: const Center(
              child: Text(
                'Unlock Now',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
