import 'package:soul_talk/app/di_depency.dart';
import 'package:soul_talk/core/config/evn.dart';

import '../core/constants/api_values.dart';
import '../core/network/dio_client.dart';
import '../domain/entities/base_model.dart';
import '../domain/entities/order.dart';
import '../domain/entities/sku.dart';
import '../utils/info_utils.dart';
import '../utils/log_util.dart';
import 'api.dart';

class PayApi {
  PayApi._();

  static DioClient api = DI.dio;

  /// 获取商品列表
  static Future<List<SKU>?> getSkuList() async {
    try {
      var result = await api.get(ApiConstants.skuList);
      var res = BaseModel.fromJson(result.data, null);
      if (res.data != null) {
        List<SKU> skus = [];
        for (var item in res.data) {
          skus.add(SKU.fromJson(item));
        }
        return skus;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<Order?> makeIosOrder({
    required String skuId,
    required String orderType,
    bool? createImg,
    bool? createVideo,
  }) async {
    try {
      final userId = Api.userId;

      if (userId == null || (userId.isEmpty)) return null;

      String deviceId = await Api.getDeviceId();

      Map<String, dynamic> body = {
        'user_id': userId,
        'sku_id': skuId,
        'order_type': orderType,
        'device_id': deviceId,
      };

      if (createImg != null) {
        body['create_img'] = createImg;
      }
      if (createVideo != null) {
        body['create_video'] = createVideo;
      }

      var res = await api.request(
        ApiConstants.createIosOrder,
        method: HttpMethod.post,
        data: body,
      );
      final result = BaseModel.fromJson(
        res.data,
        (data) => Order.fromJson(data),
      );
      return result.data;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> verifyIosOrder({
    required int orderId,
    required String? receipt,
    required String skuId,
    required String? transactionId,
    required String? purchaseDate,
    bool? dres,
    bool? createImg,
    bool? createVideo,
  }) async {
    try {
      final userId = Api.userId;
      if (userId == null || (userId.isEmpty)) {
        return false;
      }
      var chooseEnv = ENV.isDebugMode ? false : true;

      final idfa = await InfoUtils.getIdfa();
      final adid = await InfoUtils.getAdid();

      var params = <String, dynamic>{
        'order_id': orderId,
        'user_id': userId,
        'receipt': receipt,
        'choose_env': chooseEnv,
        'idfa': idfa,
        'adid': adid,
        'sku_id': skuId,
        'transaction_id': transactionId,
        'purchase_date': purchaseDate,
      };
      if (dres != null) {
        params['dres'] = dres;
      }
      if (createImg != null) {
        params['create_img'] = createImg;
      }
      if (createVideo != null) {
        params['create_video'] = createVideo;
      }
      var res = await api.request(
        ApiConstants.verifyIosReceipt,
        method: HttpMethod.post,
        data: params,
      );

      var data = BaseModel.fromJson(res.data, null);
      if (data.code == 0 || data.code == 200) {
        log.d('verifyIosOrder: ✅');
        return true;
      }
      log.w('verifyIosOrder: ❌ - code: ${data.code}');
      return false;
    } catch (e) {
      log.e('verifyIosOrder: 异常 - $e');
      return false;
    }
  }

  static Future<Order?> makeAndOrder({
    required String orderType,
    required String skuId,
    bool? createImg,
    bool? createVideo,
  }) async {
    try {
      final userId = Api.userId;
      if (userId == null || (userId.isEmpty)) return null;

      String deviceId = await Api.getDeviceId();

      Map<String, dynamic> body = {
        'device_id': deviceId,
        'platform': ENV.platform,
        'order_type': orderType,
        'sku_id': skuId,
        'user_id': userId,
      };

      if (createImg != null) {
        body['create_img'] = createImg;
      }
      if (createVideo != null) {
        body['create_video'] = createVideo;
      }

      var res = await api.request(
        ApiConstants.createAndOrder,
        method: HttpMethod.post,
        data: body,
      );

      var result = BaseModel.fromJson(res.data, (data) => Order.fromJson(data));
      return result.data;
    } catch (e) {
      return null;
    }
  }

  // 安卓验签
  static Future<bool> verifyAndOrder({
    required String originalJson,
    required String purchaseToken,
    required String orderType,
    required String skuId,
    required String orderId,
    bool? dres,
    bool? createImg,
    bool? createVideo,
  }) async {
    try {
      final userId = Api.userId;
      if (userId == null || (userId.isEmpty)) {
        log.w('verifyAndOrder: 用户ID为空');
        return false;
      }
      String androidId = await DI.storage.getDeviceId(isOrigin: true);
      final adid = await InfoUtils.getAdid();
      final gpsAdid = await InfoUtils.getGoogleAdId();
      var body = <String, dynamic>{
        'original_json': originalJson,
        'purchase_token': purchaseToken,
        'order_type': orderType,
        'sku_id': skuId,
        'order_id': orderId,
        'android_id': androidId,
        'gps_adid': gpsAdid,
        'adid': adid,
        'user_id': userId,
      };
      if (dres != null) {
        body['dres'] = dres;
      }
      if (createImg != null) {
        body['create_img'] = createImg;
      }
      if (createVideo != null) {
        body['create_video'] = createVideo;
      }
      log.d('verifyAndOrder: 请求参数构建完成 - ${body.keys.join(", ")}');
      var res = await api.request(
        ApiConstants.verifyAndOrder,
        method: HttpMethod.post,
        data: body,
      );
      final data = BaseModel.fromJson(res.data, null);
      if (data.code == 0 || data.code == 200) {
        log.d('verifyAndOrder:  ✅');
        return true;
      }
      log.w('verifyAndOrder: ❌- code: ${data.code}');
      return false;
    } catch (e) {
      log.e('verifyAndOrder: 异常 - $e');
      return false;
    }
  }
}
