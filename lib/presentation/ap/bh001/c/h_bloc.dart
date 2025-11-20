import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/core/analytics/analytics_service.dart';
import 'package:soul_talk/core/data/h_pi.dart';
import 'package:soul_talk/domain/entities/figure.dart';
import 'package:soul_talk/domain/value_objects/enums.dart';
import 'package:soul_talk/presentation/ap/bh001/p/h_post_page.dart';
import 'package:soul_talk/presentation/ap/bh001/v/h_v_view.dart';
import 'package:soul_talk/presentation/v000/v_dialog.dart';
import 'package:soul_talk/router/nav_to.dart';
import 'package:soul_talk/router/route_constants.dart';

import '../../../../app/di_depency.dart';
import '../../../../core/data/lo_pi.dart';
import '../../../../domain/entities/tag.dart';
import '../../../../utils/log_util.dart';
import '../../../v000/k_a_w.dart';

enum HCate { all, realistic, anime, dressUp, video, post }

enum FollowEvent { follow, unfollow }

// 为枚举添加扩展，提供title和icon等属性
extension HomeListCategoryExtension on HCate {
  String get title {
    switch (this) {
      case HCate.all:
        return 'All';
      case HCate.realistic:
        return 'Realistic';
      case HCate.anime:
        return 'Anime';
      case HCate.dressUp:
        return 'Dress Up';
      case HCate.video:
        return 'Video';
      case HCate.post:
        return 'Moments';
    }
  }

  int get index => HCate.values.indexOf(this);
}

class HomeBloc extends GetxController {
  var categroyList = <HCate>[].obs;
  var categroy = HCate.all.obs;

  var pages = <Widget>[];

  // 标签
  List<TagReponse> roleTags = [];
  var selectTags = <Tag>{}.obs;
  Rx<(Set<Tag>, int)> filterEvent = (<Tag>{}, 0).obs;

  // 关注

  Rx<(FollowEvent, String, int)> followEvent = (FollowEvent.follow, '', 0).obs;

  @override
  void onInit() {
    super.onInit();

    if (DI.network.isConnected) {
      setupAndJump();
    } else {
      DI.network.waitForConnection().then((v) {
        if (v) {
          setupAndJump();
        }
      });
    }
  }

  void onTapCate(HCate value) {
    categroy.value = value;
  }

  void onTapFilter() {
    Get.toNamed(RouteConstants.homeFilter);
  }

  Future<void> setupAndJump() async {
    await setup();
    jump();
  }

  Future<void> setup() async {
    try {
      final isBird = DI.storage.isBest;
      categroyList.addAll([
        HCate.all,
        HCate.realistic,
        HCate.anime,
        if (isBird) HCate.video,
        if (isBird) HCate.dressUp,
        if (isBird) HCate.post,
      ]);

      pages = categroyList.map((element) {
        if (element == HCate.post) {
          return const KeepAliveWrapper(child: HPostPage());
        }
        return KeepAliveWrapper(child: HomeListView(cate: element));
      }).toList();

      LoginApi.updateEventParams();

      if (DI.storage.isBest) {
        loadTags();
      }
    } catch (e) {
      log.e('All tasks failed with error: $e');
    }

    update();
  }

  Future loadTags() async {
    final tags = await HomeApi.roleTagsList();
    if (tags != null) {
      roleTags.assignAll(tags);
    }
  }

  void jump() {
    if (DI.storage.isBest) {
      jumpForB();
    } else {
      jumpForA();
    }
  }

  void jumpForA() async {
    final isFirstLaunch = DI.storage.isRestart == false;

    if (isFirstLaunch) {
      recordInstallTime();
      DI.storage.setRestart(true);
    } else {
      final isShowDailyReward = await shouldShowDailyReward();
      if (isShowDailyReward) {
        // 更新奖励时间戳
        await DI.storage.setInstallTime(DateTime.now().millisecondsSinceEpoch);
        VDialog.showLoginReward();
      }
    }
  }

  void jumpForB() async {
    final isShowDailyReward = await shouldShowDailyReward();
    final isVip = DI.login.vipStatus.value;
    final isFirstLaunch = DI.storage.isRestart == false;
    if (isFirstLaunch) {
      // 记录安装时间
      recordInstallTime();
      // 记录为重启
      DI.storage.setRestart(true);

      // 首次启动 获取指定人物聊天
      final startRole = await getSplashRole();
      if (startRole != null) {
        final roleId = startRole.id;
        NTO.pushChat(roleId, showLoading: false);
      } else {
        jumpVip(isFirstLaunch);
      }
    } else {
      // 非首次启动 判断弹出奖励弹窗
      if (isShowDailyReward) {
        // 更新奖励时间戳
        await DI.storage.setInstallTime(DateTime.now().millisecondsSinceEpoch);

        VDialog.showLoginReward();
      } else {
        // 非vip用户 跳转订阅页
        if (!isVip) {
          jumpVip(isFirstLaunch);
        }
      }
    }
  }

  Future<void> recordInstallTime() async {
    await DI.storage.setInstallTime(DateTime.now().millisecondsSinceEpoch);
  }

  Future<bool> shouldShowDailyReward() async {
    final installTimeMillis = DI.storage.lastRewardDate;
    if (installTimeMillis <= 0) {
      // 记录安装时间
      recordInstallTime();
      return false; // 没有记录安装时间，不处理
    }

    final installTime = DateTime.fromMillisecondsSinceEpoch(installTimeMillis);
    final now = DateTime.now();

    // 安装后第一天不弹窗，只有从第二天开始才弹窗
    final isAfterSecondDay = now.year > installTime.year ||
        (now.year == installTime.year && now.month > installTime.month) ||
        (now.year == installTime.year &&
            now.month == installTime.month &&
            now.day > installTime.day);

    if (!isAfterSecondDay) {
      return false;
    }

    // 检查今天是否已经发过奖励（避免重复弹窗）
    final lastRewardDateMillis = DI.storage.lastRewardDate;
    if (lastRewardDateMillis > 0) {
      final lastRewardDate = DateTime.fromMillisecondsSinceEpoch(
        lastRewardDateMillis,
      );

      // 如果今天已经发过奖励，则不弹窗
      if (now.year == lastRewardDate.year &&
          now.month == lastRewardDate.month &&
          now.day == lastRewardDate.day) {
        return false;
      }
    }

    return true; // 可以发奖励
  }

  // 获取开屏随机角色
  Future<Figure?> getSplashRole() async {
    await DI.login.fetchUserInfo();
    final role = await HomeApi.splashRandomRole();
    return role;
  }

  void jumpVip(bool isFirstLaunch) async {
    NTO.pushVip(DI.storage.isRestart ? VipSF.relaunch : VipSF.launch);

    var event = DI.storage.isBest ? 't_vipb' : 't_vipa';

    if (DI.storage.isRestart) {
      event = '${event}_relaunch';
    } else {
      event = '${event}_launch';
      DI.storage.setRestart(true);
    }
    logEvent(event);
  }
}
