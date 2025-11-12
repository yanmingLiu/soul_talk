import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:soul_talk/core/config/evn.dart';
import 'package:soul_talk/presentation/v000/v_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app/di_depency.dart';
import '../core/data/h_pi.dart';
import '../core/data/ms_pi.dart';
import '../domain/entities/figure.dart';
import '../domain/value_objects/enums.dart';
import '../presentation/v000/loading.dart';
import '../presentation/v000/toast.dart';
import '../presentation/v000/v_dialog.dart';
import '../utils/info_utils.dart';
import 'route_constants.dart';

class NTO {
  NTO._();

  static void pushSearch() async {
    Get.toNamed(RouteConstants.search);
  }

  static Future<void> pushChat(
    String? roleId, {
    bool showLoading = true,
  }) async {
    if (roleId == null) {
      Toast.toast('roleId is null, please check!');
      return;
    }

    try {
      if (showLoading) {
        Loading.show();
      }

      // 使用 Future.wait 来同时执行查角色和查会话
      var results = await Future.wait([
        HomeApi.loadRoleById(roleId), // 查角色
        MsgApi.addSession(roleId), // 查会话
      ]);

      var role = results[0];
      var session = results[1];

      // 检查角色和会话是否为 null
      if (role == null) {
        _dismissAndShowErrorToast('role is null');
        return;
      }
      if (session == null) {
        _dismissAndShowErrorToast('session is null');
        return;
      }

      Loading.dismiss();
      Get.toNamed(
        RouteConstants.message,
        arguments: {'role': role, 'session': session},
      );
    } catch (e) {
      Loading.dismiss();
      Toast.toast(e.toString());
    }
  }

  static void _dismissAndShowErrorToast(String message) {
    Loading.dismiss();
    Toast.toast(message);
  }

  static void pushVip(VipSF from) {
    Get.toNamed(RouteConstants.vip, arguments: from);
  }

  static void pushProfile(Figure role) {
    Get.toNamed(RouteConstants.profile, arguments: role);
  }

  static void pushGem(ConsSF from) {
    Get.toNamed(RouteConstants.gems, arguments: from);
  }

  static Future<T?>? pushPhone<T>({
    required int sessionId,
    required Figure role,
    required bool showVideo,
    CallState callState = CallState.calling,
  }) async {
    // 检查 Mic 权限 和 语音权限
    if (!await checkPermissions()) {
      showNoPermissionDialog();
      return null;
    }

    return Get.toNamed(
      RouteConstants.phone,
      arguments: {
        'sessionId': sessionId,
        'role': role,
        'callState': callState,
        'showVideo': showVideo,
      },
    );
  }

  static Future<T?>? offPhone<T>({
    required Figure role,
    required bool showVideo,
    CallState callState = CallState.calling,
  }) async {
    // 检查 Mic 权限 和 语音权限
    if (!await checkPermissions()) {
      showNoPermissionDialog();
      return null;
    }
    var seesion = await MsgApi.addSession(role.id ?? ''); // 查会话
    final sessionId = seesion?.id;
    if (sessionId == null) {
      Toast.toast('sessionId is null, please check!');
      return null;
    }

    return Get.offNamed(
      RouteConstants.phone,
      arguments: {
        'sessionId': sessionId,
        'role': role,
        'callState': callState,
        'showVideo': showVideo,
      },
    );
  }

  /// 检查麦克风和语音识别权限，返回是否已授予所有权限
  static Future<bool> checkPermissions() async {
    PermissionStatus status = await Permission.microphone.request();
    PermissionStatus status2 = await Permission.speech.request();
    return status.isGranted && status2.isGranted;
  }

  // 没有权限提示
  static Future<void> showNoPermissionDialog() async {
    VDialog.alert(
      message: 'Please enable microphone and speech recognition permissions',
      onConfirm: () async {
        await openAppSettings();
      },
      cancelText: 'Cancel',
      confirmText: 'Open Settings',
    );
  }

  static Future<T?>? pushPhoneGuide<T>({required Figure role}) {
    return Get.toNamed(RouteConstants.phoneGuide, arguments: {'role': role});
  }

  static void pushImagePreview(String imageUrl) {
    Get.toNamed(RouteConstants.imagePreview, arguments: imageUrl);
  }

  static void pushVideoPreview(String url) {
    Get.toNamed(RouteConstants.videoPreview, arguments: url);
  }

  static void pushMask() {
    Get.toNamed(RouteConstants.mask);
  }

  static void pushMakeRole(Figure role) {
    Get.toNamed(RouteConstants.makeRole, arguments: role);
  }

  static void pushChooseLang() {
    Get.toNamed(RouteConstants.chooseLang);
  }

  static void toEmail() async {
    final version = await InfoUtils.version();
    final device = await DI.storage.getDeviceId();
    final uid = DI.login.currentUser?.id;

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: ENV.email, // 收件人
      query:
          "subject=Feedback&body=version: $version\ndevice: $device\nuid: $uid\nPlease input your problem:\n",
    );

    launchUrl(emailUri);
  }

  static void toPrivacy() {
    launchUrl(Uri.parse(ENV.privacy));
  }

  static void toTerms() {
    launchUrl(Uri.parse(ENV.terms));
  }

  static Future<void> openAppStoreReview() async {
    if (Platform.isIOS) {
      String appId = ENV.appId;
      final Uri url = Uri.parse(
        'https://apps.apple.com/app/id$appId?action=write-review',
      );

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        _showError('Could not launch $url');
      }
    } else if (Platform.isAndroid) {
      String packageName = await InfoUtils.packageName();
      final Uri url = Uri.parse(
        'https://play.google.com/store/apps/details?id=$packageName',
      );

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        _showError('Could not launch $url');
      }
    } else {
      _showError('Unsupported platform');
    }
  }

  static Future<void> openAppStore() async {
    try {
      if (Platform.isIOS) {
        String appId = ENV.appId;
        final Uri url = Uri.parse('https://apps.apple.com/app/id$appId');
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          _showError('Could not launch $url');
        }
      } else if (Platform.isAndroid) {
        String packageName = await InfoUtils.packageName();
        final Uri url = Uri.parse(
          'https://play.google.com/store/apps/details?id=$packageName',
        );

        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          _showError('Could not launch $url');
        }
      } else {
        _showError('Unsupported platform');
      }
    } catch (e) {
      _showError('Could not launch ${e.toString()}');
    }
  }

  static void _showError(String message) {
    Toast.toast(message);
  }

  static void report() {
    void request() async {
      VSheet.dismiss();

      Loading.show();
      await Future.delayed(const Duration(seconds: 1));
      Loading.dismiss();
      Toast.toast('Report successful');
    }

    Map<String, Function> actsion = {
      'Spam': request,
      'Violence': request,
      'Child Abuse': request,
      'Copyright': request,
      'Personal Details': request,
      'Illegal Drugs': request,
    };

    VSheet.show(
      GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: actsion.keys.length,
        itemBuilder: (_, index) {
          final fn = actsion.values.toList()[index];
          return InkWell(
            onTap: () {
              fn.call();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                actsion.keys.toList()[index],
                style: const TextStyle(
                  color: Color(0xFF595959),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          );
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 168.0 / 42.0,
        ),
      ),
    );
  }
}
