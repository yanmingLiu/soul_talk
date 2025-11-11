import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:logger/logger.dart';

import 'crypto_interceptor.dart';
import 'error_interceptor.dart';
import 'header_interceptor.dart';

enum HttpMethod {
  get('GET'),
  post('POST'),
  put('PUT'),
  delete('DELETE'),
  head('HEAD'),
  options('OPTIONS'),
  patch('PATCH');

  const HttpMethod(this.value);
  final String value;
}

/// Dio utility class
class DioClient {
  static final DioClient _instance = DioClient._internal();
  DioClient._internal();
  static DioClient get instance => _instance;

  late Dio _dio;
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );
  Logger get logger => _logger;

  final Connectivity connectivity = Connectivity();

  // Direct storage properties
  String _token = '';
  String _proxy = '';
  bool enableLog = true;

  String get token => _token;

  // Basic configuration
  static const String _baseUrl = '';
  static const int _connectTimeout = 30000;
  static const int _receiveTimeout = 30000;
  static const int _sendTimeout = 30000;

  // 初始化Dio实例
  void init({String? baseUrl, Map<String, String>? headers}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? _baseUrl,
        connectTimeout: const Duration(milliseconds: _connectTimeout),
        receiveTimeout: const Duration(milliseconds: _receiveTimeout),
        sendTimeout: const Duration(milliseconds: _sendTimeout),
        // responseType: ResponseType.plain, // 关闭自动解析
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          ...?headers,
        },
      ),
    );

    // Add interceptors
    _addInterceptors();

    // Configure proxy (if needed)
    _setupProxy();

    _logger.i('Dio initialization completed');
  }

  // Get Dio instance
  Dio get dio => _dio;

  // 设置全局 header
  void setHeader(String key, dynamic value) {
    _dio.options.headers[key] = value;
  }

  // 批量设置全局 headers
  void setHeaders(Map<String, dynamic> headers) {
    _dio.options.headers.addAll(headers);
  }

  // 移除全局 header
  void removeHeader(String key) {
    _dio.options.headers.remove(key);
  }

  // Add interceptors
  void _addInterceptors() {
    // Add header interceptor
    _dio.interceptors.add(HeaderInterceptor());

    // Add crypto interceptor
    _dio.interceptors.add(CryptoInterceptor());

    // Add error interceptor
    _dio.interceptors.add(ErrorInterceptor());
  }

  // Setup proxy (if needed)
  void _setupProxy() {
    if (_proxy.isNotEmpty) {
      (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        client.findProxy = (uri) {
          return 'PROXY $_proxy';
        };
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      };
    }
  }

  // 通用请求方法
  Future<Response<T>> request<T>(
    String path, {
    required HttpMethod method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final requestOptions = options ?? Options();

      return await _dio.request<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: requestOptions.copyWith(method: method.value),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      _logger.e('$method request failed: $path', error: e);
      rethrow;
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return request(
      path,
      method: HttpMethod.post,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return request(
      path,
      method: HttpMethod.get,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  // File upload
  Future<Response> uploadFile(
    String path, {
    required FormData data,
    Options? options,
    ProgressCallback? onSendProgress,
    int? maxRetryCount,
    CancelToken? cancelToken,
  }) async {
    try {
      final ops = options ?? Options();
      ops.extra = {};

      // Set retry count (if provided)
      if (maxRetryCount != null) {
        ops.extra!['maxRetryCount'] = maxRetryCount;
      }

      return await request(
        path,
        method: HttpMethod.post,
        data: data,
        options: ops,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
    } catch (e) {
      _logger.e('File upload failed: $path', error: e);
      rethrow;
    }
  }

  // File download
  Future<Response> downloadFile(
    String urlPath,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    Options? options,
    int? maxRetryCount,
    CancelToken? cancelToken,
  }) async {
    try {
      final requestOptions = options ?? Options();
      requestOptions.extra ??= {};

      // Set retry count (if provided)
      if (maxRetryCount != null) {
        requestOptions.extra!['maxRetryCount'] = maxRetryCount;
      }

      return await _dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        options: requestOptions,
        cancelToken: cancelToken,
      );
    } catch (e) {
      _logger.e('File download failed: $urlPath', error: e);
      rethrow;
    }
  }

  // Set proxy
  void setProxy(String proxy) {
    _proxy = proxy;
    _setupProxy();
    _logger.i('Proxy set: $proxy');
  }

  // Clear proxy
  void clearProxy() {
    _proxy = '';
    _setupProxy();
    _logger.i('Proxy cleared');
  }

  // Set authentication token
  void setAuthToken(String token) {
    _token = token;
    _logger.i('Authentication token set');
  }

  // Clear authentication token
  void clearAuthToken() {
    _token = '';
    _logger.i('Authentication token cleared');
  }
}
