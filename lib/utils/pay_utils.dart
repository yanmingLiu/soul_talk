// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:soul_talk/domain/entities/sku.dart';
import 'package:soul_talk/domain/value_objects/enums.dart';

import '../app/di_depency.dart';
import '../core/analytics/analytics_service.dart';
import '../core/data/lo_pi.dart';
import '../core/data/p_pi.dart';
import '../domain/entities/order.dart';
import '../presentation/v000/v_dialog.dart';
import '../presentation/v000/loading.dart';
import '../presentation/v000/toast.dart';
import 'log_util.dart';

enum IAPEvent { vipSucc, goldSucc }

class PayUtils {
  // 单例模式
  static final PayUtils _instance = PayUtils._internal();
  factory PayUtils() => _instance;
  PayUtils._internal() {
    _initIAP();
  }

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  Set<String> _consumableIds = {};
  Set<String> _subscriptionIds = {};

  List<SKU> allList = [];
  List<SKU> consumableList = [];
  List<SKU> subscriptionList = [];

  VipSF? _vipFrom;
  ConsSF? _consFrom;
  Order? _orderData;

  bool _isUserBuy = false;
  SKU? _currentSkuData;

  final RxInt _eventCounter = 0.obs;
  Rxn<(IAPEvent, String, int)> iapEvent = Rxn<(IAPEvent, String, int)>();

  bool? get _createImg =>
      (_consFrom == ConsSF.aiphoto || _consFrom == ConsSF.undr) ? true : null;

  bool? get _createVideo => _consFrom == ConsSF.img2v ? true : null;

  // 初始化 IAP
  void _initIAP() {
    _subscription = _inAppPurchase.purchaseStream.listen(
      (purchaseDetailsList) => _processPurchaseDetails(purchaseDetailsList),
      onError: (error) => log.e('[iap] 购买监听错误: $error'),
      onDone: () {
        log.d('[iap] 购买监听完成');
        Loading.dismiss();
      },
    );
  }

  // 查询产品详情
  Future<void> query() async {
    if (allList.isNotEmpty) {
      return;
    }
    if (!await _isAvailable()) return;
    // iOS 平台特定逻辑
    await _finishTransaction();

    // 请求服务器，拿到所有 SkuData 列表
    await _getSkuDatas();
    if (allList.isEmpty) {
      return;
    }
    // SkuData ids
    final skuDataIds = _consumableIds.union(_subscriptionIds);

    final response = await _inAppPurchase
        .queryProductDetails(skuDataIds)
        .timeout(const Duration(seconds: 10));
    if (response.notFoundIDs.isNotEmpty) {
      log.e('[iap] notFoundIDs: ${response.notFoundIDs}');
    }

    for (final productDetails in response.productDetails) {
      final skuData = allList.firstWhereOrNull(
        (e) => e.sku == productDetails.id,
      );
      if (skuData != null) {
        skuData.productDetails = productDetails;
      }
    }

    // 根据 sku.orderNum 从小到大排序
    consumableList =
        allList.where((sku) => _consumableIds.contains(sku.sku)).toList()
          ..sort((a, b) => (a.orderNum ?? 0).compareTo(b.orderNum ?? 0));

    subscriptionList =
        allList.where((sku) => _subscriptionIds.contains(sku.sku)).toList()
          ..sort((a, b) => (a.orderNum ?? 0).compareTo(b.orderNum ?? 0));
  }

  Future<void> _getSkuDatas() async {
    log.d('[iap] _getSkuDatas');
    final list = await PayApi.getSkuList();
    allList = list ?? [];

    _consumableIds = allList
        .where((e) => e.skuType == 0 && e.shelf == true)
        .map((e) => e.sku ?? '')
        .toSet();
    _subscriptionIds = allList
        .where((e) => e.skuType != 0 && e.shelf == true)
        .map((e) => e.sku ?? '')
        .toSet();
    log.d('[iap] _consumableIds: $_consumableIds');
    log.d('[iap] _subscriptionIds: $_subscriptionIds');
  }

  // 购买产品
  Future<void> buy(SKU data, {VipSF? vipFrom, ConsSF? consFrom}) async {
    try {
      Loading.show();
      if (!await _isAvailable()) return;
      await _finishTransaction();
      _vipFrom = vipFrom;
      _consFrom = consFrom;
      _isUserBuy = true;
      _currentSkuData = data;

      final productDetails = data.productDetails;
      if (productDetails == null) {
        Loading.dismiss();
        log.e('[iap] buy productDetails is null');
        Toast.toast('So sorry, ProductDetails is null.');
        return;
      }

      await _createOrder(productDetails);

      String? orderNo = _orderData?.orderNo;
      if (orderNo == null || orderNo.isEmpty) {
        Loading.dismiss();
        Toast.toast('create order error');
        return;
      }

      final purchaseParam = PurchaseParam(
        productDetails: productDetails,
        applicationUserName: orderNo,
      );

      final isConsumable = data.skuType == 0;

      await (isConsumable
          ? _inAppPurchase.buyConsumable(purchaseParam: purchaseParam)
          : _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam));
    } catch (e) {
      await Loading.dismiss();
      Toast.toast(e.toString());
      log.e('[iap] catch: $e');
    }
  }

  // 恢复购买
  Future<void> restore({bool isNeedShowLoading = true}) async {
    if (!await _isAvailable()) return;

    log.d('[iap] restore.....');
    _isUserBuy = true;
    await _inAppPurchase.restorePurchases();
  }

  // 处理购买详情
  Future<void> _processPurchaseDetails(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    if (purchaseDetailsList.isEmpty) {
      log.d('[iap] 购买详情列表为空，可能是取消支付');
      Loading.dismiss();
      return;
    }

    // 按交易日期降序排序
    purchaseDetailsList.sort(
      (a, b) => (int.tryParse(b.transactionDate ?? '0') ?? 0).compareTo(
        int.tryParse(a.transactionDate ?? '0') ?? 0,
      ),
    );

    final first = purchaseDetailsList.first;

    for (var purchaseDetails in purchaseDetailsList) {
      switch (purchaseDetails.status) {
        case PurchaseStatus.purchased:
          if (first.purchaseID == purchaseDetails.purchaseID ||
              _currentSkuData?.sku == purchaseDetails.productID) {
            await _handleSuccessfulPurchase(purchaseDetails);
          }
          break;
        case PurchaseStatus.restored:
          await _handleSuccessfulPurchase(purchaseDetails);
          break;

        case PurchaseStatus.error:
          _handlePurchaseError(purchaseDetails);
          break;

        case PurchaseStatus.canceled:
          Loading.dismiss();
          break;

        case PurchaseStatus.pending:
          Loading.show();
          break;
      }

      // 处理挂起的交易
      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
        log.d('[iap] 完成挂起的交易: ${purchaseDetails.productID}');
      }
    }
  }

  Future<void> _handleSuccessfulPurchase(
    PurchaseDetails purchaseDetails,
  ) async {
    log.d(' 购买成功 status: ${purchaseDetails.status}');
    log.d(
      ' 购买成功 pendingCompletePurchase: ${purchaseDetails.pendingCompletePurchase}',
    );
    log.d(
      '[iap] 成功购买: ${purchaseDetails.productID}, ${purchaseDetails.purchaseID}, ${purchaseDetails.transactionDate}',
    );
    if (!_isUserBuy) {
      log.d('[iap] 自动购买, 不需要处理');
      return;
    }

    if (await _verifyAndCompletePurchase(purchaseDetails)) {
      await _markPurchaseAsProcessed(purchaseDetails.purchaseID);
    } else {
      log.e('[iap] 验证失败: ${purchaseDetails.productID}');
    }
    _isUserBuy = false;
    _currentSkuData = null;
    await _inAppPurchase.completePurchase(purchaseDetails);
  }

  void _handlePurchaseError(PurchaseDetails purchaseDetails) {
    final error = purchaseDetails.error;
    _handleError(
      IAPError(
        source: error?.source ?? '',
        code: error?.code ?? '',
        message: purchaseDetails.status.name,
      ),
    );
  }

  Future<bool> _verifyAndCompletePurchase(
    PurchaseDetails purchaseDetails,
  ) async {
    bool isValid = await verifyPurchaseWithServer(purchaseDetails);
    Loading.dismiss();
    if (isValid) {
      _reportPurchase(purchaseDetails);
      await DI.login.fetchUserInfo();
    }
    return isValid;
  }

  Future<bool> verifyPurchaseWithServer(PurchaseDetails purchaseDetails) async {
    if (Platform.isIOS) return await _verifyApple(purchaseDetails);
    if (Platform.isAndroid) return await _verifyGoogle(purchaseDetails);
    return false;
  }

  Future<bool> _verifyApple(PurchaseDetails purchaseDetails) async {
    try {
      final purchaseID = purchaseDetails.purchaseID;
      final transactionDate = purchaseDetails.transactionDate;
      final productID = purchaseDetails.productID;
      log.d('[iap] purchaseID: $purchaseID, transactionDate:$transactionDate');

      // 获取服务器验证数据 v2
      var receipt = purchaseDetails.verificationData.serverVerificationData;
      final localVerificationData =
          purchaseDetails.verificationData.localVerificationData;
      log.d('[iap] receipt: $receipt');
      log.d('[iap] localVerificationData: $localVerificationData');

      // 如果没有 v2 票据，就刷新并获取 v1 票据
      if (receipt.isEmpty) {
        // 刷新并获取 v1 票据 ：
        final iosPlatformAddition = InAppPurchase.instance
            .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
        PurchaseVerificationData? verificationData = await iosPlatformAddition
            .refreshPurchaseVerificationData();

        String? vdl =
            verificationData?.localVerificationData; // 这就是 v1 的 Base64 字符串
        String? vds = verificationData?.serverVerificationData;
        log.d('[iap] vdl: $vdl');
        log.d('[iap] vds: $vds');

        receipt = vds ?? '';
      }

      var result = await PayApi.verifyIosOrder(
        receipt: receipt,
        skuId: productID,
        transactionId: purchaseID,
        purchaseDate: transactionDate,
        orderId: _orderData?.id ?? 0,
        createImg: _createImg,
        createVideo: _createVideo,
      );
      return result;
    } catch (e) {
      _handleError(IAPError(source: '', code: '400', message: e.toString()));
      return false;
    } finally {
      _orderData = null;
    }
  }

  Future<bool> _verifyGoogle(PurchaseDetails purchaseDetails) async {
    try {
      final googleDetail = purchaseDetails as GooglePlayPurchaseDetails;
      final result = await PayApi.verifyAndOrder(
        originalJson: googleDetail.billingClientPurchase.originalJson,
        purchaseToken: googleDetail.billingClientPurchase.purchaseToken,
        skuId: purchaseDetails.productID,
        orderType: _subscriptionIds.contains(purchaseDetails.productID)
            ? 'SUBSCRIPTION'
            : 'GEMS',
        orderId: _orderData?.orderNo ?? '',
        createImg: _createImg,
        createVideo: _createVideo,
      );

      _orderData = null;
      return result;
    } catch (e) {
      _handleError(IAPError(source: '', code: '400', message: e.toString()));
      return false;
    }
  }

  Future<void> _createOrder(ProductDetails productDetails) async {
    final orderType = _consumableIds.contains(productDetails.id)
        ? 'GEMS'
        : 'SUBSCRIPTION';

    if (Platform.isIOS) {
      try {
        final order = await PayApi.makeIosOrder(
          orderType: orderType,
          skuId: productDetails.id,
          createImg: _createImg,
          createVideo: _createVideo,
        );
        if (order == null || order.id == null) {
          throw Exception('Creat order error');
        }
        _orderData = order;
      } catch (e) {
        Toast.toast('create order error: $e');
        rethrow;
      }
    }
    if (Platform.isAndroid) {
      try {
        final order = await PayApi.makeAndOrder(
          orderType: orderType,
          skuId: productDetails.id,
          createImg: _createImg,
          createVideo: _createVideo,
        );
        if (order == null || order.orderNo == null) {
          throw Exception('Creat order error');
        }

        _orderData = order;
      } catch (e) {
        Toast.toast('create order error: $e');
        rethrow;
      }
    }
  }

  Future _finishTransaction() async {
    // iOS 平台特定逻辑
    if (Platform.isIOS) {
      final iosPlatformAddition = _inAppPurchase
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());

      // 清理挂起的交易
      final transactions = await SKPaymentQueueWrapper().transactions();
      for (var transaction in transactions) {
        await SKPaymentQueueWrapper().finishTransaction(transaction);
      }
    }
  }

  // 工具方法：标记购买为已处理
  Future<void> _markPurchaseAsProcessed(String? purchaseID) async {
    // if (purchaseID != null) await _storage.write(key: purchaseID, value: 'processed');
  }

  // Future<bool> _isPurchaseProcessed(String? purchaseID) async {
  //   if (purchaseID == null) return false;
  //   final value = await _storage.read(key: purchaseID);
  //   return value == 'processed';
  // }

  Future<bool> _isAvailable() async {
    final isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      await Loading.show();
      Toast.toast('iap not support');
    }
    return isAvailable;
  }

  void _reportPurchase(PurchaseDetails purchaseDetails) {
    log.d('[iap] 上报购买事件: ${purchaseDetails.productID}');
    final id = purchaseDetails.productID;
    var path = '';
    var from = '';
    _eventCounter.value++;

    if (_consumableIds.contains(id)) {
      path = 'gems';
      from = _consFrom?.name ?? '';
      logEvent('suc_gems');
      final name = 'suc_${path}_${id}_$from';
      log.d('[iap] report: $name');
      logEvent(name);
      if (_consFrom != ConsSF.undr &&
          _consFrom != ConsSF.creaimg &&
          _consFrom != ConsSF.creavideo &&
          _consFrom != ConsSF.aiphoto &&
          _consFrom != ConsSF.img2v) {
        _showRechargeSuccess(id);
      }
      iapEvent.value = (IAPEvent.goldSucc, id, _eventCounter.value);
    } else {
      path = 'sub';
      from = _vipFrom?.name ?? '';
      logEvent('suc_sub');
      final name = 'suc_${path}_${id}_$from';
      log.d('[iap] report: $name');
      logEvent(name);
      _handleVipSuccess();
      iapEvent.value = (IAPEvent.vipSucc, id, _eventCounter.value);
    }
  }

  void _handleVipSuccess() {
    if (_vipFrom == VipSF.dailyrd) {
      _dailyrdSubSuccess();
    } else {
      Get.back();
    }
  }

  void _dailyrdSubSuccess() async {
    Loading.show();
    await LoginApi.getDailyReward();
    await DI.login.fetchUserInfo();
    Loading.dismiss();

    VDialog.dismiss();
    Get.back();
  }

  void _showRechargeSuccess(String productID) {
    logEvent('t_suc_gems');

    final number = _currentSkuData?.number ?? 0;
    VDialog.showRechargeSuccess(number);
  }

  void _handleError(IAPError error) {
    Loading.dismiss();
    log.e('[iap] 错误: ${error.message}');
    Toast.toast(error.message);
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }
}

/// Example implementation of the
/// [`SKPaymentQueueDelegate`](https://developer.apple.com/documentation/storekit/skpaymentqueuedelegate?language=objc).
///
/// The payment queue delegate can be implementated to provide information
/// needed to complete transactions.
class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
    SKPaymentTransactionWrapper transaction,
    SKStorefrontWrapper storefront,
  ) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
