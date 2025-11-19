// import 'dart:convert';

// import 'package:dio/dio.dart';

// // IP服务异常类
// class IPServiceException implements Exception {
//   final String message;
//   IPServiceException(this.message);

//   @override
//   String toString() => 'IPServiceException: $message';
// }

// class IpCheck {
//   void _log(dynamic msg) {
//     print('[OtherBlock]: $msg');
//   }

//   final Dio _dio;

//   Map<String, dynamic>? ipInfo;

//   // 构造函数，允许外部传入自定义的Dio实例（便于测试和配置）
//   IpCheck({Dio? dio})
//       : _dio = dio ??
//             Dio(BaseOptions(
//               connectTimeout: const Duration(seconds: 10),
//               receiveTimeout: const Duration(seconds: 5),
//             ));

//   // 获取公网IP地址
//   Future<Map<String, dynamic>?> getPublicIP() async {
//     final ipApis = [
//       'https://api.myip.com', // respons: {"ip":"103.151.173.209","country":"Japan","cc":"JP"}
//       // 'https://api.ipify.org?format=json', // ❌有限流
//       // 'https://ipapi.co/json/', // ❌有错误 429
//     ];
//     for (final api in ipApis) {
//       try {
//         final response = await _dio.get(api);
//         if (response.statusCode == 200) {
//           final data = jsonDecode(response.data);
//           ipInfo = data;
//           _log('ip info: $data');
//           return data;
//         }
//       } catch (e) {
//         _log('API $api 请求失败: $e');
//         continue;
//       }
//     }
//     throw IPServiceException('所有IP查询API均请求失败');
//   }

//   Future<bool> isChina() async {
//     ipInfo ??= await getPublicIP();
//     final cc = ipInfo?['cc'] as String;
//     // {"ip":"185.248.184.161","country":"Taiwan","cc":"TW"}
//     // {"ip":"103.151.172.24","country":"Hong Kong","cc":"HK"}
//     /*
//     因为 国际标准（ISO 3166-1 alpha-2）明确规定：
// 	•	CN = 中国大陆（People’s Republic of China）
// 	•	TW = 台湾（Taiwan）
// 	•	HK = 香港（Hong Kong）
// 	•	MO = 澳门（Macao）
//     */
//     final list = ["TW", "HK", "MO", "CN", "CHN"];
//     return list.contains(cc);
//   }

//   Future<bool> isIreland() async {
//     ipInfo ??= await getPublicIP();
//     final cc = ipInfo?['cc'] as String;
//     return cc.contains('IE');
//   }
// }
