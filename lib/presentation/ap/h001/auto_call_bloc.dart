import 'package:get/get.dart';
import 'package:soul_talk/app/di_depency.dart';
import 'package:soul_talk/core/constants/vs.dart';
import 'package:soul_talk/domain/entities/figure.dart';
import 'package:soul_talk/domain/value_objects/enums.dart';
import 'package:soul_talk/presentation/ap/am000/m_p.dart';
import 'package:soul_talk/presentation/v000/v_dialog.dart';
import 'package:soul_talk/router/app_routers.dart';
import 'package:soul_talk/router/route_constants.dart';
import 'package:soul_talk/utils/extensions.dart';

import '../../../core/analytics/analytics_service.dart';
import '../../../utils/log_util.dart';
import '../../../utils/navigator_obs.dart';

class AutoCallBloc extends GetxController {
  // 主动来电
  final List<Figure> _callList = [];
  Figure? _callRole;
  int _callCount = 0;
  int _lastCallTime = 0;
  bool _calling = false;

  void onCall(List<Figure>? list) async {
    try {
      if (list == null || list.isEmpty) return;
      _callList.assignAll(list);
      final role = list
          .where(
            (element) =>
                element.gender == 1 && element.renderStyle == 'REALISTIC',
          )
          .toList()
          .randomOrNull;
      if (role == null) {
        return;
      }
      _callRole = role;
      callOut();
    } catch (e) {
      log.e(e.toString());
    }
  }

  Future callOut() async {
    try {
      if (_callRole == null) {
        return;
      }
      final roleId = _callRole?.id;
      if (roleId == null || roleId.isEmpty) {
        return;
      }

      String? url;
      if (_callRole!.videoChat == true) {
        logEvent('t_ai_videocall');
        final guide = _callRole?.characterVideoChat?.firstWhereOrNull(
          (e) => e.tag == 'guide',
        );
        url = guide?.gifUrl;
      } else {
        logEvent('t_ai_audiocall');
        url = _callRole?.avatar;
      }

      if (url == null || url.isEmpty) {
        return;
      }
      await Future.delayed(const Duration(seconds: 4));

      if (!canCall() || _calling) {
        return;
      }

      _calling = true;

      _lastCallTime = DateTime.now().millisecondsSinceEpoch;
      _callCount++;

      const sessionId = 0;

      AppRoutes.pushPhone(
        sessionId: sessionId,
        role: _callRole!,
        showVideo: true,
        callState: CallState.incoming,
      );

      final role = _callList
          .where(
            (element) =>
                element.gender == 1 &&
                element.renderStyle == 'REALISTIC' &&
                element.id != _callRole?.id,
          )
          .toList()
          .randomOrNull;
      if (role == null) {
        return;
      }
      _callRole = role;
    } catch (e) {
      log.e(e.toString());
    } finally {
      _calling = false;
    }
  }

  bool canCall() {
    if (!DI.storage.isBest) {
      log.d('-------->canCall: false isA');
      return false;
    }

    if (mainTabIndex != MainTabBarIndex.home) {
      return false;
    }

    if (NavigatorObs.instance.curRoute?.settings.name != RouteConstants.root) {
      log.d('-------->canCall: false curRoute is not root');
      return false;
    }

    if (DI.login.vipStatus.value) {
      log.d('-------->canCall: false isVip');
      return false;
    }
    if (_callCount > 2) {
      log.d('-------->canCall:false  _callCount > 2');
      return false;
    }
    if (VDialog.checkExist(VS.loginRewardTag)) {
      log.d('-------->canCall: false  loginRewardTag');
      return false;
    }
    int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
    if (_lastCallTime > 0 && currentTimestamp - _lastCallTime < 2 * 60 * 1000) {
      log.d('-------->canCall: 180s false');
      return false;
    }
    return true;
  }
}
