import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/domain/entities/figure.dart';
import 'package:soul_talk/presentation/ap/bh001/h_c_serach_bloc.dart';
import 'package:soul_talk/presentation/v000/base_scaffold.dart';
import 'package:soul_talk/presentation/v000/empty_view.dart';
import 'package:soul_talk/presentation/v000/v_button.dart';

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
          titleSpacing: 0.0,
          leadingWidth: 48,
          leading: VButton(
            width: 44,
            height: 44,
            color: Colors.transparent,
            onTap: () => Get.back(),
            child: Center(
              child: Image.asset('assets/images/navbackbtn.png', width: 24),
            ),
          ),
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
                    child: Image.asset('assets/images/search.png', width: 24),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: list.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final data = list[index];
        return Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
        );
      },
    );
  }
}
