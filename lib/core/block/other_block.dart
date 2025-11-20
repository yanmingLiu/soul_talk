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
    var localAllows = FirebaseRemoteConfig.instance.getString("local_allows");
    final deviceId = await DI.storage.getDeviceId();
    if (localAllows.contains(deviceId)) {
      logEvent("home_yes", parameters: {"reason": "local_allows"});
      return true;
    }

    // 判断是否所有用户走判断
    var needChek1 = FirebaseRemoteConfig.instance.getString("momio_clo");
    if (needChek1 == "close") {
      logEvent("home_no", parameters: {"reason": "momio_Clo"});
      return false;
    }

    //默认为open, 全部走判断
    var cloak = FirebaseRemoteConfig.instance.getString("momio_cloak_add");
    if (cloak == "close") {
      logEvent("home_no", parameters: {"reason": "fireb_close"});
      return true;
    }

    //判断vpn
    var listC = await Connectivity().checkConnectivity();
    if (listC.contains(ConnectivityResult.vpn) || listC.contains(ConnectivityResult.other)) {
      //开启了vpn
      _log('vpn status:vpn');
      logEvent("home_no", parameters: {"reason": "vpn"});
      return false;
    }

    //判断是否模拟器
    var iosInfo = await DeviceInfoPlugin().iosInfo;
    if (iosInfo.isPhysicalDevice == false) {
      _log('isSimulator status: simulator');
      logEvent("home_no", parameters: {"reason": "simulator"});
      return false;
    }

    //判断是否有sim卡
    var hasSim = await FlutterSimCheck.hasSimCard();
    _log('hasSim status: $hasSim');
    if (!hasSim) {
      logEvent("home_no", parameters: {"reason": "not_sim"});
      return false;
    }

    return true;
  }
}
