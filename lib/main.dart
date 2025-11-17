import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:soul_talk/app/di_depency.dart';
import 'package:soul_talk/core/config/evn.dart';
import 'package:soul_talk/core/constants/vs.dart';
import 'package:soul_talk/router/route_constants.dart';
import 'package:soul_talk/utils/navigator_obs.dart';

import 'core/analytics/analytics_service.dart';
import 'router/routes.dart';
import 'utils/log_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Change to Environment.prod for production
  await DIDendency.init(env: Environment.dev);

  /// 控制图片缓存大小
  PaintingBinding.instance.imageCache.maximumSize = 100;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 50 << 20;

  try {
    final isFirstLaunch = DI.storage.isRestart == false;
    if (isFirstLaunch) {
      Analytics().logInstallEvent();
    }
    Analytics().logSessionEvent();
  } catch (e, s) {
    log.e('===> main error: $e\n$s');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SoulTalk',
      themeMode: ThemeMode.light,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        fontFamily: 'Montserrat',
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
        appBarTheme: AppBarTheme(
          color: Colors.transparent,
          centerTitle: true,
          scrolledUnderElevation: 0.0,
          elevation: 0.0,
          titleSpacing: 12,
          titleTextStyle: TextStyle(
            color: Color(0xFF181818),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // 国际化
      supportedLocales: VS.supportedLocales,
      locale: DI.login.locale,
      fallbackLocale: const Locale('en', 'US'),
      translationsKeys: {},
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeListResolutionCallback: (locales, supportedLocales) {
        return locales?.firstWhere(
          (l) => supportedLocales.any((s) => s.languageCode == l.languageCode),
          orElse: () => supportedLocales.first,
        );
      },
      builder: FlutterSmartDialog.init(
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(1.0)),
            child: child!,
          );
        },
      ),
      initialRoute: RouteConstants.initial,
      getPages: Routes.pages,
      debugShowCheckedModeBanner: false,
      navigatorObservers: [
        FlutterSmartDialog.observer,
        NavigatorObs.instance.observer,
        GetXRouterObserver(),
      ],
    );
  }
}
