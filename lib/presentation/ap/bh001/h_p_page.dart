import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/app/di_depency.dart';
import 'package:soul_talk/domain/value_objects/enums.dart';
import 'package:soul_talk/presentation/ap/bh001/h_a_c_bloc.dart';
import 'package:soul_talk/presentation/ap/bh001/h_bloc.dart';
import 'package:soul_talk/presentation/v000/base_scaffold.dart';
import 'package:soul_talk/presentation/v000/button.dart';
import 'package:soul_talk/presentation/v000/consume_button.dart';
import 'package:soul_talk/presentation/v000/linked_controller.dart';
import 'package:soul_talk/presentation/v000/linked_item.dart';
import 'package:soul_talk/presentation/v000/loading.dart';
import 'package:soul_talk/presentation/v000/v_dialog.dart';
import 'package:soul_talk/router/app_routers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final ctr = Get.put(HomeBloc());

  late LinkedController _linkedController;

  @override
  void initState() {
    super.initState();

    Get.put(AutoCallBloc());

    _linkedController = LinkedController(items: ctr.categroyList);
  }

  @override
  void dispose() {
    _linkedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          titleSpacing: 12,
          title: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConsumeButton(from: ConsSF.home),
                  Obx(() {
                    return DI.login.vipStatus.value
                        ? SizedBox.shrink()
                        : Button(
                            width: 44,
                            height: 44,
                            child: Center(
                              child: Image.asset(
                                'assets/images/vip@3x.png',
                                width: 28,
                              ),
                            ),
                            onTap: () {
                              AppRoutes.pushVip(VipSF.homevip);
                            },
                          );
                  }),
                  Spacer(),
                  Button(
                    width: 44,
                    height: 44,
                    type: ButtonType.fill,
                    color: Colors.white,
                    child: Center(
                      child: Image.asset(
                        'assets/images/search@3x.png',
                        width: 32,
                      ),
                    ),
                    onTap: () {
                      AppRoutes.pushSearch();
                    },
                  ),
                  if (DI.storage.isBest) ...[
                    SizedBox(width: 16),
                    Button(
                      width: 44,
                      height: 44,
                      type: ButtonType.fill,
                      color: Colors.white,
                      child: Center(
                        child: Image.asset(
                          'assets/images/filter@3x.png',
                          width: 32,
                        ),
                      ),
                      onTap: () {
                        VDialog.showLoginReward();
                      },
                    ),
                  ],
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Discover'),
                  Image.asset('assets/images/star.png', width: 22),
                ],
              ),
            ],
          ),
        ),
        body: AnimatedBuilder(
          animation: _linkedController,
          builder: (_, _) {
            if (_linkedController.items.isEmpty) {
              return Loading.activityIndicator();
            }
            return Column(
              children: [
                buildCategory(),
                Expanded(
                  child: PageView(
                    controller: _linkedController.pageController,
                    pageSnapping: true,
                    onPageChanged: (index) {
                      _linkedController.handlePageChanged(index);
                      ctr.categroy.value = ctr.categroyList[index];
                    },
                    physics: const BouncingScrollPhysics(),
                    children: ctr.pages,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildCategory() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      child: SizedBox(
        height: 44,
        child: Obx(() {
          final list = ctr.categroyList;
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: list.length,
            controller: _linkedController.scrollController,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final data = list[index];
              final isActive = _linkedController.index == index;
              return LinkedItem(
                key: _linkedController.getTabKey(index),
                title: data.title,
                isActive: isActive,
                onTap: () {
                  ctr.onTapCate(data);
                  _linkedController.select(index);
                },
                animation: _linkedController,
              );
            },
          );
        }),
      ),
    );
  }
}
