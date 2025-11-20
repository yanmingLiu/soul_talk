import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_sim_check/flutter_sim_check.dart';

import '../../app/di_depency.dart';
import '../../utils/log_util.dart';
import '../analytics/analytics_service.dart';

class OtherBlock {
  static void _log(dynamic msg) {
    log.d('[OtherBlock]: $msg');
  }

  static Future<bool> check() async {
    var localAllows = FirebaseRemoteConfig.instance.getString("b5LzR2hW");
    final deviceId = await DI.storage.getDeviceId();
    if (localAllows.contains(deviceId)) {
      logEvent("fire_chek", parameters: {"b5LzR2hW": "whitelist"});
      return true;
    }

    // 判断是否所有用户走判断
    var needChek1 = FirebaseRemoteConfig.instance.getBool("F3aR8bT1");
    if (needChek1 == false) {
      logEvent("fire_chek", parameters: {"F3aR8bT1": "no"});
      return false;
    }

    //默认为open, 全部走判断
    var cloak = FirebaseRemoteConfig.instance.getBool("E9wJ3bX5");
    if (cloak == false) {
      logEvent("fire_chek", parameters: {"E9wJ3bX5": "no"});
      return true;
    }

    //判断vpn
    var listC = await Connectivity().checkConnectivity();
    if (listC.contains(ConnectivityResult.vpn) || listC.contains(ConnectivityResult.other)) {
      //开启了vpn
      logEvent("fire_chek", parameters: {"E9wJ3bX5": "vpn"});
      return false;
    }

    //判断是否模拟器
    var iosInfo = await DeviceInfoPlugin().iosInfo;
    if (iosInfo.isPhysicalDevice == false) {
      _log('isSimulator status: simulator');
      logEvent("fire_chek", parameters: {"E9wJ3bX5": "simulator"});
      return false;
    }

    //判断是否有sim卡
    var hasSim = await FlutterSimCheck.hasSimCard();
    _log('hasSim status: $hasSim');
    if (!hasSim) {
      logEvent("fire_chek", parameters: {"E9wJ3bX5": "nosim"});
      return false;
    }

    return true;
  }
}
