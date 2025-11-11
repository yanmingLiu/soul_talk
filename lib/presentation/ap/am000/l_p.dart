import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:soul_talk/router/route_constants.dart';

import '../../../app/di_depency.dart';
import '../../../core/facebook/fbu.dart';
import '../../../core/block/block.dart';
import '../../../utils/info_utils.dart';
import '../../../utils/log_util.dart';
import '../../../utils/pay_utils.dart';
import '../../v000/base_scaffold.dart';

class LaunchPage extends StatefulWidget {
  const LaunchPage({super.key});

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage>
    with SingleTickerProviderStateMixin {
  double _progressValue = 0.0;
  Timer? _progressTimer;
  bool _isProgressComplete = false;

  @override
  void initState() {
    super.initState();

    initUI();

    if (DI.network.isConnected) {
      setup();
    } else {
      DI.network.waitForConnection().then((v) {
        setup();
      });
    }
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  void initUI() {
    EasyRefresh.defaultHeaderBuilder = () =>
        const MaterialHeader(color: Color(0xFFDF78B1));
    EasyRefresh.defaultFooterBuilder = () => const ClassicFooter(
      showText: false,
      showMessage: false,
      iconTheme: IconThemeData(color: Color(0xFFDF78B1)),
    );
    SmartDialog.config.toast = SmartConfigToast(alignment: Alignment.center);
  }

  Future<void> setup() async {
    try {
      await InfoUtils.getIdfa();

      // 启动进度条动画
      _startProgressAnimation();

      await DI.login.performRegister();

      await Future.wait([
        Block.request(isFisrt: true),
        PayUtils().query(),
        FBU.initializeWithRemoteConfig(),
      ]).timeout(const Duration(seconds: 7));

      await DI.login.fetchUserInfo();

      _completeSetup();
    } catch (e) {
      log.e('Splash setup error: $e');
      _completeSetup();
    }
  }

  void _startProgressAnimation() {
    _progressTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) return;
      setState(() {
        if (_progressValue < 0.5) {
          _progressValue += 0.02;
        } else if (_progressValue < 0.9) {
          _progressValue += 0.01;
        } else if (!_isProgressComplete) {
          _progressValue += 0.001;
        }
      });
    });
  }

  void _completeSetup() {
    if (!mounted) return;
    setState(() {
      _progressValue = 1.0;
      _isProgressComplete = true;
    });
    _progressTimer?.cancel();
    _navigateToMain();
  }

  Future<void> _navigateToMain() async {
    if (!mounted) return;
    Get.offAllNamed(RouteConstants.root);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 150),
            // Center(child: Image.asset('assets/images/logo.png', width: 100)),
            const SizedBox(height: 50),
            Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: const Color(0xFF00AB8E),
                size: 60,
              ),
            ),

            const Spacer(),

            const Text(
              'SoulTalk AI',
              style: TextStyle(
                color: Colors.black,
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class LoadingProgress extends StatelessWidget {
  final double progress;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color progressColor;
  final double borderRadius;

  const LoadingProgress({
    super.key,
    required this.progress,
    required this.width,
    required this.height,
    required this.backgroundColor,
    required this.progressColor,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: progress.clamp(0.0, 1.0),
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: progressColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),
      ),
    );
  }
}
