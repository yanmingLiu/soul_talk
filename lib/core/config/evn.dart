import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Environment { dev, prod }

class ENV {
  ENV._();

  static Environment _currentEnv = Environment.prod;

  static Future<void> initialize(Environment env) async {
    _currentEnv = env;

    String envFile;
    if (env == Environment.dev) {
      envFile = '.env.dev';
    } else {
      envFile = '.env.prod';
    }

    await dotenv.load(fileName: envFile);
  }

  static String get baseUrl => dotenv.get('BASE_URL');

  static bool get isDebugMode => dotenv.get('IS_DEBUG_MODE') == 'true';

  static String get bundleId => Platform.isIOS
      ? dotenv.get('BUNDLE_ID_IOS')
      : dotenv.get('BUNDLE_ID_ANDROID');

  static String get platform => Platform.isIOS
      ? dotenv.get('PLATFORM_IOS')
      : dotenv.get('PLATFORM_ANDROID');

  static String get prefix => dotenv.get('PREFIX');

  static String get privacy => dotenv.get('PRIVACY');

  static String get terms => dotenv.get('TERMS');

  static String get email => dotenv.get('EMAIL');

  static String get appId => dotenv.get('APP_ID');

  static String get adjustId => dotenv.get('ADJUST_ID');

  static Environment get currentEnv => _currentEnv;
}
