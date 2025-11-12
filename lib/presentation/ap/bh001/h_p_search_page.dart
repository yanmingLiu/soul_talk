import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/domain/entities/figure.dart';
import 'package:soul_talk/presentation/ap/bh001/h_c_serach_bloc.dart';
import 'package:soul_talk/presentation/v000/base_scaffold.dart';
import 'package:soul_talk/presentation/v000/empty_view.dart';
import 'package:soul_talk/presentation/v000/nav_back_btn.dart';
import 'package:soul_talk/presentation/v000/v_button.dart';
import 'package:soul_talk/presentation/v000/v_image.dart';
import 'package:soul_talk/router/app_routers.dart';

class HSearchPage extends StatefulWidget {
  const HSearchPage({super.key});

  @override
  State<HSearchPage> createState() => _HSearchPageState();
}

class _HSearchPageState extends State<HSearchPage> {
  final focusNode = FocusNode();
  final textController = TextEditingController();
  final scrollController = ScrollController();

  final ctr = Get.put(SearchBloc());

  @override
  void initState() {
    super.initState();
    focusNode.requestFocus();

    // 添加滚动监听器，滚动时关闭键盘
    scrollController.addListener(() {
      if (scrollController.position.isScrollingNotifier.value) {
        focusNode.unfocus();
      }
    });
  }

  @override
  void dispose() {
    focusNode.unfocus();
    focusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        focusNode.unfocus();
      },
      child: BaseScaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
          titleSpacing: 0.0,
          leadingWidth: 48,
          leading: NavBackBtn(color: Colors.black),
          title: Container(
            height: 48,
            width: double.infinity,
            margin: const EdgeInsetsDirectional.only(end: 16),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: TextField(
                      onChanged: (query) {
                        // 更新 searchQuery
                        ctr.searchQuery.value = query;
                      },
                      autofocus: false,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: () {},
                      minLines: 1,
                      maxLength: 20,
                      style: const TextStyle(
                        height: 1,
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      controller: textController,
                      enableInteractiveSelection: true, // 确保文本选择功能启用
                      dragStartBehavior: DragStartBehavior.down, // 优化拖拽行为
                      decoration: InputDecoration(
                        hintText: 'Type a Name to find Sirens',
                        counterText: '', // 去掉字数显示
                        hintStyle: const TextStyle(color: Color(0xFFD9D9D9)),
                        fillColor: Colors.transparent,
                        border: InputBorder.none,
                        filled: true,
                        isDense: true,
                      ),
                      focusNode: focusNode,
                    ),
                  ),
                ),
                VButton(
                  width: 44,
                  height: 44,
                  color: Colors.transparent,
                  onTap: () {
                    ctr.searchQuery.value = textController.text;
                  },
                  child: Center(
                    child: Image.asset(
                      'assets/images/search_tf.png',
                      width: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Obx(() {
            final list = ctr.list;
            final type = ctr.type.value;

            if (type != null) {
              return GestureDetector(
                child: EmptyView(type: type),
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              );
            }

            return _buildList(list);
          }),
        ),
      ),
    );
  }

  Widget _buildList(List<Figure> list) {
    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      itemCount: list.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final role = list[index];
        final isCollect = role.collect ?? false;

        return Container(
          height: 180,
          padding: EdgeInsets.all(12),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: const Color(0x0F000000), width: 1.0),
          ),
          child: Row(
            spacing: 16,
            children: [
              VImage(
                url: role.avatar,
                width: 100,
                height: 162,
                borderRadius: BorderRadius.circular(16.0),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      spacing: 8,
                      children: [
                        Flexible(
                          child: Text(
                            role.name ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (role.age != null)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0x80DF78B1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              role.age.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                      ],
                    ),

                    Text(
                      role.aboutMe ?? '',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: const TextStyle(
                        color: Color(0xFF8C8C8C),
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),

                    Row(
                      children: [
                        VButton(
                          onTap: () {
                            ctr.onCollect(index, role);
                          },
                          height: 32,
                          child: Center(
                            child: Row(
                              spacing: 4,
                              children: [
                                Image.asset(
                                  isCollect
                                      ? 'assets/images/like_s.png'
                                      : 'assets/images/like_d.png',
                                  width: 12,
                                ),
                                Text(
                                  role.sessionCount?.toString() ?? '',
                                  style: TextStyle(
                                    color: isCollect
                                        ? Color(0xFFDF78B1)
                                        : Color(0xFF8C8C8C),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Spacer(),
                        VButton(
                          onTap: () {
                            AppRoutes.pushChat(role.id);
                          },
                          height: 32,
                          width: 90,
                          type: ButtonType.border,
                          borderRadius: BorderRadius.circular(12),
                          borderColor: Color(0xFFDF78B1),
                          child: Center(
                            child: Text(
                              'Chat',
                              style: const TextStyle(
                                color: Color(0xFFDF78B1),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
