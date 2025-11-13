import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/app/di_depency.dart';
import 'package:soul_talk/core/analytics/analytics_service.dart';
import 'package:soul_talk/domain/entities/sku.dart';
import 'package:soul_talk/domain/value_objects/enums.dart';
import 'package:soul_talk/presentation/ap/fv005/v/v_team.dart';
import 'package:soul_talk/presentation/v000/loading.dart';
import 'package:soul_talk/presentation/v000/nav_back_btn.dart';
import 'package:soul_talk/presentation/v000/v_button.dart';
import 'package:soul_talk/presentation/v000/v_dialog.dart';
import 'package:soul_talk/utils/info_utils.dart';
import 'package:soul_talk/utils/pay_utils.dart';

class ConsPage extends StatefulWidget {
  const ConsPage({super.key});

  @override
  State<ConsPage> createState() => _ConsPageState();
}

class _ConsPageState extends State<ConsPage> {
  SKU? _chooseProduct;

  late ConsSF from;

  List<SKU> list = [];

  @override
  void initState() {
    super.initState();

    InfoUtils.getIdfa();

    _loadData();

    if (Get.arguments != null && Get.arguments is ConsSF) {
      from = Get.arguments;
    }

    logEvent('t_paygems');
  }

  Future<void> _loadData() async {
    Loading.show();
    await PayUtils().query();
    setState(() {});
    Loading.dismiss();

    list = PayUtils().consumableList;
    _chooseProduct = list.firstWhereOrNull((e) => e.defaultSku == true);
    setState(() {});
  }

  void _showHelp() {
    final str = DI.storage.isBest
        ? "1 text message: 2 gems\\n1 audio message: 4 gems\\nCall AI characters: 10 gems/min"
        : "1 text message: 2 gems\\nCall AI characters: 10 gems/min";
    List<String> strList = str.split('\n');

    VDialog.show(
      clickMaskDismiss: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: const Color(0xFF333333),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(strList.length, (index) {
            return Column(
              children: [
                Row(
                  children: [
                    Image.asset('assets/images/diamond.png', width: 24),
                    const SizedBox(width: 8),
                    Text(
                      strList[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            );
          }),
        ),
      ),
    );
  }

  void _buy() {
    if (_chooseProduct != null) {
      logEvent('c_paygems');
      PayUtils().buy(_chooseProduct!, consFrom: from);
    }
  }

  @override
  Widget build(BuildContext context) {
    final price = _chooseProduct?.productDetails?.price ?? '_';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leadingWidth: 100,
        leading: const Row(children: [SizedBox(width: 16), NavBackBtn()]),
        actions: [
          VButton(
            width: 44,
            height: 44,
            onTap: _showHelp,
            child: const Center(child: Text('Rules')),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 57),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height:
                              kToolbarHeight +
                              MediaQuery.paddingOf(context).top +
                              16,
                        ),
                        Text(
                          DI.storage.isBest
                              ? 'Open chats and Unlock Hot photo, Porn Video, Moans,Generate Images & Videos,Call Girls!'
                              : '· Buy gems to open chats ·',

                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildList(),
                  const SizedBox(height: 180),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: const Color(0xFF111111),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  list.isEmpty == false
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            'Please note that a one-time purchase will result in a one-time charge of $price to you.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF727374),
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                  const SizedBox(height: 16),
                  VButton(
                    color: const Color(0xFF3F8DFD),
                    onTap: _buy,

                    margin: const EdgeInsets.symmetric(horizontal: 65),
                    child: Center(
                      child: Text(
                        DI.storage.isBest ? 'Continue.' : 'Buy',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const PrivacyView(type: PolicyBottomType.gems),
                  SizedBox(height: context.mediaQueryPadding.bottom),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 根据折扣百分比获取对应的本地化字符串
  String getDiscount(int discountPercent) {
    final num = discountPercent.toString();
    try {
      return 'Save $num';
    } catch (e) {
      // 如果出错，返回硬编码的英文格式
      return 'Save $discountPercent%';
    }
  }

  Widget _buildList() {
    if (list.isEmpty) {
      return const Center(
        child: SizedBox(
          height: 100,
          child: Text(
            "No subscription available",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        final item = list[index];
        final bestChoice = item.tag == 1;
        final isSelected = _chooseProduct?.sku == item.sku;

        // 根据产品信息计算折扣百分比，从90%到0%以20%为步长递减
        // 使用算法计算：90 - (index * 20)，确保不小于0
        int discountPercent = math.max(0, 90 - (index * 20));

        String discount = getDiscount(discountPercent);
        String numericPart = item.number.toString();
        String price = item.productDetails?.price ?? '';

        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              _chooseProduct = item;
              setState(() {});
            },
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: const Color(0x333F8DFD),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF3F8DFD)
                          : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 4),
                      // Assets.images.gemls.image(width: 48),
                      Image.asset('assets/images/diamond.png', width: 24),
                      Text(
                        numericPart,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          Text(
                            discount,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            price,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (bestChoice)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 20,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadiusDirectional.only(
                            topEnd: Radius.circular(16),
                            bottomStart: Radius.circular(16),
                          ),
                          color: Color(0xFF3F8DFD),
                        ),
                        child: const Center(
                          child: Text(
                            'best_choice',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
      itemCount: list.length,
      separatorBuilder: (c, i) => const SizedBox(height: 16),
    );
  }
}
