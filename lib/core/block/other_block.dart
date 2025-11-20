import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_sim_check/flutter_sim_check.dart';
import 'package:soul_talk/core/block/ip_check.dart';

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
      return false;
    }
    var cloak = FirebaseRemoteConfig.instance.getString("momio_cloak_add");
    if (cloak == "close") {
      logEvent("home_no", parameters: {"reason": "fireb"});
      return false;
    }
    //默认为open,屏蔽
    var isVpn = false;
    var isSimulator = false;
    var hasSim = true;
    var isFirebaseClose = false;

    //判断vpn
    var listC = await Connectivity().checkConnectivity();
    if (listC.contains(ConnectivityResult.vpn) || listC.contains(ConnectivityResult.other)) {
      //开启了vpn
      isVpn = true;
      logEvent("home_no", parameters: {"reason": "vpn"});
    }
    _log('vpn status: $isVpn');

    //判断是否模拟器
    var iosInfo = await DeviceInfoPlugin().iosInfo;
    if (iosInfo.isPhysicalDevice == false) {
      isSimulator = true;
      logEvent("home_no", parameters: {"reason": "simulator"});
    }
    _log('isSimulator status: $isSimulator');

    //判断是否有sim卡
    hasSim = await FlutterSimCheck.hasSimCard();
    _log('hasSim status: $hasSim');

    var reasonList = [];

    // 判断 ip
    final ipc = IpCheck();

    final isIreland = await ipc.isIreland();
    final isChina = await ipc.isChina();
    _log('ip status: ireland: $isIreland, isChina: $isChina');

    if (isIreland) {
      logEvent("home_no", parameters: {"reason": "ireland"});
      reasonList.add("ireland");
    } else if (isChina) {
      logEvent("home_no", parameters: {"reason": "china"});
      reasonList.add("china");
    }

    if (isVpn) {
      reasonList.add("vpn");
    }
    if (isSimulator) {
      reasonList.add("simulator");
    }
    if (!hasSim) {
      reasonList.add("sim");
    }

    var buyS = FirebaseRemoteConfig.instance.getString("momio_clo");
    if (buyS == "close") {
      isFirebaseClose = true;
      logEvent("home_no", parameters: {"reason": "momio_Clo"});
      _log('momio_clo status: momio_Clo');
    }

    if (isFirebaseClose) {
      reasonList.add("fireb");
    }

    return reasonList.isEmpty;
  }
}
