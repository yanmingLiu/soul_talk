import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/get.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:soul_talk/app/di_depency.dart';
import 'package:soul_talk/core/data/lo_pi.dart';
import 'package:soul_talk/domain/entities/lang.dart';
import 'package:soul_talk/presentation/ap/dm003/a_z_item_view.dart';
import 'package:soul_talk/presentation/ap/dm003/a_z_model.dart';
import 'package:soul_talk/presentation/v000/empty_view.dart';

class ChooseLangPage extends StatefulWidget {
  const ChooseLangPage({super.key});

  @override
  State<ChooseLangPage> createState() => _ChooseLangPageState();
}

class _ChooseLangPageState extends State<ChooseLangPage> {
  List<AzListContactModel> contactList = [];

  List<String> get symbols => contactList.map((e) => e.section).toList();

  final indexBarContainerKey = GlobalKey();

  bool isShowListMode = true;

  ValueNotifier<AzListCursorInfoModel?> cursorInfo = ValueNotifier(null);

  double indexBarWidth = 20;

  ScrollController scrollController = ScrollController();

  late SliverObserverController observerController;

  Map<int, BuildContext> sliverContextMap = {};

  var choosedName = ''.obs;
  Lang? selectedLang; // 保存选中的语言对象
  EmptyType? emptyType;

  Future<void> generateContactData() async {
    try {
      emptyType = EmptyType.loading;
      if (mounted) {
        setState(() {});
      }
      // 从 IConfig 获取语言数据（内部已处理缓存逻辑）
      await DI.login.loadAppLangs();
      final appLangs = DI.login.appLangs;

      if (appLangs != null) {
        _buildContactListFromData(appLangs);
        emptyType = null;
      }
    } catch (e) {
      debugPrint('Error loading language data: $e');
      // 如果加载失败，可以使用默认数据或显示错误
      emptyType = null;
    }
  }

  // 从数据构建联系人列表的辅助方法
  void _buildContactListFromData(Map<String, dynamic> appLangs) {
    contactList.clear();

    // 遍历每个字母分组
    appLangs.forEach((key, value) {
      if (value is List) {
        List<String> names = [];
        List<Lang> langs = [];

        // 将每个语言项转换为 Lang 对象
        for (var item in value) {
          if (item is Map<String, dynamic>) {
            final lang = Lang.fromJson(item);
            if (lang.label != null) {
              names.add(lang.label!);
              langs.add(lang);
            }
          }
        }

        if (names.isNotEmpty) {
          contactList.add(
            AzListContactModel(section: key, names: names, langs: langs),
          );
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();

    observerController = SliverObserverController(controller: scrollController);

    _loadLanguageData();
  }

  Future<void> _loadLanguageData() async {
    await generateContactData();

    // 设置默认选中的语言
    _setDefaultSelectedLanguage();

    if (mounted) {
      setState(() {});
    }
  }

  /// 设置默认选中的语言
  void _setDefaultSelectedLanguage() {
    try {
      // 使用 UserHelper 的 matchUserLang 方法获取匹配的语言
      final matchedLang = DI.login.matchUserLang();

      if (matchedLang.label != null) {
        choosedName.value = matchedLang.label!;
        selectedLang = matchedLang;
        debugPrint(
          'Default selected language: ${matchedLang.label} - ${matchedLang.value}',
        );
      }
    } catch (e) {
      debugPrint('Error setting default language: $e');
    }
  }

  /// 保存按钮点击处理
  void _onSaveButtonTapped() async {
    if (selectedLang != null) {
      debugPrint(
        'Saving selected language: ${selectedLang!.label} - ${selectedLang!.value}',
      );

      SmartDialog.showLoading();

      final isOK = await LoginApi.updateEventParams(lang: selectedLang?.value);
      if (isOK) {
        DI.login.sessionLang.value = selectedLang;
        await DI.login.fetchUserInfo();
      }

      SmartDialog.dismiss();

      // 返回上一页
      Get.back(result: selectedLang);
    } else {
      debugPrint('No language selected');
      // 可以显示提示信息
      SmartDialog.showToast('Please select a language');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Image.asset(
            'assets/images/back.png',
            color: Colors.black,
            width: 24,
          ),
        ),
        title: const Text('Al’s language'),
      ),
      body: emptyType != null
          ? EmptyView(type: emptyType!)
          : Stack(
              children: [
                SliverViewObserver(
                  controller: observerController,
                  sliverContexts: () {
                    return sliverContextMap.values.toList();
                  },
                  child: CustomScrollView(
                    key: ValueKey(isShowListMode),
                    controller: scrollController,
                    slivers: [
                      // _buildHeader(),
                      ...contactList.mapIndexed((i, e) {
                        return _buildSliver(index: i, model: e);
                      }),
                      SliverToBoxAdapter(child: Container(height: 140)),
                    ],
                  ),
                ),
                // _buildCursor(),
                // Positioned(
                //   top: 0,
                //   bottom: 0,
                //   right: 0,
                //   child: _buildIndexBar(),
                // ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: _buildSaveButton(),
                ),
              ],
            ),
    );
  }

  Container _buildSaveButton() {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ).copyWith(top: 16, bottom: bottom > 0 ? bottom : 16),
      color: Colors.white,
      child: Center(
        child: GestureDetector(
          onTap: _onSaveButtonTapped,
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              color: Color(0xFF55CFDA),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 16),
                Text(
                  'Confirm',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // SliverToBoxAdapter _buildHeader() {
  //   return SliverToBoxAdapter(
  //     child: Container(
  //       padding: EdgeInsets.all(16),
  //       margin: EdgeInsets.all(16),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(12),
  //         gradient: LinearGradient(
  //           begin: Alignment(-0.8, -0.6), // 约等于 111deg
  //           end: Alignment(0.8, 0.6),
  //           stops: [0.0306, 0.5406, 0.9865],
  //           colors: [
  //             Color(0xFFEAEDFF), // #EAEDFF
  //             Color(0xFFF1E9FF), // #F1E9FF
  //             Color(0xFFF7EAFF), // #F7EAFF
  //           ],
  //         ),
  //       ),
  //       child: Column(
  //         spacing: 8,
  //         crossAxisAlignment:
  //             CrossAxisAlignment.start, // align-items: flex-start
  //         children: [
  //           Obx(() {
  //             final lang = DI.login.sessionLang.value;
  //             final name = lang?.label ?? 'English';
  //             return RichText(
  //               text: TextSpan(
  //                 children: [
  //                   TextSpan(
  //                     text: 'Al’s language is',
  //                     style: TextStyle(
  //                       fontSize: 14,
  //                       fontWeight: FontWeight.w500,
  //                       color: Colors.black,
  //                     ),
  //                   ),
  //                   TextSpan(
  //                     text: ' $name',
  //                     style: TextStyle(
  //                       fontSize: 14,
  //                       fontWeight: FontWeight.w600,
  //                       color: Color(0xFF63538F),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           }),
  //           Text(
  //             'Click save button to confirm',
  //             style: TextStyle(
  //               fontSize: 11,
  //               fontWeight: FontWeight.w500,
  //               color: Color(0xFF63538F),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildCursor() {
  //   return ValueListenableBuilder<AzListCursorInfoModel?>(
  //     valueListenable: cursorInfo,
  //     builder:
  //         (BuildContext context, AzListCursorInfoModel? value, Widget? child) {
  //           Widget resultWidget = Container();
  //           double top = 0;
  //           double right = indexBarWidth + 8;
  //           if (value == null) {
  //             resultWidget = const SizedBox.shrink();
  //           } else {
  //             double titleSize = 80;
  //             top = value.offset.dy - titleSize * 0.5;
  //             resultWidget = AzListCursor(size: titleSize, title: value.title);
  //           }
  //           resultWidget = Positioned(
  //             top: top,
  //             right: right,
  //             child: resultWidget,
  //           );
  //           return resultWidget;
  //         },
  //   );
  // }

  // Widget _buildIndexBar() {
  //   return Container(
  //     key: indexBarContainerKey,
  //     width: indexBarWidth,
  //     alignment: Alignment.center,
  //     child: AzListIndexBar(
  //       parentKey: indexBarContainerKey,
  //       symbols: symbols,
  //       onSelectionUpdate: (index, cursorOffset) {
  //         cursorInfo.value = AzListCursorInfoModel(
  //           title: symbols[index],
  //           offset: cursorOffset,
  //         );
  //         final sliverContext = sliverContextMap[index];
  //         if (sliverContext == null) return;
  //         observerController.jumpTo(index: 0, sliverContext: sliverContext);
  //       },
  //       onSelectionEnd: () {
  //         cursorInfo.value = null;
  //       },
  //     ),
  //   );
  // }

  Widget _buildSliver({required int index, required AzListContactModel model}) {
    final names = model.names;
    if (names.isEmpty) return const SliverToBoxAdapter();
    Widget resultWidget = SliverList(
      delegate: SliverChildBuilderDelegate((context, itemIndex) {
        if (sliverContextMap[index] == null) {
          sliverContextMap[index] = context;
        }
        return Obx(
          () => AzListItemView(
            name: names[itemIndex],
            isChoosed: names[itemIndex] == choosedName.value,
            onTap: () {
              debugPrint('click  - ${model.section} - ${names[itemIndex]}');
              choosedName.value = names[itemIndex];
              // 保存选中的语言对象
              if (model.langs != null && itemIndex < model.langs!.length) {
                selectedLang = model.langs![itemIndex];
                debugPrint(
                  'Selected lang: ${selectedLang?.label} - ${selectedLang?.value}',
                );
              }
            },
          ),
        );
      }, childCount: names.length),
    );
    resultWidget = SliverStickyHeader(
      header: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          model.section,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      sliver: resultWidget,
    );
    return resultWidget;
  }
}
