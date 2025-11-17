import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/presentation/ap/bh001/p/h_p_search_page.dart';
import 'package:soul_talk/presentation/ap/bh001/p/h_tag_page.dart';
import 'package:soul_talk/presentation/ap/cc002/p/center_page.dart';
import 'package:soul_talk/presentation/ap/cc002/p/domino_edit_page.dart';
import 'package:soul_talk/presentation/ap/cc002/p/domino_page.dart';
import 'package:soul_talk/presentation/ap/cc002/p/msg_page.dart';
import 'package:soul_talk/presentation/ap/dm003/a_z_page.dart';
import 'package:soul_talk/presentation/ap/p006/p/p006_guide_page.dart';
import 'package:soul_talk/presentation/ap/p006/p/p006_page.dart';

import '../presentation/ap/am000/l_p.dart';
import '../presentation/ap/am000/m_p.dart';
import '../presentation/ap/fv005/p/cons_page.dart';
import '../presentation/ap/fv005/p/vip_page.dart';
import '../presentation/v000/image_preview.dart';
import '../presentation/v000/video_preview.dart';
import 'route_constants.dart';

class Routes {
  Routes._();

  static final List<GetPage> pages = [
    GetPage(name: RouteConstants.launch, page: () => const LaunchPage()),
    GetPage(name: RouteConstants.root, page: () => const RootPage()),
    GetPage(name: RouteConstants.gems, page: () => const ConsPage()),
    GetPage(
      name: RouteConstants.chooseLang,
      page: () => const ChooseLangPage(),
    ),
    GetPage(name: RouteConstants.search, page: () => const HSearchPage()),
    GetPage(name: RouteConstants.message, page: () => const MessagePage()),
    GetPage(name: RouteConstants.profile, page: () => const ChaterCenterPage()),
    GetPage(name: RouteConstants.mask, page: () => const DominoPage()),
    GetPage(name: RouteConstants.maskEdit, page: () => const DominoEditPasge()),

    // GetPage(name: RouteConstants.makeRole, page: () => const MakeRoleScreen()),

    // 特殊过渡效果路由
    GetPage(
      name: RouteConstants.imagePreview,
      page: () => const ImagePreview(),
      transition: Transition.zoom,
      fullscreenDialog: true,
      preventDuplicates: true,
    ),
    GetPage(
      name: RouteConstants.videoPreview,
      page: () => const VideoPreview(),
      fullscreenDialog: true,
      preventDuplicates: true,
    ),

    GetPage(
      name: RouteConstants.homeFilter,
      page: () => const TagChooseScreen(),
      transition: Transition.downToUp,
      fullscreenDialog: true,
      preventDuplicates: true,
      opaque: false,
    ),
    GetPage(
      name: RouteConstants.vip,
      page: () => const PopScope(
        canPop: false, // 禁止返回键
        child: VipPage(),
      ),
      popGesture: false, // 禁用 iOS 侧滑返回
      preventDuplicates: true,
    ),

    GetPage(
      name: RouteConstants.phone,
      page: () => const P006Page(),
      transition: Transition.downToUp,
      popGesture: false,
      preventDuplicates: true,
      fullscreenDialog: true,
    ),
    
    GetPage(
      name: RouteConstants.phoneGuide,
      page: () => const P006GuidePage(),
      transition: Transition.downToUp,
      popGesture: false,
      preventDuplicates: true,
      fullscreenDialog: true,
    ),

    // GetPage(
    //   name: RouteConstants.countSku,
    //   page: () => const AiCountSkuPage(),
    //   transition: Transition.downToUp,
    //   popGesture: false,
    //   preventDuplicates: true,
    //   fullscreenDialog: true,
    // ),
  ];
}
