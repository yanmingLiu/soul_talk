import 'package:flutter/material.dart';
import 'package:soul_talk/presentation/ap/ec004/v/v_c.dart';
import 'package:soul_talk/presentation/v000/base_scaffold.dart';
import 'package:soul_talk/presentation/v000/k_a_w.dart';
import 'package:soul_talk/presentation/v000/linked_controller.dart';
import 'package:soul_talk/presentation/v000/linked_item.dart';

class CTabPage extends StatefulWidget {
  const CTabPage({super.key});

  @override
  State<CTabPage> createState() => _CTabPageState();
}

class _CTabPageState extends State<CTabPage> {
  late List<String> tabTitles = [];
  late List<Widget> tabContents = [];
  late LinkedController _linkedController;

  @override
  void initState() {
    super.initState();

    tabTitles = [
      'AI Photo',
      'Image to video',
    ];

    tabContents = [
      const KeepAliveWrapper(
        child: VC(key: ValueKey(3645), type: VCEnum.image),
      ),
      const KeepAliveWrapper(
        child: VC(key: ValueKey(3640), type: VCEnum.video),
      ),
    ];

    _linkedController = LinkedController(items: tabTitles);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: AnimatedBuilder(
        animation: _linkedController,
        builder: (_, child) {
          return Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top),
              buildCategory(),
              Expanded(
                child: PageView(
                  controller: _linkedController.pageController,
                  pageSnapping: true,
                  onPageChanged: (index) {
                    _linkedController.handlePageChanged(index);
                  },
                  physics: const BouncingScrollPhysics(),
                  children: tabContents,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildCategory() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int index = 0; index < tabTitles.length; index++) ...[
            LinkedItem(
              key: _linkedController.getTabKey(index),
              title: tabTitles[index],
              isActive: _linkedController.index == index,
              onTap: () {
                _linkedController.select(index);
              },
            ),
            if (index != tabTitles.length - 1) const SizedBox(width: 24),
          ],
        ],
      ),
    );
  }
}
