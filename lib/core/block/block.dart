import 'dart:io';

import 'package:get/get.dart';
import 'package:soul_talk/core/config/evn.dart';

import '../../app/di_depency.dart';
import '../../utils/info_utils.dart';
import '../../utils/log_util.dart';
import '../constants/vs.dart';

class Block {
  static Future request({bool isFisrt = false}) async {
    final keyBird = DI.storage.isBest;
    if (ENV.isDebugMode) {
      DI.storage.setIsBird(true);
      return;
    }
    log.d('fetchSwitches isBig = $keyBird isFisrt = $isFisrt');
    if (keyBird && isFisrt == false) {
      return;
    }

    try {
      if (Platform.isIOS) {
        await _requestIos();
      } else if (Platform.isAndroid) {
        await _requestAnd();
      }
    } catch (e) {
      log.e('Error in requesClk: $e');
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
        'melville': ENV.bundleId,
        'picture': 'cypriot',
        'whet': version,
        'bergamot': deviceId,
        'dominic': DateTime.now().millisecondsSinceEpoch,
        'upsilon': idfa,
        'franca': idfv,
      };

      final client = GetConnect(timeout: const Duration(seconds: 60));

      final response = await client.post(
        'https://library.aimiappweb.com/bobble/penn/montreal',
        body,
      );
      log.i('Response: $body\n ${response.body}');

      var clkStatus = false;
      if (response.isOk && response.body == 'gadfly') {
        clkStatus = true;
      }
      await DI.storage.setBool(VS.keyClkStatus, clkStatus);
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
