import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:soul_talk/core/config/evn.dart';
import 'package:soul_talk/utils/crypto_util.dart';

class CryptoInterceptor extends Interceptor {
  void _log(dynamic content) {
    print("[CryptoInterceptor]: $content");
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      // 1. 加密 URL（路径和查询参数）
      final encryptedUrl = CryptoUtil.encryptUrl(
        originalUrl: options.uri.toString(),
        prefix: ENV.prefix,
      );
      final newUri = Uri.parse(encryptedUrl);
      _log("加密后的URL: $encryptedUrl");
      options.path = newUri.path;
      // 2. 加密请求体参数（data）
      if (options.contentType == 'multipart/form-data') {
        _log("multipart/form-data 类型，不加密请求体参数");
      } else {
        options.data = CryptoUtil.encryptParams(options.data);
        _log("加密后的请求体参数: ${options.data}");
      }

      super.onRequest(options, handler);
    } catch (e) {
      // 加密失败时抛出错误
      handler.reject(
        DioException(
          requestOptions: options,
          message: "onRequest encrypt data Error: $e",
        ),
      );
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    _log("解密前响应: ${response.data}");
    try {
      final decryptedData = CryptoUtil.decrypt(response.data); // 实际需替换为对称解密
      final jsonData = await compute(json.decode, decryptedData);
      response.data = jsonData;
      _log("解密后json: $jsonData");

      super.onResponse(response, handler);
    } catch (e, stackTrace) {
      _log("解密失败: $e");
      _log("解密失败堆栈: $stackTrace");

      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          error: e,
          message: "onResponse decrypt data Error: $e",
        ),
      );
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 打印原始错误响应数据
    _log("onError: ${err.response?.data}");
    super.onError(err, handler);
  }
}
