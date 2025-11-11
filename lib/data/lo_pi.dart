import 'dart:async';
import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:pointycastle/asymmetric/api.dart';
import 'package:soul_talk/core/config/evn.dart';
import 'package:soul_talk/core/network/dio_client.dart';

import '../app/di_depency.dart';
import '../core/constants/api_values.dart';
import '../domain/entities/base_model.dart';
import '../domain/entities/price.dart';
import '../domain/entities/user.dart';
import '../utils/info_utils.dart';
import 'api.dart';

class LoginApi {
  LoginApi._();

  static Future<User?> register() async {
    try {
      final deviceId = await DI.storage.getDeviceId();
      var res = await api.request(
        ApiConstants.register,
        method: HttpMethod.post,
        data: {"device_id": deviceId, "platform": ENV.platform},
      );
      if (!res.data) {
        return null;
      }
      final user = User.fromJson(res.data);
      return user;
    } catch (e) {
      return null;
    }
  }

  static Future<User?> getUserInfo() async {
    try {
      final deviceId = await DI.storage.getDeviceId();
      final res = await api.request(
        ApiConstants.getUserInfo,
        method: HttpMethod.get,
        queryParameters: {'device_id': deviceId},
      );

      final user = User.fromJson(res.data);
      return user;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> updateUserInfo(Map<String, dynamic> body) async {
    try {
      final res = await api.request(
        ApiConstants.updateUserInfo,
        method: HttpMethod.post,
        data: body,
      );
      final reult = BaseModel.fromJson(res.data, null);
      return reult.data;
    } catch (e) {
      return false;
    }
  }

  /// api signature msg
  static Future<String?> getApiSignature() async {
    try {
      if (Api.userId == null || (Api.userId?.isEmpty ?? true)) return null;
      const derEncodedPublicKey =
          'MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCLWMEjJb703WZJ5Nqf7qJ2wefSSYvbmQZM0CgHGrYstUaj4Mlz+P06mCqpVAYmyf3dJxLrEsUiobWvhi1Ut5W+PY0yrzEsIOJ5lJrIt1pm0/kcPsPj2d4cEl9S7DTEIJVQTGMzquAlhEkgbA0yDVXNtqqf4MECCADU/WM3WTCH2QIDAQAB';
      const pemPublicKey =
          '-----BEGIN PUBLIC KEY-----\n$derEncodedPublicKey\n-----END PUBLIC KEY-----';
      final parser = RSAKeyParser();
      final RSAPublicKey publicKey = parser.parse(pemPublicKey) as RSAPublicKey;
      final encrypter = Encrypter(
        RSA(publicKey: publicKey, encoding: RSAEncoding.PKCS1),
      );
      final encrypted = encrypter.encrypt(Api.userId!);
      return encrypted.base64;
    } catch (e) {
      return null;
    }
  }

  static Future<int> consumeReq(int value, String from) async {
    // 使用公钥加密消息
    final uid = DI.login.currentUser?.id;
    if (uid == null || uid.isEmpty) return 0;
    final signature = await getApiSignature();

    var body = <String, dynamic>{
      'signature': signature,
      'id': uid,
      'gems': value,
      'description': from,
    };

    try {
      var res = await api.request(
        ApiConstants.minusGems,
        method: HttpMethod.post,
        data: body,
        queryParameters: Api.queryParameters,
      );
      if (res.statusCode == 200) {
        return res.data;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  static Future<bool> updateEventParams({String? lang}) async {
    try {
      String deviceId = await Api.getDeviceId();
      final adid = await InfoUtils.getAdid();
      Map<String, dynamic> data = {
        'adid': adid,
        'device_id': deviceId,
        'platform': ENV.platform,
      };

      if (Platform.isIOS) {
        String idfa = await InfoUtils.getIdfa();
        data['idfa'] = idfa;
      } else if (Platform.isAndroid) {
        final gpsAdid = await InfoUtils.getGoogleAdId();
        data['gps_adid'] = gpsAdid;
      }

      data['source_language'] = 'en';
      data['target_language'] = Get.deviceLocale?.languageCode;

      if (lang != null) {
        data['target_language'] = lang;
      }
      var result = await api.request(
        ApiConstants.eventParams,
        method: HttpMethod.post,
        data: data,
      );
      return result.data == true;
    } catch (e) {
      return false;
    }
  }

  static Future<String?> translateText(
    String content, {
    String? slan = 'en',
    String? tlan,
  }) async {
    try {
      var result = await api.request(
        ApiConstants.translate,
        method: HttpMethod.post,
        data: {
          'content': content,
          'source_language': slan,
          'target_language': tlan ?? Get.deviceLocale?.languageCode,
        },
      );
      final res = BaseModel.fromJson(result.data, null);
      return res.data;
    } catch (e) {
      return null;
    }
  }

  static Future getDailyReward() async {
    try {
      var result = await api.request(
        ApiConstants.signIn,
        method: HttpMethod.post,
      );
      final res = BaseModel.fromJson(result.data, null);
      if (res.code == 0 || res.code == 200) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// 获取各种价格配置
  static Future<Price?> getPriceConfig() async {
    try {
      var result = await api.get(ApiConstants.getPriceConfig);
      var res = Price.fromJson(result.data);
      return res;
    } catch (e) {
      return null;
    }
  }

  /// 获取语言列表
  static Future<Map<String, dynamic>?> getAppLangs() async {
    try {
      var result = await api.get(ApiConstants.supportLangs);
      var res = BaseModel.fromJson(result.data, null);
      if (res.data != null) {
        return res.data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
