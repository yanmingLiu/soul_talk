import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/app/di_depency.dart';
import 'package:soul_talk/domain/entities/sku.dart';
import 'package:soul_talk/domain/value_objects/enums.dart';
import 'package:soul_talk/presentation/ap/fv005/v/v_tag.dart';
import 'package:soul_talk/presentation/v000/loading.dart';
import 'package:soul_talk/presentation/v000/nav_back_btn.dart';
import 'package:soul_talk/presentation/v000/toast.dart';
import 'package:soul_talk/presentation/v000/v_bottom_btn.dart';
import 'package:soul_talk/utils/pay_utils.dart';

class CSkuPage extends StatefulWidget {
  const CSkuPage({super.key});

  @override
  State<CSkuPage> createState() => _CSkuPageState();
}

class _CSkuPageState extends State<CSkuPage> {
  var aiSkuList = <SKU>[];

  SKU? selectedModel;
  var isVideo = false;
  late ConsSF from;

  @override
  void initState() {
    super.initState();

    var arg = Get.arguments;
    if (arg != null && arg is ConsSF) {
      from = arg;
    }
    isVideo = from == ConsSF.img2v;

    _loadData();

    ever(PayUtils().iapEvent, (event) async {
      if (!mounted) return;

      if (event?.$1 == IAPEvent.goldSucc && event?.$2 != null) {
        await DI.login.fetchUserInfo();
        Get.back(result: true);
      }
    });
  }

  String photoText(int count) {
    if (count == 1) {
      return 'photo_one'.tr;
    } else {
      return 'photo_count'.trParams({'count': count.toString()});
    }
  }

  String videoText(int count) {
    if (count == 1) {
      return 'video_one'.tr;
    } else {
      return 'video_count'.trParams({'count': count.toString()});
    }
  }

  Future<void> _loadData() async {
    Loading.show();
    await PayUtils().query();
    Loading.dismiss();

    var products = PayUtils().consumableList;

    if (isVideo) {
      aiSkuList.assignAll(
        products
            .where((e) => e.createVideo != null && e.createVideo! > 0)
            .toList(),
      );
    } else {
      aiSkuList.assignAll(
        products.where((e) => e.createImg != null && e.createImg! > 0).toList(),
      );
    }

    selectedModel = aiSkuList.firstWhereOrNull(
      (e) => e.id == aiSkuList.last.id,
    );
    setState(() {});
  }

  void buy() async {
    if (selectedModel != null) {
      await PayUtils().buy(selectedModel!, consFrom: from);
    } else {
      Toast.toast('Please choose your product!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        leading: const NavBackBtn(color: Colors.black),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Purchase Balance',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF181818),
                ),
              ),
            ),
            Expanded(
              child: _buildList(),
            ),
            VBottomBtn(onTap: buy, title: 'Continue'),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 14,
      ),
      itemCount: aiSkuList.length,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 4);
      },
      itemBuilder: (BuildContext context, int index) {
        final model = aiSkuList[index];
        bool isSelected = selectedModel?.sku == model.sku;
        var count = 1;
        var countUni = '';
        var uniPart = '';

        if (from == ConsSF.aiphoto) {
          count = model.createImg ?? 1;
          countUni = "photos";
          uniPart = "Photo";
        } else if (from == ConsSF.img2v) {
          count = model.createVideo ?? 1;
          countUni = "videos";
          uniPart = "Video";
        }

        var rawPrice = model.productDetails?.rawPrice ?? 0;
        var oneRawPrice = rawPrice / count;
        double truncated = (oneRawPrice * 100).truncateToDouble() / 100;
        String formattedNumber = truncated.toStringAsFixed(2);
        var onePrice =
            '${model.productDetails?.currencySymbol}$formattedNumber/$uniPart';

        final tag = VTagExt.tag(model.tag);

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedModel = model;
            });
            buy();
          },
          child: Stack(
            children: [
              Container(
                height: 100,
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: BoxBorder.all(
                      width: 2,
                      color:
                          isSelected ? const Color(0xFF55CFDA) : Colors.white,
                    )),
                child: Row(
                  spacing: 12,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          spacing: 2,
                          children: [
                            Image.asset(
                              'assets/images/diamond.png',
                              width: 24,
                            ),
                            Text(
                              '+${model.number ?? 0}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF434343),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          spacing: 2,
                          children: [
                            Text(
                              count.toString(),
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFDF78B1),
                              ),
                            ),
                            Text(
                              countUni,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF434343),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          model.productDetails?.price ?? '--',
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFDF78B1),
                          ),
                        ),
                        Text(
                          onePrice,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF8C8C8C),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (tag != null) tag,
            ],
          ),
        );
      },
    );
  }
}
