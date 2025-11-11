import 'dart:io';

import 'package:adjust_sdk/adjust.dart';
import 'package:android_id/android_id.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class InfoUtils {
  static Future<PackageInfo> packageInfo() async {
    return await PackageInfo.fromPlatform();
  }

  static Future<String> version() async {
    return (await packageInfo()).version;
  }

  static Future<String> buildNumber() async {
    return (await packageInfo()).buildNumber;
  }

  static Future<String> packageName() async {
    return (await packageInfo()).packageName;
  }

  static Future<String> getIdfa() async {
    if (!Platform.isIOS) {
      return '';
    }
    try {
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;
      debugPrint('trackingAuthorizationStatus: $status');

      if (status == TrackingStatus.notDetermined) {
        await Future.delayed(const Duration(milliseconds: 200));
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
      final idfa = await AppTrackingTransparency.getAdvertisingIdentifier();
      debugPrint('idfa: $idfa');
      return idfa;
    } catch (e) {
      debugPrint('getIdfa error: $e');
      return '';
    }
  }

  /// android_id
  static Future<String> getAndroidId() async {
    try {
      final String? androidId = await const AndroidId().getId();
      return androidId ?? '';
    } catch (e) {
      debugPrint('getAndroidId error: $e');
      return '';
    }
  }

  // 获取Adjust ID，带超时和错误处理
  static Future<String> getAdid() async {
    try {
      final adid = await Adjust.getAdid().timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          debugPrint('getAdid: onTimeout');
          return '';
        },
      );
      return adid ?? '';
    } catch (e) {
      debugPrint('getAdid error: $e');
      return '';
    }
  }

  // 获取Google AdId，带超时和错误处理
  static Future<String> getGoogleAdId() async {
    if (!Platform.isIOS) {
      return '';
    }
    try {
      final gpsAdid = await Adjust.getGoogleAdId().timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          debugPrint('getGoogleAdId:onTimeout');
          return '';
        },
      );
      return gpsAdid ?? '';
    } catch (e) {
      debugPrint('getGoogleAdId error: $e');
      return '';
    }
  }

  // 获取idfv
  static Future<String> getIdfv() async {
    if (!Platform.isIOS) {
      return '';
    }
    try {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? '';
    } catch (e) {
      debugPrint('getIdfv error: $e');
      return '';
    }
  }

  // 获取Adjust IDFV（备用方法）
  static Future<String> getAdjustIdfv() async {
    try {
      final idfv = await Adjust.getIdfv().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          debugPrint('getAdjustIdfv: onTimeout');
          return '';
        },
      );
      return idfv ?? '';
    } catch (e) {
      debugPrint('getAdjustIdfv error: $e');
      return '';
    }
  }

  // device_model
  static Future<String> getDeviceModel() async {
    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.model;
    }
    if (Platform.isIOS) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.utsname.machine;
    }
    return '';
  }

  // 手机厂商
  static Future<String> getDeviceManufacturer() async {
    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.manufacturer;
    }
    if (Platform.isIOS) {
      return 'Apple';
    }
    return '';
  }

  // 操作系统版本
  static Future<String> getOsVersion() async {
    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.release;
    }
    if (Platform.isIOS) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.systemVersion;
    }
    return '';
  }

  static Future<bool> isLimitAdTrackingEnabled() async {
    if (Platform.isIOS) {
      final attStatus =
          await AppTrackingTransparency.trackingAuthorizationStatus;
      return attStatus == TrackingStatus.authorized;
    } else if (Platform.isAndroid) {
      final isLimitAdTracking = await Adjust.isEnabled();
      return !isLimitAdTracking; // Android返回的是是否启用跟踪，取反得到是否限制
    }
    return false;
  }

  static Future<String> getIpAddress() async {
    var interfaces = await NetworkInterface.list();
    for (var interface in interfaces) {
      for (var addr in interface.addresses) {
        if (addr.type == InternetAddressType.IPv4) {
          // print('IP Address: ${addr.address}');
          return addr.address;
        }
      }
    }
    return '';
  }

  static int getBasicTimeZone() {
    // 获取当前时间
    DateTime now = DateTime.now();
    // 获取时区偏移（例如：中国时区为 8 小时，返回 Duration(hours: 8)）
    Duration offset = now.timeZoneOffset;
    // 转换为小时数
    double offsetHours =
        offset.inHours.toDouble() + offset.inMinutes.remainder(60) / 60;

    // print("当前时区与 UTC 偏移：$offsetHours 小时");
    // print("时区偏移详细信息：$offset");
    return offsetHours.toInt();
  }

  // 生成自定义 User-Agent
  static String userAgent() {
    if (Platform.isAndroid) {
      // 示例：基于默认 UA 移除 ;wv（也可直接写死完整 UA）
      // 注意：实际使用中可先获取默认 UA 再处理，避免硬编码兼容性问题
      return "Mozilla/5.0 (Linux; Android 13; SM-G998B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.5735.196 Mobile Safari/537.36";
    } else if (Platform.isIOS) {
      return "Mozilla/5.0 (iPhone; CPU iPhone OS 16_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148; CustomApp/1.0.0";
    }
    return '';
  }
}
