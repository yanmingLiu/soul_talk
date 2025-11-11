import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/app/di_depency.dart';
import 'package:soul_talk/domain/value_objects/enums.dart';
import 'package:soul_talk/presentation/ap/dm003/profile_bloc.dart';
import 'package:soul_talk/presentation/v000/base_scaffold.dart';
import 'package:soul_talk/presentation/v000/cons_button.dart';
import 'package:soul_talk/presentation/v000/v_button.dart';
import 'package:soul_talk/router/app_routers.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.put(SettingController());

    return BaseScaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          ConsButton(from: ConsSF.me),
          SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Obx(() {
                    return DI.login.vipStatus.value
                        ? Image.asset('assets/images/avatar_vip.png', width: 60)
                        : Image.asset(
                            'assets/images/avatar_normal.png',
                            width: 60,
                          );
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: GestureDetector(
                    onTap: ctr.changeNickName,
                    child: Row(
                      children: [
                        Obx(() {
                          return Text(
                            ctr.nickname.value,
                            style: TextStyle(
                              color: Color(0xFF282828),
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        }),
                        SizedBox(width: 8),
                        Image.asset('assets/images/me_edit.png', width: 16),
                      ],
                    ),
                  ),
                ),

                Obx(() {
                  final isVip = DI.login.vipStatus.value;
                  return isVip
                      ? Container()
                      : GestureDetector(
                          onTap: () {
                            AppRoutes.pushVip(VipSF.mevip);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 16,
                            ),
                            margin: EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/vip_bg.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/vip@3x.png',
                                      width: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Become VIP',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    VButton(
                                      height: 28,
                                      borderRadius: BorderRadius.circular(14),
                                      color: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Upgrade',
                                          style: TextStyle(
                                            color: Color(0xFFDF78B1),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Unlimited message & Unlock 10+ features',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                }),

                Obx(() {
                  final lang = DI.login.sessionLang.value;
                  final name = lang?.label ?? '-';
                  return _buildItem(
                    icon: 'assets/images/nick@3x.png',
                    title: 'Al’s language',
                    subTitle: name,
                    onTap: () {
                      AppRoutes.pushChooseLang();
                    },
                  );
                }),

                _buildItem(
                  icon: 'assets/images/nick@3x(2).png',
                  title: 'Feedback',
                  onTap: () {
                    AppRoutes.toEmail();
                  },
                ),

                _buildItem(
                  icon: 'assets/images/nick@3x(3).png',
                  title: 'Set chat background',
                  onTap: ctr.changeChatBackground,
                ),

                Obx(() {
                  return _buildItem(
                    icon: 'assets/images/nick@3x(1).png',
                    title: 'App version',
                    subTitle: ctr.version.value,
                    onTap: () {
                      AppRoutes.openAppStore();
                    },
                  );
                }),

                _buildItem(
                  icon: 'assets/images/nick@3x(4).png',
                  title: 'Privacy policy',
                  onTap: () {
                    AppRoutes.toPrivacy();
                  },
                ),

                _buildItem(
                  icon: 'assets/images/nick@3x(5).png',
                  title: 'Terms of use',
                  onTap: () {
                    AppRoutes.toTerms();
                  },
                ),
                SizedBox(height: 300),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem({
    required String icon,
    required String title,
    String? subTitle,
    void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 64,
        child: Row(
          children: [
            Image.asset(icon, width: 20),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Color(0xFF999999),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(width: 12),
            Text(
              subTitle ?? '',
              style: TextStyle(
                color: Color(0xFF595959),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(width: 12),
            Image.asset('assets/images/indecateright.png', width: 24),
          ],
        ),
      ),
    );
  }
}
