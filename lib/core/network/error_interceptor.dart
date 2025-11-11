import 'package:dio/dio.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'dio_client.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handleError(err);
    super.onError(err, handler);
  }
}

// Error handling
void handleError(DioException error) {
  String errorMessage = 'Unknown error';

  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      errorMessage = 'Connection timeout';
      break;
    case DioExceptionType.sendTimeout:
      errorMessage = 'Request timeout';
      break;
    case DioExceptionType.receiveTimeout:
      errorMessage = 'Response timeout';
      break;
    case DioExceptionType.badResponse:
      errorMessage = _handleHttpError(error.response?.statusCode ?? 0);
      break;
    case DioExceptionType.cancel:
      errorMessage = 'Request cancelled';
      break;
    case DioExceptionType.connectionError:
      errorMessage = 'Network connection error';
      break;
    case DioExceptionType.badCertificate:
      errorMessage = 'Certificate verification failed';
      break;
    case DioExceptionType.unknown:
      errorMessage = error.error?.toString() ?? 'Unknown error';
      break;
  }

  DioClient.instance.logger.e('Request error: $errorMessage');
  DioClient.instance.logger.e('Error details: ${error.toString()}');

  // You can add global error handling logic here, such as displaying error messages
  SmartDialog.showToast(errorMessage, displayType: SmartToastType.onlyRefresh);
}

// Handle HTTP errors
String _handleHttpError(int statusCode) {
  switch (statusCode) {
    case 400:
      return 'Bad request';
    case 401:
      return 'Unauthorized, please login again';
    case 403:
      return 'Access denied';
    case 404:
      return 'Resource not found';
    case 405:
      return 'Method not allowed';
    case 408:
      return 'Request timeout';
    case 500:
      return 'Internal server error';
    case 502:
      return 'Gateway error';
    case 503:
      return 'Service unavailable';
    case 504:
      return 'Gateway timeout';
    default:
      return 'HTTP error: $statusCode';
  }
}
