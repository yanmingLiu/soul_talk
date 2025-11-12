import '../../app/di_depency.dart';
import '../network/dio_client.dart';

DioClient api = DI.dio;

class Api {
  Api._();

  static Map<String, dynamic> get queryParameters =>
      DI.storage.isBest ? {'v': 'C001'} : {};

  static String? get userId => DI.login.currentUser?.id;

  static Future<String> getDeviceId() async {
    return await DI.storage.getDeviceId();
  }
}
