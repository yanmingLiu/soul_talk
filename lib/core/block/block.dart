import 'dart:io';

import 'package:get/get.dart';
import 'package:soul_talk/core/analytics/analytics_service.dart';
import 'package:soul_talk/core/config/evn.dart';
import 'package:soul_talk/core/constants/vs.dart';
import 'package:soul_talk/utils/info_utils.dart';

import '../../app/di_depency.dart';
import '../../utils/log_util.dart';
import 'other_block.dart';

class Block {
  static Future request({bool isFisrt = false}) async {
    if (ENV.isDebugMode) {
      // 开发
      DI.storage.setIsBird(true);

      // final isBest = DI.storage.isBest;
      // final other = await OtherBlock.check();
      // log.d('---block---: isBest = $isBest, other = $other');
      // final res = isBest && other;
      // await DI.storage.setIsBird(res);
    } else {
      /// 正式
      try {
        if (Platform.isIOS) {
          await _requestIos();
        } else if (Platform.isAndroid) {
          await _requestAnd();
        }
      } catch (e) {
        log.e('---block---Error in requesClk: $e');
      }

      final isBest = DI.storage.isBest;

      if (isBest) {
        logEvent("fire_chek", parameters: {"reason": "cloak_b"});
        final other = await OtherBlock.check();
        log.d('---block---: isBest = $isBest, other = $other');
        final res = isBest && other;
        await DI.storage.setIsBird(res);
      } else {
        logEvent("fire_chek", parameters: {"reason": "cloak_a"});
      }
    }
  }

  // iOS 点击事件请求
  static Future<void> _requestIos() async {
    try {
      final deviceId = await DI.storage.getDeviceId(isOrigin: true);
      final version = await InfoUtils.version();
      final idfa = await InfoUtils.getIdfa();
      final idfv = await InfoUtils.getIdfv();

      final Map<String, dynamic> body = {
        'decadent': ENV.bundleId,
        'gauze': 'vilify',
        'quackery': version,
        'nickname': deviceId,
        'dell': DateTime.now().millisecondsSinceEpoch,
        'porphyry': idfa,
        'vandal': idfv,
      };

      final client = GetConnect(timeout: const Duration(seconds: 60));

      final response = await client.post(
        'https://allegro.soultalkweb.com/sweaty/nih',
        body,
      );
      log.i('Response: $body\n ${response.body}');

      var isBest = false;
      if (response.isOk && response.body == 'caloric') {
        isBest = true;
      }
      await DI.storage.setBool(VS.keyClkStatus, isBest);
    } catch (e) {
      log.e('Error in _requestIosClk: $e');
    }
  }

  static Future<void> _requestAnd() async {
    try {
      // final deviceId = await DI.storage.getDeviceId(isOrigin: true);
      // final version = await InfoUtils.version();
      // final gaid = await InfoUtils.getGoogleAdId();
      // final androidId = await InfoUtils.getAndroidId();

      // final Map<String, dynamic> body = {
      //   'adulate': 'com.qqchat.fast',
      //   'nobodyd': 'bennett',
      //   'smooth': version,
      //   'aventine': DateTime.now().millisecondsSinceEpoch,
      //   'thruway': deviceId,
      //   'strode': gaid,
      //   'thematic': androidId,
      // };

      // final client = GetConnect(timeout: const Duration(seconds: 60));
      // log.d('Sending post request: $body');

      // final response = await client.post(
      //   'https://shotgun.fastaiapptop.com/munition/nudge/dispute',
      //   body,
      // );
      // log.i('Response: ${response.body}');

      // var clkStatus = false;
      // if (response.isOk && response.body == 'mute') {
      //   clkStatus = true;
      // }
      // await DI.storage.setBool(AppConstants.keyClkStatus, clkStatus);
    } catch (e) {
      log.e('Error in _requestAndroidClk: $e');
    }
  }
}
