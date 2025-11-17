import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/domain/entities/tag.dart';
import 'package:soul_talk/presentation/ap/bh001/c/h_bloc.dart';
import 'package:soul_talk/presentation/v000/linked_item.dart';
import 'package:soul_talk/presentation/v000/loading.dart';
import 'package:soul_talk/presentation/v000/nav_back_btn.dart';
import 'package:soul_talk/presentation/v000/v_button.dart';

class TagChooseScreen extends StatefulWidget {
  const TagChooseScreen({super.key});

  @override
  State<TagChooseScreen> createState() => _TagChooseScreenState();
}

class _TagChooseScreenState extends State<TagChooseScreen> {
  final ctr = Get.find<HomeBloc>();

  TagReponse? selectedType;

  final _selectTags = <Tag>{}.obs;

  @override
  void initState() {
    super.initState();

    loadData();
  }

  void loadData() async {
    if (ctr.roleTags.isEmpty) {
      Loading.show();
      await ctr.loadTags();
      Loading.dismiss();
    }

    selectedType = ctr.roleTags.firstOrNull;
    _selectTags.assignAll(ctr.selectTags);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0x40000000),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 40),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                NavBackBtn(color: Colors.black),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              spacing: 8,
              children: [
                Image.asset(
                  'assets/images/star.png',
                  width: 20,
                ),
                const Text(
                  'Choose your tags',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFF181818),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildType(),
            const SizedBox(height: 16),
            Expanded(child: _buildTags()),
            const SizedBox(height: 16),
            VButton(
              color: const Color(0xFF55CFDA),
              height: 48,
              borderRadius: BorderRadius.circular(16),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              onTap: () {
                ctr.selectTags.assignAll(_selectTags);
                Get.back();
                ctr.filterEvent.value = (
                  Set<Tag>.from(ctr.selectTags),
                  DateTime.now().millisecondsSinceEpoch,
                );
                ctr.filterEvent.refresh();
              },
              child: const Center(
                child: Text(
                  'Confirm',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAllBtn() {
    return Obx(() {
      final tags = selectedType?.tags;

      bool containsAll = false;
      if (tags != null && tags.isNotEmpty) {
        containsAll = _selectTags.containsAll(tags);
      }
      return VButton(
        onTap: () {
          if (containsAll) {
            _selectTags.removeAll(tags ?? []);
          } else {
            _selectTags.addAll(tags ?? []);
          }
          setState(() {});
        },
        child: Center(
          child: Text(
            containsAll ? 'Unselect All' : 'select All',
            style: const TextStyle(
              color: Color(0xFF595959),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTags() {
    final tags = selectedType?.tags;
    if (tags == null || tags.isEmpty) {
      return const SizedBox();
    }

    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          direction: Axis.horizontal, // 显示为水平布局
          alignment: WrapAlignment.start,
          children: tags.map((e) {
            return GestureDetector(
              onTap: () {
                if (_selectTags.contains(e)) {
                  _selectTags.remove(e);
                } else {
                  _selectTags.add(e);
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [_buildItem(e)],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildItem(Tag e) {
    return Obx(() {
      var isSelected = _selectTags.contains(e);
      return Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          color: isSelected ? const Color(0xFFDF78B1) : const Color(0x0F595959),
        ),
        child: Center(
          child: Text(
            e.name ?? '',
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFFFFFFFF)
                  : const Color(0xFF595959),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildType() {
    var tags = ctr.roleTags;
    if (tags.isEmpty) {
      return const SizedBox.shrink();
    }
    List<TagReponse> result = (tags.length > 2) ? tags.take(2).toList() : tags;

    TagReponse type1 = result[0];

    TagReponse? type2;
    if (result.length > 1) {
      type2 = result[1];
    }

    return SizedBox(
      height: 36,
      width: double.infinity,
      child: Row(
        spacing: 20,
        mainAxisSize: MainAxisSize.min,
        children: [
          LinkedItem(
            title: type1.labelType ?? '',
            isActive: type1 == selectedType,
            onTap: () {
              if (mounted) {
                setState(() {
                  selectedType = type1;
                });
              }
            },
          ),
          if (type2 != null) ...[
            LinkedItem(
              title: type2.labelType ?? '',
              isActive: type2 == selectedType,
              onTap: () {
                if (mounted) {
                  setState(() {
                    selectedType = type2;
                  });
                }
              },
            )
          ],
          const Spacer(),
          _buildAllBtn(),
        ],
      ),
    );
  }
}
