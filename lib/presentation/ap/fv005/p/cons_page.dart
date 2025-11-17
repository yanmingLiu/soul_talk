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
import 'package:soul_talk/presentation/v000/v_sheet.dart';
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
        ? "1 text message: 2 gems\n1 audio message: 4 gems\nCall AI characters: 10 gems/min"
        : "1 text message: 2 gems\nCall AI characters: 10 gems/min";
    List<String> strList = str.split('\n');

    VSheet.show(
      ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0x0FDF78B1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Image.asset('assets/images/diamond.png', width: 20),
                Text(
                  strList[index],
                  style: const TextStyle(
                    color: Color(0xFF454545),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 12);
        },
        itemCount: strList.length,
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const NavBackBtn(color: Colors.black),
        actions: [
          VButton(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            onTap: _showHelp,
            child: const Center(
              child: Text(
                'Rules',
                style: TextStyle(
                  color: Color(0xFF8C8C8C),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                  decorationColor: Color(0xFF8C8C8C),
                  decorationThickness: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 100,
                          padding: const EdgeInsets.symmetric(horizontal: 28),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF1F9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(() {
                                      return Text(
                                        DI.login.gemBalance.value.toString(),
                                        style: const TextStyle(
                                          color: Color(0xFFDF78B1),
                                          fontSize: 28,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      );
                                    }),
                                    const Text(
                                      'Remaining gems',
                                      style: TextStyle(
                                        color: Color(0xFF8C8C8C),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Image.asset(
                                'assets/images/diamond22@3x.png',
                                width: 70,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          DI.storage.isBest
                              ? 'Open chats and Unlock Hot photo, Porn Video, Moans,Generate Images & Videos,Call Girls!'
                              : '· Buy gems to open chats ·',
                          style: const TextStyle(
                            color: Color(0xFF8C8C8C),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildList(),
                  ],
                ),
              ),
            ),
            Column(
              spacing: 20,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
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
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFF2F9), Color(0xFFFFFFFF)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      VButton(
                        height: 48,
                        color: const Color(0xFF55CFDA),
                        onTap: _buy,
                        margin: const EdgeInsets.symmetric(horizontal: 28),
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
                      const PrivacyView(
                        type: PolicyBottomType.gems,
                        textColor: Color(0x40000000),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
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
            style: TextStyle(color: Color(0xFF8C8C8C)),
          ),
        ),
      );
    }
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 0,
        crossAxisSpacing: 8,
        childAspectRatio: 170.0 / 100.0,
      ),
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
        String price = item.productDetails?.price ?? '-';

        return InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            _chooseProduct = item;
            setState(() {});
          },
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF55CFDA)
                        : const Color(0x0F000000),
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 4,
                  children: [
                    Text(
                      discount,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF8C8C8C),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/diamond.png', width: 20),
                        Text(
                          numericPart,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFDF78B1),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF434343),
                      ),
                    ),
                  ],
                ),
              ),
              if (bestChoice)
                Row(
                  children: [
                    Container(
                      height: 20,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF16C576), Color(0xFF4EAB7A)],
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Best Value',
                          style: TextStyle(
                            fontSize: 10,
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
        );
      },
      itemCount: list.length,
    );
  }
}
