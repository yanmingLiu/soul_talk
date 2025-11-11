import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import 'dio_client.dart';

class HeaderInterceptor extends Interceptor {
  // Generate request ID
  String _generateRequestId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final connectivityResult = await DioClient.instance.connectivity
        .checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: 'Network connection unavailable',
          type: DioExceptionType.unknown,
        ),
      );
      return;
    }

    // Add authentication token (if available)
    if (DioClient.instance.token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer ${DioClient.instance.token}';
    }

    // Add request ID for tracking
    options.headers['X-Request-ID'] = _generateRequestId();

    if (DioClient.instance.enableLog) {
      DioClient.instance.logger.d(
        'Request send: ${options.method} ${options.baseUrl} ${options.path}\nRequest headers: ${options.headers}\nRequest body: ${options.data}',
      );
    }
    super.onRequest(options, handler);
  }
}
